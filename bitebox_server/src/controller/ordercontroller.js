const db = require('../config/db');

// POST /orders  (student)
exports.placeOrder = async (req, res) => {
  // student_id comes from the verified JWT, not the request body
  const student_id = req.user.cms_id;
  const { restaurant_id, items, total_amount, payment_method, note } = req.body;

  if (!restaurant_id || !items?.length || !total_amount || !payment_method) {
    return res.status(400).json({ message: 'Missing required fields' });
  }

  const client = await db.getClient();
  try {
    await client.query('BEGIN');

    // if paying by tab, check limit before writing anything
    if (payment_method === 'tab') {
      const studentResult = await client.query(
        'SELECT pending_balance, max_limit FROM students WHERE cms_id = $1',
        [student_id]
      );
      const student = studentResult.rows[0];
      if (!student) {
        await client.query('ROLLBACK');
        return res.status(404).json({ message: 'Student not found' });
      }
      const newBalance = parseFloat(student.pending_balance) + parseFloat(total_amount);
      if (newBalance > parseFloat(student.max_limit)) {
        await client.query('ROLLBACK');
        return res.status(400).json({
          message: `Tab limit exceeded. Limit: ${student.max_limit}, Current: ${student.pending_balance}`,
        });
      }
    }

    // insert order
    const orderResult = await client.query(
      `INSERT INTO orders
         (student_id, restaurant_id, total_amount, payment_method, status)
       VALUES ($1, $2, $3, $4, 'pending')
       RETURNING *`,
      [student_id, restaurant_id, total_amount, payment_method]
    );
    const order = orderResult.rows[0];

    // insert all order items
    for (const item of items) {
      await client.query(
        `INSERT INTO order_items (order_id, menu_item_id, quantity, price_at_purchase)
         VALUES ($1, $2, $3, $4)`,
        [order.id, item.menu_item_id, item.quantity, item.price_at_purchase]
      );
    }

    // update student balance / last_order_at
    if (payment_method === 'tab') {
      await client.query(
        `UPDATE students
         SET pending_balance = pending_balance + $1, last_order_at = NOW()
         WHERE cms_id = $2`,
        [total_amount, student_id]
      );
    } else {
      await client.query(
        'UPDATE students SET last_order_at = NOW() WHERE cms_id = $1',
        [student_id]
      );
    }

    await client.query('COMMIT');

    // fetch full order with items for response
    const itemsResult = await db.query(
      `SELECT oi.*, mi.name FROM order_items oi
       JOIN menu_items mi ON oi.menu_item_id = mi.id
       WHERE oi.order_id = $1`,
      [order.id]
    );

    return res.status(201).json({ ...order, items: itemsResult.rows });
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('placeOrder error:', err.message);
    return res.status(500).json({ message: 'Server error' });
  } finally {
    client.release();
  }
};

// GET /orders?restaurant_id=x&status=y  (staff)
exports.getOrders = async (req, res) => {
  const { restaurant_id, status } = req.query;

  if (!restaurant_id) {
    return res.status(400).json({ message: 'restaurant_id required' });
  }

  try {
    let query = `
      SELECT o.*,
             COALESCE(json_agg(json_build_object(
               'id',                oi.id,
               'menu_item_id',      oi.menu_item_id,
               'name',              mi.name,
               'quantity',          oi.quantity,
               'price_at_purchase', oi.price_at_purchase
             )) FILTER (WHERE oi.id IS NOT NULL), '[]') AS items
      FROM orders o
      LEFT JOIN order_items oi ON oi.order_id = o.id
      LEFT JOIN menu_items  mi ON mi.id = oi.menu_item_id
      WHERE o.restaurant_id = $1
    `;
    const params = [restaurant_id];

    if (status) {
      query += ` AND o.status = $2`;
      params.push(status);
    }

    query += ' GROUP BY o.id ORDER BY o.created_at DESC';

    const result = await db.query(query, params);
    return res.status(200).json(result.rows);
  } catch (err) {
    console.error('getOrders error:', err.message);
    return res.status(500).json({ message: 'Server error' });
  }
};

// PATCH /orders/:id/status  (staff)
exports.updateOrderStatus = async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  const validStatuses = ['pending', 'preparing', 'ready', 'completed'];
  if (!validStatuses.includes(status)) {
    return res.status(400).json({ message: 'Invalid status' });
  }

  try {
    const result = await db.query(
      `UPDATE orders SET status = $1 WHERE id = $2 RETURNING *`,
      [status, id]
    );
    if (!result.rows[0]) {
      return res.status(404).json({ message: 'Order not found' });
    }
    return res.status(200).json(result.rows[0]);
  } catch (err) {
    console.error('updateOrderStatus error:', err.message);
    return res.status(500).json({ message: 'Server error' });
  }
};