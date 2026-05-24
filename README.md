<p align="center">
  <img src="bitebox/assets/images/logo.jpg" alt="BiteBox Logo" width="130"/>
</p>

<h1 align="center">BiteBox</h1>
<p align="center">A university campus food ordering system with lazy student auth and a built-in credit tab.</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter"/>
  <img src="https://img.shields.io/badge/Node.js-18+-green?logo=node.js"/>
  <img src="https://img.shields.io/badge/Express-5.x-lightgrey?logo=express"/>
  <img src="https://img.shields.io/badge/PostgreSQL-14+-blue?logo=postgresql"/>
  <img src="https://img.shields.io/badge/Cloudinary-Image%20Upload-blueviolet?logo=cloudinary"/>
  <img src="https://img.shields.io/badge/Railway-Deployed-purple?logo=railway"/>
  <img src="https://img.shields.io/badge/License-MIT-yellow"/>
</p>

---

## Project Overview

BiteBox solves a common university problem: long queues and slow cash-based payments at campus cafes. Students enter their university CMS ID and order in seconds — no sign-up, no password.

The system introduces a **Lazy Auth** model where first-time students are automatically registered on login. Every student gets a **Tab** — a credit balance they can use to defer payment up to a configurable limit. Cafe staff get a live order queue dashboard, and managers get monthly sales analytics.

This repository contains both the Flutter mobile application and the Node.js backend API, deployed on Railway with PostgreSQL and Cloudinary for image storage.

### Mockups
<p align="center">
  <img src="multiple-phone-3-screens-mockup.png" width="300"/>
  &nbsp;&nbsp;
  <img src="two-screens-phone-mockup.png" width="300"/>
</p>

---

## Tech Stack 🛠️

### Frontend
| Technology | Purpose |
|---|---|
| **Flutter** | Cross-platform mobile framework |
| **Dart** | Programming language for Flutter |
| **Provider** | State management (ChangeNotifier pattern) |
| **Hive** | Offline-first local caching for menus and restaurants |
| **flutter_secure_storage** | Encrypted JWT token storage |
| **http** | HTTP client for API calls |
| **image_picker** | Camera/gallery image selection for menu items |

### Backend
| Technology | Purpose |
|---|---|
| **Node.js** | Server runtime |
| **Express 5** | Web framework for REST API |
| **PostgreSQL** | Relational database |
| **pg** | Node-postgres driver with connection pooling |
| **jsonwebtoken** | JWT-based authentication |
| **bcryptjs** | Password hashing for staff accounts |
| **Cloudinary** | Cloud-based image upload and optimization |
| **multer** | Multipart form data handling for file uploads |
| **nodemon** | Development auto-reload |

### Deployment
| Service | Purpose |
|---|---|
| **Railway** | Backend hosting + managed PostgreSQL |
| **Cloudinary** | Image CDN and storage |

---

## Features

### Student
- **Lazy Auth** — enter CMS ID, done. Auto-registered on first visit, no password ever
- **Multi-restaurant browsing** — all open cafes at the university in one place
- **Menu browsing** — filter by category (Deals, Beverages, Snacks, etc.)
- **Cart** — add, remove, adjust quantities; locked to one restaurant per session
- **Dual payment** — pay with cash or deduct from Tab balance
- **Tab tracking** — see pending balance and remaining credit limit
- **Offline-first** — menus and restaurants cached locally via Hive
- **Step indicator checkout** — 3-step flow: Cart → Details → Checkout → Confirmation

### Staff / Cafe Manager
- **Live order queue** — view orders filtered by status (pending, preparing, ready)
- **Order progression** — tap to advance: pending → preparing → ready → completed
- **Menu management** — add, edit, delete items with image upload via Cloudinary
- **Tab management** — view and adjust student outstanding balances
- **Analytics** — monthly revenue, order volume, and top-selling items
- **Profile management** — edit name, view order stats

### Super Admin
- Onboard new universities and cafes
- Create and manage staff/manager accounts across universities

---

## Code Structure

The application follows the **MVVM (Model-View-ViewModel)** design pattern using Provider for state management.

**Model:** Data classes with `fromJson`/`toJson` serialization, Hive type adapters for offline caching (MenuItem, Restaurant). Includes services that interact with the REST API and local storage.

**View:** Flutter widgets organized by role — `auth/`, `user/` (student screens), `admin/` (staff screens), and shared `widgets/`. Each screen is responsible only for displaying data and capturing user input.

**ViewModel (Provider):** Each provider extends `ChangeNotifier` to manage state and expose data/methods for the UI. Providers include `AuthProvider`, `CartProvider`, `OrderProvider`, and `RestaurantProvider`.

