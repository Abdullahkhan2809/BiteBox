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

const app = express();

app.use(cors());
app.use(express.json());
app.use('/upload', uploadRoutes);

// mount routes
app.use('/auth',         authRoutes);
app.use('/menu',         menuRoutes);
app.use('/orders',       orderRoutes);
app.use('/restaurants',  restaurantRoutes);

app.get('/', (req, res) => res.send('BiteBox API running'));

const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n🚀 Server running on port ${PORT}`);
});