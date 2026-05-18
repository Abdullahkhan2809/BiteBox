const db = require('../config/db');

// GET /api/menu/:restaurant_id
exports.getMenuItems = async (req, res) => {
  const { restaurant_id } = req.params;
  try {
    const result = await db.query(
      `SELECT * FROM menu_items
       WHERE restaurant_id = $1 AND is_available = true
       ORDER BY category`,
      [restaurant_id]
    );
    return res.status(200).json(result.rows);
  } catch (err) {
    console.error('getMenuItems error:', err.message);
    return res.status(500).json({ message: 'Server error' });
  }
};

// POST /api/menu  (manager only)
exports.addMenuItem = async (req, res) => {
  const { restaurant_id, name, description, price, category, image_url } = req.body;

  if (!restaurant_id || !name || !price) {
    return res.status(400).json({ message: 'restaurant_id, name, price required' });
  }

  try {
    const result = await db.query(
      `INSERT INTO menu_items
         (restaurant_id, name, description, price, category, image_url)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING *`,
      [restaurant_id, name, description, price, category, image_url]
    );
    return res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('addMenuItem error:', err.message);
    return res.status(500).json({ message: 'Server error' });
  }
};

// PATCH /api/menu/:id  (manager only)
exports.updateMenuItem = async (req, res) => {
  const { id } = req.params;
  const { name, description, price, is_available, image_url } = req.body;

  try {
    const result = await db.query(
      `UPDATE menu_items
       SET
         name         = COALESCE($1, name),
         description  = COALESCE($2, description),
         price        = COALESCE($3, price),
         is_available = COALESCE($4, is_available),
         image_url    = COALESCE($5, image_url)
       WHERE id = $6
       RETURNING *`,
      [name, description, price, is_available, image_url, id]
    );

    if (!result.rows[0]) {
      return res.status(404).json({ message: 'Item not found' });
    }
    return res.status(200).json(result.rows[0]);
  } catch (err) {
    console.error('updateMenuItem error:', err.message);
    return res.status(500).json({ message: 'Server error' });
  }
};

// DELETE /api/menu/:id  (manager only)
exports.deleteMenuItem = async (req, res) => {
  const { id } = req.params;
  try {
    const result = await db.query(
      'DELETE FROM menu_items WHERE id = $1 RETURNING id',
      [id]
    );
    if (!result.rows[0]) {
      return res.status(404).json({ message: 'Item not found' });
    }
    return res.status(200).json({ message: 'Item deleted' });
  } catch (err) {
    console.error('deleteMenuItem error:', err.message);
    return res.status(500).json({ message: 'Server error' });
  }
};