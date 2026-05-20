const express    = require('express');
const router     = express.Router();
const controller = require('../controller/analyticsController');
const auth       = require('../middleware/auth_middleware');
const relocheck  = require('../middleware/relocheck');

// GET /analytics/daily?restaurant_id=x
router.get('/daily', auth, relocheck(['staff', 'cafe_manager']), controller.getDailyStats);

module.exports = router;
