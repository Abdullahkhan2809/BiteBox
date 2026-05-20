const db = require('../config/db');

// GET /analytics/daily?restaurant_id=x
exports.getDailyStats = async (req, res) => {
  const { restaurant_id } = req.query;
  if (!restaurant_id) {
    return res.status(400).json({ message: 'restaurant_id required' });
  }

  try {
    const result = await db.query(`
      WITH date_series AS (
        SELECT generate_series(
          CURRENT_DATE - INTERVAL '6 days',
          CURRENT_DATE,
          INTERVAL '1 day'
        )::date AS day
      )
      SELECT
        TO_CHAR(d.day, 'YYYY-MM-DD')   AS date,
        TO_CHAR(d.day, 'Dy')           AS label,
        COALESCE(COUNT(o.id), 0)::int  AS order_count,
        COALESCE(SUM(o.total_amount), 0)::numeric AS revenue
      FROM date_series d
      LEFT JOIN orders o
        ON DATE(o.created_at) = d.day
        AND o.restaurant_id = $1
        AND o.status != 'cancelled'
      GROUP BY d.day
      ORDER BY d.day ASC
    `, [restaurant_id]);

    return res.status(200).json(result.rows);
  } catch (err) {
    console.error('getDailyStats error:', err.message);
    return res.status(500).json({ message: 'Server error' });
  }
};
