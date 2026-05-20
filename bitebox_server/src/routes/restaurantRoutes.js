const express   = require('express');
const router    = express.Router();
const auth      = require('../middleware/auth_middleware');
const relocheck = require('../middleware/relocheck');
const db        = require('../config/db');

// GET /restaurants?university_id=1
// Public — no auth required; students browse before logging in (lazy auth)
router.get('/', async (req, res) => {
  const { university_id } = req.query;
  try {
    const result = await db.query(
      `SELECT r.id,
              r.name,
              r.category       AS cuisine,
              r.is_open,
              r.university_id,
              ''               AS image_url,
              0.0::float       AS rating,
              0::int           AS review_count,
              COALESCE(
                json_agg(
                  json_build_object(
                    'id',            mi.id,
                    'name',          mi.name,
                    'description',   mi.description,
                    'price',         mi.price::float,
                    'category',      mi.category,
                    'image_url',     mi.image_url,
                    'restaurant_id', mi.restaurant_id,
                    'is_available',  mi.is_available
                  )
                ) FILTER (WHERE mi.id IS NOT NULL),
                '[]'
              ) AS menu
       FROM restaurants_category r
       LEFT JOIN menu_items mi
         ON mi.restaurant_id = r.id
        AND COALESCE(mi.is_available, true) = true
       WHERE r.university_id = $1 AND r.is_open = true
       GROUP BY r.id`,
      [university_id || 1]
    );
    return res.status(200).json(result.rows);
  } catch (err) {
    console.error('getRestaurants error:', err.message);
    return res.status(500).json({ message: 'Server error' });
  }
});

// PATCH /restaurants/:id  (manager only)
router.patch('/:id', auth, relocheck(['cafe_manager', 'super_admin']), async (req, res) => {
  const { is_open } = req.body;
  try {
    const result = await db.query(
      'UPDATE restaurants_category SET is_open = $1 WHERE id = $2 RETURNING *',
      [is_open, req.params.id]
    );
    return res.status(200).json(result.rows[0]);
  } catch (err) {
    console.error('toggleRestaurant error:', err.message);
    return res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;