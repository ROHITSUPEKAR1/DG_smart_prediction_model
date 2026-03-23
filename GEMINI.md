<!-- GSD:project-start source:PROJECT.md -->
## Project

**DG Smart – Teacher & Parent Panel**

DG Smart is a cloud-based SaaS multi-tenant school management system. This project involves building two fully functional mobile applications—one for Teachers and one for Parents—serving the DG Smart ecosystem with a shared Node.js backend and MySQL database.

**Core Value:** Providing a seamless, real-time communication and management bridge between teachers, parents, and school administration to improve educational outcomes and operational efficiency.

### Constraints

- **Technology**: Flutter (Dart), Node.js (Express), MySQL, JWT, FCM.
- **Security**: Role-based middleware and school-scoped queries are mandatory.
- **Performance**: Mobile apps must handle real-time notifications and offline caching for basic stats.
- **Aesthetics**: UI must be "premium and state-of-the-art" as per user requirements.
<!-- GSD:project-end -->

<!-- GSD:stack-start source:research/STACK.md -->
## Technology Stack

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
- Implementation: Shared database with `school_id` tagging.
- Middleware: All Express routes must inject `school_id` from JWT.
- Caching strategy: Use `shimmer` for loading and local cache (shared_preferences) for dashboard stats.
## Sources
- Flutter Official Docs - State Management best practices verified (HIGH)
- Node.js Security Best Practices - JWT strategy verified (HIGH)
- Google Search - "Standard 2025 tech stack for School Apps" (MEDIUM)
<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->
## Conventions

Conventions not yet established. Will populate as patterns emerge during development.
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->
## Architecture

Architecture not yet mapped. Follow existing patterns found in the codebase.
<!-- GSD:architecture-end -->

<!-- GSD:workflow-start source:GSD defaults -->
## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:
- `/gsd-quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd-debug` for investigation and bug fixing
- `/gsd-execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->



<!-- GSD:profile-start -->
## Developer Profile

> Profile not yet configured. Run `/gsd-profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->
