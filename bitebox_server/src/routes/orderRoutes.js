const express    = require('express');
const router     = express.Router();
const controller = require('../controller/ordercontroller');
const auth       = require('../middleware/auth_middleware');
const relocheck  = require('../middleware/relocheck');
const { required } = require('../middleware/validate');

router.post('/',
  auth,
  required(['student_id', 'restaurant_id', 'items', 'total_amount', 'payment_method']),
  controller.placeOrder,
);

router.get('/',
  auth,
  relocheck(['staff', 'cafe_manager']),
  controller.getOrders,
);

router.patch('/:id/status',
  auth,
  relocheck(['staff', 'cafe_manager']),
  controller.updateOrderStatus,
);

module.exports = router;