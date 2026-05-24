<p align="center">
  <img src="bitebox/assets/images/logo.jpg" alt="BiteBox Logo" width="130"/>
</p>

<h1 align="center">BiteBox</h1>
<p align="center">A university campus food ordering system with lazy student auth and a built-in credit tab.</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter"/>
  <img src="https://img.shields.io/badge/Node.js-18+-green?logo=node.js"/>
  <img src="https://img.shields.io/badge/PostgreSQL-14+-blue?logo=postgresql"/>
  <img src="https://img.shields.io/badge/License-MIT-yellow"/>
</p>

---

## Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Features](#features)
- [Architecture](#architecture)
- [Database Schema](#database-schema)
- [API Reference](#api-reference)
- [Authentication Flow](#authentication-flow)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Roadmap](#roadmap)
- [License](#license)

---

## Overview

BiteBox solves a common university problem: long queues and slow cash-based payments at campus cafes. Students enter their university CMS ID and order in seconds — no sign-up, no password.

The system introduces a **Lazy Auth** model where first-time students are automatically registered on login. Every student gets a **Tab** — a credit balance they can use to defer payment up to a configurable limit. Cafe staff get a live order queue dashboard, and managers get monthly sales analytics.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile App | Flutter |
| Backend | Node.js + Express |
| Database | PostgreSQL |
| Auth | JWT via `jsonwebtoken` |
| DB Driver | `pg` (node-postgres) with connection pooling |
| Local Storage | Hive |
| Secure Token Storage | `flutter_secure_storage` |
| HTTP Client | `http` (Flutter) |
| Dev Server | `nodemon` |

---

## Features

### Student
- **Lazy Auth** — enter CMS ID, done. Auto-registered on first visit, no password ever
- **Multi-restaurant browsing** — all open cafes at the university in one place
- **Menu browsing** — filter by category (Deals, Beverages, etc.)
- **Cart** — add, remove, adjust quantities before placing
- **Dual payment** — pay with cash or deduct from Tab balance
- **Tab tracking** — see pending balance and remaining credit limit
- **Offline-first** — menus cached locally via Hive

### Staff / Cafe Manager
- **Live order queue** — view orders filtered by status
- **Order progression** — tap to move: pending → preparing → ready → completed
- **Tab management** — view and adjust student outstanding balances
- **Analytics** — monthly revenue, order volume, and top-selling items

### Super Admin
- Onboard new universities and cafes
- Create and manage staff/manager accounts across universities

---

## Architecture

BiteBox follows a **Controller → Route → Middleware** pattern on the backend.

```
Flutter App
     │
     │  HTTP + Bearer JWT
     ▼
Express Router
     │
 auth_middleware.js   ← verify JWT
 relocheck.js         ← role-based access
     │
     ▼
Controllers           ← business logic
     │
     ▼
pg Pool → PostgreSQL
```

### Middleware

- **`auth_middleware.js`** — extracts and verifies the JWT Bearer token from the `Authorization` header. Attaches the decoded payload to `req.user`.
- **`relocheck.js`** — restricts routes to specific roles (`super_admin`, `cafe_manager`, `staff`). Applied after auth middleware.

### Flutter Architecture

```
lib/
  services/     ← all API calls, JWT injected per request
  models/       ← Dart data classes (fromJson / toJson)
  screens/      ← UI pages split by auth/, student/, admin/
  widgets/      ← reusable UI components
```

JWT is persisted in `flutter_secure_storage` and attached to every API request as a Bearer token.

---

## Database Schema

```sql

CREATE TABLE university (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    location VARCHAR(255),
    domain_name VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE restaurants_category (
    id SERIAL PRIMARY KEY,
    university_id INT REFERENCES university(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    image_url TEXT,
    is_open BOOLEAN DEFAULT TRUE
);

CREATE TABLE user_admin (
    id SERIAL PRIMARY KEY,
    university_id INT REFERENCES university(id) ON DELETE CASCADE,
    restaurant_id INT REFERENCES restaurants_category(id) ON DELETE SET NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) CHECK (role IN ('super_admin', 'cafe_manager', 'staff')),
    reset_otp VARCHAR(6),
    reset_otp_expiry TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE students (
    cms_id VARCHAR(50) PRIMARY KEY,
    university_id INT REFERENCES university(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    pending_balance DECIMAL(10, 2) DEFAULT 0.00,
    max_limit DECIMAL(10, 2) DEFAULT 5000.00,
    is_active BOOLEAN DEFAULT TRUE,
    contact_number VARCHAR(13) DEFAULT '+92',
    last_order_at TIMESTAMP,
    CONSTRAINT check_positive_balance CHECK (pending_balance >= 0)
);

CREATE TABLE menu_items (
    id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES restaurants_category(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image_url TEXT,
    is_available BOOLEAN DEFAULT TRUE,
    category VARCHAR(50)
);


CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    student_id VARCHAR(50) REFERENCES students(cms_id),
    restaurant_id INT REFERENCES restaurants_category(id),
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(10) CHECK (payment_method IN ('cash', 'tab')),
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id) ON DELETE CASCADE,
    menu_item_id INT REFERENCES menu_items(id),
    quantity INT NOT NULL,
    price_at_purchase DECIMAL(10, 2) NOT NULL
);

```

---

## API Reference

All protected routes require:
```
Authorization: Bearer <jwt_token>
```

### Auth

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/auth/student` | ✗ | Lazy login — auto-registers student if not found, returns JWT |
| POST | `/auth/staff/login` | ✗ | Staff / manager login with email + password |

### Menu

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | `/menu/:restaurant_id` | ✓ | Get available menu items for a restaurant |
| POST | `/menu` | ✓ (manager) | Add a new menu item |
| PATCH | `/menu/:id` | ✓ (manager) | Edit item price, availability, or details |
| DELETE | `/menu/:id` | ✓ (manager) | Remove a menu item |

### Restaurants

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | `/restaurants` | ✓ | List open restaurants by `university_id` |
| PATCH | `/restaurants/:id` | ✓ (manager) | Toggle open/closed status |

### Orders

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/orders` | ✓ (student) | Place an order — validates tab limit if paying by tab |
| GET | `/orders` | ✓ (staff) | List orders by `restaurant_id` and `status` |
| PATCH | `/orders/:id/status` | ✓ (staff) | Advance order status |

### Tabs

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | `/tabs` | ✓ (manager) | List students with pending balances |
| PATCH | `/tabs/:cms_id` | ✓ (manager) | Adjust or clear a student's tab |

### Analytics

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | `/analytics/revenue` | ✓ (manager) | Monthly revenue + order count |
| GET | `/analytics/top-items` | ✓ (manager) | Top 5 selling menu items |

---

## Authentication Flow

### Student — Lazy Auth

```
Student enters CMS ID
        │
        ▼
  POST /auth/student
        │
   cms_id exists?
  ┌─────┴─────┐
 YES          NO
  │            │
  │      INSERT new student
  │      pending_balance = 0.00
  └─────┬─────┘
        │
  Sign JWT { cms_id, role: 'student' }
        │
        ▼
  Return token to Flutter app
        │
  Store in flutter_secure_storage
```

### Staff / Manager

Email + password login. Password verified against `bcrypt` hash in the `users` table. JWT payload includes `{ user_id, role, restaurant_id }`.

---

## Getting Started

### Prerequisites

- Node.js ≥ 18
- PostgreSQL ≥ 14
- Flutter ≥ 3.x

### Backend Setup

```bash
git clone https://github.com/Abdullahkhan2809/BiteBox.git
cd BiteBox/backend

npm install

cp .env.example .env
# Fill in DATABASE_URL, JWT_SECRET, PORT

psql -U postgres -d bitebox -f src/config/schema.sql

npm run dev
```

### Flutter Setup

```bash
cd BiteBox/flutter_app

flutter pub get

# Set your backend URL in lib/config/constants.dart
# const String baseUrl = 'http://localhost:3000';

flutter run
```

### Environment Variables

```env
DATABASE_URL=postgresql://user:password@localhost:5432/bitebox
JWT_SECRET=your_super_secret_key
PORT=3000
```

---

## Project Structure

### Backend

```
backend/
├── src/
│   ├── app.js                              ← Express app, route mounting
│   │
│   ├── config/
│   │   └── db.js                           ← pg Pool setup
│   │
│   ├── controller/
│   │   ├── auth_adminController.js         ← Lazy student auth + staff login
│   │   ├── menuControllers.js              ← Get, add, edit, delete menu items
│   │   ├── ordercontroller.js              ← Place order, update status, tab deduction
│   │   ├── restaurantController.js         ← 📋 List restaurants, toggle open/closed
│   │   ├── tabController.js                ← 📋 View & adjust student tabs
│   │   └── analyticsController.js          ← 📋 Monthly revenue, top items
│   │
│   ├── middleware/
│   │   ├── auth_middleware.js              ← JWT verification
│   │   └── relocheck.js                    ← Role-based access guard
│   │
│   ├── models/
│   │   └── studentmodel.js                 ← Student DB queries (find / lazy create)
│   │
│   ├── routes/
│   │   ├── auth_adminRoute.js              ← /auth/student, /auth/staff/login
│   │   ├── menuRoutes.js                   ← /menu/:restaurant_id
│   │   ├── orderRoutes.js                  ← /orders
│   │   ├── restaurantRoutes.js             ← 📋 /restaurants
│   │   ├── tabRoutes.js                    ← 📋 /tabs
│   │   └── analyticsRoutes.js              ← 📋 /analytics
│   │
│   └── utils/
│       └── otp.js                          ← OTP generation for password reset
│
├── .env.example
└── package.json
```

> `📋` marks files planned but not yet created — part of Phases 3–5.

### Flutter App

```
flutter_app/
└── lib/
    ├── config/
    │   └── constants.dart                  ← Base URL, app-wide config
    ├── models/
    │   ├── student.dart
    │   ├── restaurant.dart
    │   ├── menu_item.dart
    │   └── order.dart
    ├── services/
    │   └── api_service.dart                ← All HTTP calls + JWT injection
    ├── screens/
    │   ├── auth/
    │   │   ├── login_screen.dart           ← ✅ Done
    │   │   ├── signup_screen.dart          ← ✅ Done
    │   │   ├── forgot_password_screen.dart ← ✅ Done
    │   │   └── otp_screen.dart             ← ✅ Done
    │   ├── student/
    │   │   ├── home_screen.dart
    │   │   ├── menu_screen.dart
    │   │   ├── cart_screen.dart
    │   │   └── order_confirmation_screen.dart
    │   └── admin/
    │       └── dashboard_screen.dart       ← ✅ Done
    │       └── menu.dart                   ← ✅ Done
    │       └── add_menu.dart               ← ✅ Done
    │       └── admin_live_orders.dart      ← ✅ Done
    │       └── admin_profile.dart          ← ✅ Done
    ├── widgets/
    └── main.dart
```

---

## Roadmap

- [x] Database schema design
- [x] Auth screens (login, signup, forgot password, OTP)
- [x] Admin dashboard UI
- [ ] Lazy Auth backend — student auto-register + JWT
- [ ] Staff login with role-based JWT
- [ ] Menu APIs — get, add, edit, delete items
- [ ] Order controller — place order with tab/cash + pg transaction
- [ ] Restaurant listing & toggle API
- [ ] Tab management API
- [ ] Cart screen + order placement (Flutter)
- [ ] Staff live order queue (Flutter)
- [ ] Monthly analytics API + chart UI
- [ ] Push notifications for order status
- [ ] QR code scan for CMS ID entry

---

## License

MIT License. See [LICENSE](./LICENSE) for details.
