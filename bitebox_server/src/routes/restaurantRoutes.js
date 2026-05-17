const express  = require('express');
const router   = express.Router();
const auth     = require('../middleware/auth_middleware');
const relocheck = require('../middleware/relocheck');
const db       = require('../config/db');

// GET /api/restaurants?university_id=1
router.get('/', auth, async (req, res) => {
  const { university_id } = req.query;
  try {
    const result = await db.query(
      'SELECT * FROM restaurants WHERE university_id = $1 AND is_open = true',
      [university_id || 1]
    );
    return res.status(200).json(result.rows);
  } catch (err) {
    return res.status(500).json({ message: 'Server error' });
  }
});

// PATCH /api/restaurants/:id  (manager only)
router.patch('/:id', auth, relocheck(['cafe_manager', 'super_admin']), async (req, res) => {
  const { is_open } = req.body;
  try {
    const result = await db.query(
      'UPDATE restaurants SET is_open = $1 WHERE id = $2 RETURNING *',
      [is_open, req.params.id]
    );
    return res.status(200).json(result.rows[0]);
  } catch (err) {
    return res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;