const express = require("express");
const router = express.Router();
const controller = require("../controller/auth_adminController");
const { required } = require('../middleware/validate');

router.post('/student',         required(['cms_id']), controller.studentLogin);
router.post('/staff/login',     required(['email', 'password']), controller.staffLogin);
router.post('/forgot-password', required(['email']), controller.forgotPassword);
router.post('/verify-otp',      required(['email', 'otp']), controller.verifyOtp);
router.post('/reset-password',  required(['reset_token', 'new_password']), controller.resetPassword);
module.exports = router;
