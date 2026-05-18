require('dotenv').config();
const db = require('../config/db');

async function seed() {
  console.log('🌱 Seeding database...');

  try {
    // 1. UNIVERSITY
    await db.query(`
      INSERT INTO university (id, name, location, domain_name)
      VALUES (1, 'NBC', 'Quetta', 'nust.edu.pk')
      ON CONFLICT (id) DO NOTHING;
    `);

    // 2. RESTAURANT
    await db.query(`
      INSERT INTO restaurants_category (id, university_id, name, category, is_open)
      VALUES (1, 1, 'Cafeteria 1', 'Fast Food', true)
      ON CONFLICT (id) DO NOTHING;
    `);

    // 3. MENU ITEMS
    await db.query(`
      INSERT INTO menu_items (restaurant_id, name, description, price, category, is_available)
      VALUES
        (1, 'Zinger Burger',   'Crispy zinger patty with sauce',    350, 'Fast Food',  true),
        (1, 'Spicy Biryani',   'Karachi style chicken biryani',     280, 'Fast Food',  true),
        (1, 'Cold Coffee',     'Blended iced coffee with cream',    180, 'Beverages',  true),
        (1, 'Chocolate Shake', 'Rich chocolate milkshake',          200, 'Beverages',  true),
        (1, 'Gulab Jamun',     'Soft fried dough balls in syrup',   120, 'Desserts',   true),
        (1, 'Brownie Slice',   'Fudgy chocolate brownie',           150, 'Desserts',   true)
      ON CONFLICT DO NOTHING;
    `);

    console.log('✅ Seed complete');
    process.exit(0);

  } catch (err) {
    console.error('❌ Seed failed:', err.message);
    process.exit(1);
  }
}

seed();