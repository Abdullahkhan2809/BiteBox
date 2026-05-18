require('dotenv').config();
const bcrypt = require('bcryptjs');
const db     = require('../config/db');

async function createAdmin() {
  const email    = 'admin@bitebox.com';
  const password = 'Admin@1234';
  const name     = 'BiteBox Admin';

  const hash = await bcrypt.hash(password, 10);

  await db.query(
    `INSERT INTO user_admin (university_id, restaurant_id, name, email, password_hash, role)
     VALUES (1, 1, $1, $2, $3, 'cafe_manager')
     ON CONFLICT (email) DO NOTHING`,
    [name, email, hash]
  );

  console.log('✅ Admin created');
  console.log(`   Email:    ${email}`);
  console.log(`   Password: ${password}`);
  process.exit(0);
}

createAdmin().catch(err => {
  console.error('Failed:', err.message);
  process.exit(1);
});