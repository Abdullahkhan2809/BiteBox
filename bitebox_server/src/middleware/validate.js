// generic validator — pass a list of required field names
const required = (fields) => (req, res, next) => {
  const missing = fields.filter(f => req.body[f] === undefined || req.body[f] === null);
  if (missing.length > 0) {
    return res.status(400).json({
      message: `Missing required fields: ${missing.join(', ')}`,
    });
  }
  next();
};

module.exports = { required };