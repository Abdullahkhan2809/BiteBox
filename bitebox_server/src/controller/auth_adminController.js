const bcrypt    = require('bcryptjs');
const jwt       = require('jsonwebtoken');
const db        = require('../config/db');
const Student   = require('../models/studentmodel');
const generateOTP = require('../utils/otp');

// STUDENT LAZY AUTH 
// POST /auth/student
// body: { cms_id, university_id }
exports.studentLogin = async (req, res) => {
  const { cms_id, university_id } = req.body;

  if (!cms_id) {
    return res.status(400).json({ message: 'CMS ID is required' });
  }

  try {
    const student = await Student.findOrCreate(
      cms_id,
      university_id || 1  // default university_id = 1 for now
    );

    const token = jwt.sign(
      { cms_id: student.cms_id, role: 'student' },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    return res.status(200).json({
      token,
      student: {
        cms_id:          student.cms_id,
        name:            student.name,
        pending_balance: student.pending_balance,
        max_limit:       student.max_limit,
      },
    });
  } catch (err) {
    console.error('studentLogin error:', err.message);
    return res.status(500).json({ message: 'Server error' });
  }
};

// STAFF / MANAGER LOGIN 
// POST /auth/staff/login
// body: { email, password }
exports.staffLogin = async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email and password required' });
  }

  try {
    const result = await db.query(
      'SELECT * FROM users WHERE email = $1',
      [email]
    );

    const user = result.rows[0];
    if (!user) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    const isMatch = await bcrypt.compare(password, user.password_hash);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    const token = jwt.sign(
      {
        user_id:       user.id,
        role:          user.role,
        restaurant_id: user.restaurant_id,
      },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    return res.status(200).json({
      token,
      role:          user.role,
      restaurant_id: user.restaurant_id,
      name:          user.name,
    });
  } catch (err) {
    console.error('staffLogin error:', err.message);
    return res.status(500).json({ message: 'Server error' });
  }
};

//  FORGOT PASSWORD 
// POST /auth/forgot-password
// body: { email }
exports.forgotPassword = async (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ message: 'Email is required' });
  }

  try {
    const result = await db.query(
      'SELECT * FROM users WHERE email = $1',
      [email]
    );

    if (!result.rows[0]) {
      // don't reveal whether email exists
      return res.status(200).json({ message: 'If this email exists, an OTP has been sent' });
    }

    const otp = generateOTP();

    // store OTP in DB with expiry
    await db.query(
      `UPDATE users SET reset_otp = $1, reset_otp_expiry = NOW() + INTERVAL '10 minutes'
       WHERE email = $2`,
      [otp, email]
    );

    // Phase 7: send real email here
    console.log(`OTP for ${email}: ${otp}`);

    return res.status(200).json({ message: 'OTP sent to email' });
  } catch (err) {
    console.error('forgotPassword error:', err.message);
    return res.status(500).json({ message: 'Server error' });
  }
};

//  VERIFY OTP 
// POST /auth/verify-otp
// body: { email, otp }
exports.verifyOtp = async (req, res) => {
  const { email, otp } = req.body;

  try {
    const result = await db.query(
      `SELECT * FROM users
       WHERE email = $1
       AND reset_otp = $2
       AND reset_otp_expiry > NOW()`,
      [email, otp]
    );

    if (!result.rows[0]) {
      return res.status(400).json({ message: 'Invalid or expired OTP' });
    }

    // generate a short-lived reset token
    const resetToken = jwt.sign(
      { email, purpose: 'reset' },
      process.env.JWT_SECRET,
      { expiresIn: '15m' }
    );

    return res.status(200).json({ reset_token: resetToken });
  } catch (err) {
    console.error('verifyOtp error:', err.message);
    return res.status(500).json({ message: 'Server error' });
  }
};

// ── RESET PASSWORD ────────────────────────────────────────────────────────
// POST /auth/reset-password
// body: { reset_token, new_password }
exports.resetPassword = async (req, res) => {
  const { reset_token, new_password } = req.body;

  try {
    const decoded = jwt.verify(reset_token, process.env.JWT_SECRET);

    if (decoded.purpose !== 'reset') {
      return res.status(400).json({ message: 'Invalid token' });
    }

    const hash = await bcrypt.hash(new_password, 10);

    await db.query(
      `UPDATE users
       SET password_hash = $1, reset_otp = NULL, reset_otp_expiry = NULL
       WHERE email = $2`,
      [hash, decoded.email]
    );

    return res.status(200).json({ message: 'Password reset successfully' });
  } catch (err) {
    console.error('resetPassword error:', err.message);
    return res.status(400).json({ message: 'Invalid or expired token' });
  }
};