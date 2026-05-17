const express      = require('express');
const router       = express.Router();
const controller   = require('../controller/menuControllers');
const auth         = require('../middleware/auth_middleware');
const relocheck    = require('../middleware/relocheck');


router.get('/:restaurant_id',  auth, controller.getMenuItems);
router.post('/',               auth, relocheck(['cafe_manager', 'super_admin']), controller.addMenuItem);
router.patch('/:id',           auth, relocheck(['cafe_manager', 'super_admin']), controller.updateMenuItem);
router.delete('/:id',          auth, relocheck(['cafe_manager', 'super_admin']), controller.deleteMenuItem);

module.exports = router;