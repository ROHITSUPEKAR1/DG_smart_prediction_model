# Stack Research

**Domain:** School Management System (SaaS Multi-tenant)
**Researched:** 2026-03-23
**Confidence:** HIGH

## Recommended Stack

### Core Technologies

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Flutter | ^3.x (latest) | Mobile Frontend | Single codebase for iOS/Android, rich UI components for education SaaS. |
| Node.js | ^20.x (LTS) | Backend API | Fast, asynchronous performance for real-time notifications and multiple connections. |
| Express.js | ^4.18 | REST API Framework | Industry standard for building scalable Node.js APIs. |
| MySQL | ^8.0 | Relational Database | Strong data integrity for academic records, student billing, and multi-tenant scoping. |

### Supporting Libraries

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| flutter_riverpod | ^2.4.0 | State Management | Managing complex app state (Auth, Child selection, Attendance). |
| dio | ^5.3.0 | HTTP Client | API communication with interceptors for JWT refresh. |
| firebase_messaging| ^14.7.0 | Push Notifications | Real-time alerts for attendance and notices. |
| jsonwebtoken | ^9.0.0 | Authentication | Secure, stateless role-based auth. |
| multer | ^1.4.5 | File Uploads | Handling homework and study material uploads. |
| razorpay_flutter | ^1.3.0 | Fee Payments | Integrating payment gateway for Parent Portal. |

### Development Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| PM2 | Process Management | Ensures Node.js backend restarts on crash and stays alive on VPS. |
| MSG91 API | SMS Gateway | Critical for high-priority alerts (absence notifications). |
| Flutter DevTools | Performance Profiling | Crucial for identifying jank in heavy UI components (Attendance grid). |

## Alternatives Considered

| Recommended | Alternative | When to Use Alternative |
|-------------|-------------|-------------------------|
| MySQL | PostgreSQL | If advanced JSON querying or GIS features (bus tracking) were a primary requirement. |
| Riverpod | BLoC | If strict event-driven architecture was preferred over reactive state. |
| Node.js | NestJS | If a more opinionated, Angular-like structure was desired for a larger team. |

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| SharedPreferences for Auth | Not encrypted/secure for sensitive JWTs. | flutter_secure_storage |
| Plain MySQL Queries | Risk of SQL injection in a multi-tenant environment. | Sequelize or Knex.js (Query Builder) |
| Global Variables for State | Leads to race conditions and unpredictable UI updates. | Riverpod / Provider |

## Stack Patterns by Variant

**Multi-Tenancy:**
- Implementation: Shared database with `school_id` tagging.
- Middleware: All Express routes must inject `school_id` from JWT.

**Offline Support:**
- Caching strategy: Use `shimmer` for loading and local cache (shared_preferences) for dashboard stats.

## Sources
- Flutter Official Docs - State Management best practices verified (HIGH)
- Node.js Security Best Practices - JWT strategy verified (HIGH)
- Google Search - "Standard 2025 tech stack for School Apps" (MEDIUM)
