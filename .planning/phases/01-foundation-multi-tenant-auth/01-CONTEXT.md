# Phase 1: Foundation & Multi-Tenant Auth - Context

**Gathered:** 2026-03-23
**Status:** Ready for planning

<domain>
## Phase Boundary
This phase delivers the core infrastructure for the DG Smart Teacher and Parent applications. It establishes the secure multi-tenant backend (Node.js/Express + MySQL) and the foundational Flutter mobile framework with a role-based login system.

</domain>

<decisions>
## Implementation Decisions

### Authentication & Authorization
- **D-01: Two-Step Login with OTP**: Verification of the OTP will return a temporary session token, which the user then uses to complete the login with their password. This provides a multi-factor security layer out of the box.
- **D-02: JWT with Refresh Strategy**: Access tokens (1h) and Refresh tokens (30d) for stateless sessions. Refresh tokens are stored in the `user_sessions` table in the DB and invalidated on logout or school-wide security rotation.
- **D-03: Role-Based Access Control (RBAC)**: Middleware strictly enforces role checks (`requireRole('teacher')`, `requireRole('parent')`) at the Express route level.

### Database Architecture
- **D-04: Multi-Tenant Scoping with Knex.js**: Using Knex.js as the query builder with an automated scoping pattern. All queries (except global tables like `schools` and some `auth` tables) will automatically inject `WHERE school_id = ?` into the SQL using a `withSchoolScope` higher-order function.
- **D-05: Connection Pooling**: Configured in `db.js` with a 10-connection pool to handle peak traffic from multiple schools simultaneously.

### Flutter Mobile Framework
- **D-06: Riverpod 2.0 State Management**: Utilizing `AsyncNotifier` and `StateNotifierProvider` for robust, reactive state handling (especially for Auth and School switching).
- **D-07: Dynamic Role-Based Theming**: The login screen theme will switch colors (#667eea for Teacher, #f093fb for Parent) instantaneously when the user clicks the role tab, providing immediate visual feedback.
- **D-08: Secure Token Storage**: Using `flutter_secure_storage` for JWT tokens and `shared_preferences` for non-sensitive local caching of dashboard JSON data.

### the agent's Discretion
- **D-09: Directory Structure**: the agent has discretion over the detailed internal organization of `lib/features` and `src/services` as long as it follows the agreed-upon high-level structure.
- **D-10: Error Handling**: Centralized error responses for the API and visual snake-bar feedback for the mobile apps.

</decisions>

<canonical_refs>
## Canonical References
**Downstream agents MUST read these before planning or implementing.**

### Project Specifications
- `.planning/PROJECT.md` — Full project context and design system requirements.
- `.planning/REQUIREMENTS.md` — v1 requirements (AUTH-01 to AUTH-05).

### Implementation Research
- `.planning/research/SUMMARY.md` — Recommended tech stack and architectural patterns.
- `.planning/research/PITFALLS.md` — Critical errors to avoid (data leaks, event loop blocking).

</canonical_refs>

<deferred_ideas>
## Deferred Ideas
- **In-app Registration**: Deferred for v1 (schools/admins register users initially).
- **Social Login (Google/Apple)**: Deferred to v2+ (current focus is Mobile # + OTP + Password).
- **Cloud S3 Storage**: Using local VPS filesystem for initial homework uploads; service wrapper will be migration-ready.

</deferred_ideas>

---
*Created: 2026-03-23 after discuss-phase 1*
