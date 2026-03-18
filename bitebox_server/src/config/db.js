const { Pool } = require('pg');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../../.env') });

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

// A robust, self-executing test function
const testConnection = async () => {
  console.log("🔄 Attempting to connect to PostgreSQL...");
  try {
    const res = await pool.query('SELECT NOW()');
    console.log('✅ DATABASE CONNECTED!');
    console.log(`🕒 Database Time: ${res.rows[0].now}`);
    
    // We exit the process manually after a successful test
    process.exit(0); 
  } catch (err) {
    console.error('❌ CONNECTION FAILED:');
    console.error(err.message);
    process.exit(1);
  }
};

testConnection();

module.exports = {
  query: (text, params) => pool.query(text, params),
};