**Key Patterns:**
- **State Management:** Provider package with `ChangeNotifier`, used with `Consumer`, `context.watch`, and `context.read`
- **Offline-first:** Hive cache shown instantly, network refresh in background
- **One-way data flow:** Form → Provider → Service → Storage → Hive
- **Cache-first services:** GET requests return cached data immediately, then refresh from network

---

## Architecture

### Backend Architecture

BiteBox follows a **Controller → Route → Middleware** pattern on the backend.

```
Flutter App
     │
     │  HTTP + Bearer JWT
     ▼
Express Router
     │
 auth_middleware.js   ← verify JWT, attach req.user
 relocheck.js         ← role-based access guard
 validate.js          ← required field validation
     │
     ▼
Controllers           ← business logic
     │
     ▼
pg Pool → PostgreSQL (Railway)
     │
Cloudinary            ← image upload/optimization
```

### Middleware

- **`auth_middleware.js`** — extracts and verifies the JWT Bearer token from the `Authorization` header. Attaches the decoded payload to `req.user`.
- **`relocheck.js`** — restricts routes to specific roles (`super_admin`, `cafe_manager`, `staff`). Applied after auth middleware.
- **`validate.js`** — generic required-field validator. Returns 400 with missing field names if any are absent from `req.body`.

### Flutter Architecture

```
lib/
  core/         ← constants, routes, theme, toast utility
  models/       ← Dart data classes (fromJson/toJson) + Hive adapters
  providers/    ← ChangeNotifier state management
  services/     ← all API calls, JWT injected per request, offline cache
  views/
    admin/      ← staff dashboard, menu management, live orders, profile
    auth/       ← login, signup, forgot password, OTP, reset password
    user/       ← student home, menu, cart, checkout, confirmation
    widgets/    ← 17+ reusable UI components
```

JWT is persisted in `flutter_secure_storage` and attached to every API request as a Bearer token. Token expiry is checked on app startup via decoded JWT `exp` claim.

---

## Database Schema

```sql
CREATE TABLE university (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(50) NOT NULL,
    location    VARCHAR(255),
    domain_name VARCHAR(100) UNIQUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE restaurants_category (
    id            SERIAL PRIMARY KEY,
    university_id INT REFERENCES university(id) ON DELETE CASCADE,
    name          VARCHAR(100) NOT NULL,
    category      VARCHAR(50),
    image_url     TEXT,
    is_open       BOOLEAN DEFAULT TRUE
);

CREATE TABLE user_admin (
    id               SERIAL PRIMARY KEY,
    university_id    INT REFERENCES university(id) ON DELETE CASCADE,
    restaurant_id    INT REFERENCES restaurants_category(id) ON DELETE SET NULL,
    name             VARCHAR(100) NOT NULL,
    email            VARCHAR(100) UNIQUE NOT NULL,
    password_hash    TEXT NOT NULL,
    role             VARCHAR(20) CHECK (role IN ('super_admin', 'cafe_manager', 'staff')),
    reset_otp        VARCHAR(6),
    reset_otp_expiry TIMESTAMP,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE students (
    cms_id          VARCHAR(50) PRIMARY KEY,
    university_id   INT REFERENCES university(id) ON DELETE CASCADE,
    name            VARCHAR(100) NOT NULL,
    pending_balance DECIMAL(10, 2) DEFAULT 0.00,
    max_limit       DECIMAL(10, 2) DEFAULT 5000.00,
    is_active       BOOLEAN DEFAULT TRUE,
    contact_number  VARCHAR(13) DEFAULT '+92',
    last_order_at   TIMESTAMP,
    CONSTRAINT check_positive_balance CHECK (pending_balance >= 0)
);

CREATE TABLE menu_items (
    id            SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES restaurants_category(id) ON DELETE CASCADE,
    name          VARCHAR(100) NOT NULL,
    description   TEXT,
    price         DECIMAL(10, 2) NOT NULL,
    image_url     TEXT,
    is_available  BOOLEAN DEFAULT TRUE,
    category      VARCHAR(50)
);

CREATE TABLE orders (
    id             SERIAL PRIMARY KEY,
    student_id     VARCHAR(50) REFERENCES students(cms_id),
    restaurant_id  INT REFERENCES restaurants_category(id),
    total_amount   DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(10) CHECK (payment_method IN ('cash', 'tab')),
    status         VARCHAR(20) DEFAULT 'pending',
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    id                SERIAL PRIMARY KEY,
    order_id          INT REFERENCES orders(id) ON DELETE CASCADE,
    menu_item_id      INT REFERENCES menu_items(id),
    quantity          INT NOT NULL,
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
| POST | `/auth/forgot-password` | ✗ | Send OTP to staff email for password reset |
| POST | `/auth/verify-otp` | ✗ | Verify OTP, returns short-lived reset token |
| POST | `/auth/reset-password` | ✗ | Reset password using reset token |

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

### Image Upload

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/upload` | ✓ (manager) | Upload menu item image to Cloudinary |

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
        │
  Check token expiry on app restart
