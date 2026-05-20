const express = require('express');
const cors    = require('cors');
require('dotenv').config();

// db connection (just importing triggers the connection test)
require('./config/db');

// routes
const uploadRoutes = require('./routes/uploadRoutes');

const authRoutes       = require('./routes/auth_adminRoute');
const menuRoutes       = require('./routes/menuRoutes');
const orderRoutes      = require('./routes/orderRoutes');
const restaurantRoutes = require('./routes/restaurantRoutes');
const analyticsRoutes  = require('./routes/analyticsRoutes');

const app = express();

app.use(cors());
app.use((req, res, next) => {
  express.json()(req, res, (err) => {
    if (err) {
      console.error(`[JSON parse error] ${req.method} ${req.path} — ${err.message}`);
      return res.status(400).json({ message: 'Invalid JSON body' });
    }
    next();
  });
});
app.use((req, res, next) => {
  console.log(`${req.method} ${req.path}`);
  next();
});
app.use('/upload', uploadRoutes);

// mount routes
app.use('/auth',         authRoutes);
app.use('/menu',         menuRoutes);
app.use('/orders',       orderRoutes);
app.use('/restaurants',  restaurantRoutes);
app.use('/analytics',    analyticsRoutes);

app.get('/', (req, res) => res.send('BiteBox API running'));

const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n🚀 Server running on port ${PORT}`);
});