```

### Staff / Manager

Email + password login. Password verified against `bcrypt` hash in the `user_admin` table. JWT payload includes `{ user_id, role, restaurant_id }`.

### Password Reset Flow

```
Staff enters email → POST /auth/forgot-password
        │
  Generate 6-digit OTP, store with 10min expiry
        │
  Staff enters OTP → POST /auth/verify-otp
        │
  Returns short-lived reset_token (15min)
        │
  Staff enters new password → POST /auth/reset-password
        │
  bcrypt hash + update DB, clear OTP
```

---

## Getting Started

### Prerequisites

- Node.js ≥ 18
- PostgreSQL ≥ 14
- Flutter ≥ 3.x
- Cloudinary account (free tier)

### Backend Setup

```bash
git clone https://github.com/Abdullahkhan2809/BiteBox.git
cd BiteBox/bitebox_server

npm install

# Create environment file
cp .env.example .env
# Fill in: DATABASE_URL, JWT_SECRET, PORT, CLOUDINARY_CLOUD_NAME, CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET

# Run database schema
psql -U postgres -d bitebox -f schema.sql

# Seed test data
npm run seed

# Create first admin account
npm run create-admin

# Start development server
npm run dev
```

### Flutter Setup

```bash
cd BiteBox/bitebox

flutter pub get

# Set your backend URL in lib/core/constant.dart
# For emulator:  static const String baseUrl = 'http://10.0.2.2:3000';
# For Railway:   static const String baseUrl = 'https://your-app.up.railway.app';

flutter run
```

### Environment Variables

```env
DATABASE_URL=postgresql://user:password@localhost:5432/bitebox
JWT_SECRET=your_super_secret_key
PORT=3000
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
```

---

## Project Structure

### Backend

```
bitebox_server/
├── src/
│   ├── app.js                          ← Express app, CORS, route mounting
│   │
│   ├── config/
│   │   ├── db.js                       ← pg Pool setup + connection test
│   │   └── cloudinary.js               ← Cloudinary configuration
│   │
│   ├── controller/
│   │   ├── auth_adminController.js     ← Lazy student auth, staff login, OTP flow
│   │   ├── menuControllers.js          ← Get, add, edit, delete menu items
│   │   ├── ordercontroller.js          ← Place order, get orders, update status
│   │   └── uploadController.js         ← Image upload to Cloudinary
│   │
│   ├── middleware/
│   │   ├── auth_middleware.js          ← JWT verification
│   │   ├── relocheck.js               ← Role-based access guard
│   │   ├── validate.js                ← Required field validation
│   │   └── upload.js                  ← Multer image upload handling
│   │
│   ├── models/
│   │   └── studentmodel.js            ← Student find / lazy create queries
│   │
│   ├── routes/
│   │   ├── auth_adminRoute.js         ← /auth/*
│   │   ├── menuRoutes.js              ← /menu/*
│   │   ├── orderRoutes.js             ← /orders/*
│   │   ├── restaurantRoutes.js        ← /restaurants/*
│   │   └── uploadRoutes.js            ← /upload
│   │
│   ├── scripts/
│   │   ├── seed.js                    ← Populate test data
│   │   └── create_admin.js            ← Create first admin account
│   │
│   └── utils/
│       └── otp.js                     ← 6-digit OTP generation
│
├── .env
└── package.json
```

### Flutter App

```
bitebox/
└── lib/
    ├── core/
    │   ├── constant.dart               ← Base URL, app-wide config
    │   ├── routes.dart                 ← Named route definitions + argument passing
    │   ├── theme.dart                  ← App theme and styling
    │   └── toast.dart                  ← Reusable toast notifications
    │
    ├── models/
    │   ├── menu_item_model.dart        ← MenuItem + Hive adapter (@HiveType)
    │   ├── menu_item_model.g.dart      ← Generated Hive adapter
    │   ├── retaurant_model.dart        ← Restaurant + Hive adapter (@HiveType)
    │   ├── retaurant_model.g.dart      ← Generated Hive adapter
    │   ├── order_model.dart            ← Order + OrderItem
    │   └── student_model.dart          ← StudentModel
    │
    ├── providers/
    │   ├── auth_provider.dart          ← Login/logout, session restore, token expiry check
    │   ├── cart_provider.dart          ← Cart entries, quantities, restaurant lock
    │   ├── order_provider.dart         ← Place order, fetch orders, advance status
    │   └── restaurant_provider.dart    ← Load/refresh restaurants, offline flag
    │
    ├── services/
    │   ├── auth_services.dart          ← Student/staff login, OTP, reset password
    │   ├── menu_service.dart           ← Menu CRUD + cache-first pattern
    │   ├── order_service.dart          ← Place/get/update orders
    │   ├── restaurant_service.dart     ← Restaurant list + cache-first pattern
    │   ├── storage_service.dart        ← Hive + secure storage + JWT expiry check
    │   └── image_service.dart          ← Image picker + Cloudinary upload
    │
    ├── views/
    │   ├── admin/
    │   │   ├── dashboardscreen.dart    ← Order stats + recent orders
    │   │   ├── admin_live_order.dart   ← Live order queue with status tabs
    │   │   ├── menu.dart               ← Menu item list + delete
    │   │   ├── add_menu_items.dart     ← Add/edit menu item with image upload
    │   │   ├── admin_nav.dart          ← Bottom navigation shell
    │   │   └── profile/
    │   │       ├── admin_profile.dart  ← Profile view + logout
    │   │       └── editprofile.dart    ← Edit name/details
    │   │
    │   ├── auth/view/
    │   │   ├── login_admin.dart        ← Staff login screen
    │   │   ├── signup_admin.dart       ← Staff registration
    │   │   ├── forgetpassword_admin.dart ← Forgot password → sends OTP
    │   │   ├── otp_verfication_admin.dart ← OTP entry → returns reset token
    │   │   └── resetpassword_admin.dart   ← New password entry
    │   │
    │   ├── user/
    │   │   ├── home_screen.dart        ← Restaurant list + menu search + category filter
    │   │   ├── restaurent_menu_screen.dart ← Menu items for selected restaurant
    │   │   ├── cart_screen.dart        ← Cart with quantities + step indicator
    │   │   ├── adduserdetails.dart     ← Student name/phone/payment entry
    │   │   ├── checkout.dart           ← Order summary + place order
    │   │   ├── popup.dart              ← Order confirmation popup
    │   │   ├── aboutus.dart            ← About page
    │   │   └── feedback.dart           ← Feedback page
    │   │
    │   └── widgets/
    │       ├── appbar.dart
    │       ├── bottomnavigationbar.dart
    │       ├── cartitem.dart           ← Cart item with quantity controls
    │       ├── colors.dart
    │       ├── dashboard_Shell.dart
    │       ├── feedback_footer.dart
    │       ├── floatingicons.dart
    │       ├── indicator.dart          ← 3-step checkout indicator
    │       ├── live_order_card.dart    ← Staff order card with accept button
    │       ├── menuitem_card.dart      ← Admin menu item card
    │       ├── menuitemCardUser.dart   ← Student menu item card with add-to-cart
    │       ├── order_card.dart
    │       ├── payment_badge.dart
    │       ├── restaurantcard.dart     ← Restaurant card with image + status
    │       ├── stat_card.dart          ← Dashboard statistic card
    │       ├── status_badge.dart
    │       └── status_button_live_orders.dart
    │
    └── main.dart                       ← App entry, Hive init, MultiProvider setup
```

---

## Deployment

### Backend — Railway

The backend is deployed on [Railway](https://railway.com) with a managed PostgreSQL instance.

1. Push `bitebox_server/` to GitHub
2. Create a Railway project → Deploy from GitHub
3. Add PostgreSQL service → auto-injects `DATABASE_URL`
4. Set environment variables: `JWT_SECRET`, `CLOUDINARY_*`
5. Railway provides a public URL for the API

### Image Storage — Cloudinary

Menu item images are uploaded through the backend to Cloudinary's free tier, which provides automatic optimization, resizing (800×800 max), and CDN delivery.

### Flutter — Build APK

```bash
cd bitebox
flutter build apk --release
```

APK output: `build/app/outputs/flutter-apk/app-release.apk`

---

## Roadmap

- [x] Database schema design
- [x] Auth screens (login, signup, forgot password, OTP, reset password)
- [x] Admin dashboard UI
- [x] Lazy Auth backend — student auto-register + JWT
- [x] Staff login with role-based JWT
- [x] Menu APIs — get, add, edit, delete items
- [x] Order controller — place order with tab/cash validation
- [x] Restaurant listing & toggle API
- [x] Cart screen + order placement (Flutter)
- [x] Staff live order queue (Flutter)
- [x] Image upload via Cloudinary
- [x] Backend deployment on Railway
- [x] JWT expiry handling + session restore
- [x] Offline-first caching with Hive


---

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a new branch for your feature or bug fix
3. Write tests if applicable
4. Submit a pull request with a description of your changes

Please ensure your code adheres to the project's coding standards.

---

## License

MIT License. See [LICENSE](./LICENSE) for details.
