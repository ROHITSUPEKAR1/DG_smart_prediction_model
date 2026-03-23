# Pitfalls Research

**Domain:** School Management Apps (Teacher/Parent)
**Researched:** 2026-03-23
**Confidence:** HIGH

---

## Critical Mistakes to Avoid

### 1. Hardcoding Student/School IDs in Flutter UI
- **Mistake**: Using local state only for the `selected_child` or `active_school` without syncing it to the backend via JWT.
- **Problem**: Parent app with two children (in different schools or classes) could accidentally mark attendance/view fees for the wrong child if the global state isn't robustly reactive.
- **Prevention Strategy**: Always derive the currently active child/school from the API response/JWT payload; never keep it in persistent storage alone.
- **Phase Addressing**: Phase 1 (Foundation) & Phase 3 (Parent Core).

### 2. Missing Database Connection Pooling (Node.js)
- **Mistake**: Opening a new MySQL connection for every API request.
- **Problem**: When 100+ teachers mark attendance at the start of school (9:00 AM), the DB will hit `Too many connections` and crash.
- **Prevention Strategy**: Use a connection pool (e.g., `mysql2/promise` with pool configuration) and ensure all connections are released.
- **Phase Addressing**: Phase 1 (Foundation - DB.js).

### 3. Blocking the Node.js Event Loop with PDF/Excel Generation
- **Mistake**: Generating heavy Report Cards (PDF) or Attendance Sheets (Excel) on the main thread.
- **Problem**: While one parent downloads a report card, ALL other API requests (like "Mark Present") will wait/hang.
- **Prevention Strategy**: For v1, use a lightweight PDF library; for v2+, offload document generation to a worker thread or a separate microservice.
- **Phase Addressing**: Phase 5 (Financials & Analytics).

### 4. FCM Token "Ghosting"
- **Mistake**: Not updating the `fcm_token` when a user logs in on a new device or the token expires.
- **Problem**: Parents stop receiving "Child is absent" alerts, reducing the app's core utility.
- **Prevention Strategy**: Send the current FCM token to the backend on every successful login and app foreground event if it has changed.
- **Phase Addressing**: Phase 4 (Notifications).

### 5. Inconsistent Subject/Class Naming Across Tenants
- **Mistake**: Assuming all schools use "Section A", "Section B", or "Maths", "Science".
- **Problem**: Hardcoding subject categories or names in the Flutter UI will break the app for different schools.
- **Prevention Strategy**: Use IDs for everything; display names should always be dynamic from the API (School-scoped).
- **Phase Addressing**: Phase 2 (Teacher Core - Classes).

---

## Performance Warning Signs

- **Latency**: If fetching 40 students for attendance takes > 2 seconds, check indexing on `student_id` and `division_id`.
- **Jank**: Flutter UI stuttering during horizontal scrolls (Timetable/Attendance) suggests too many widgets in the tree; use `ListView.builder` or `CustomScrollView`.

---

## Sources
- Node.js "Best Practices" GitHub Repository
- Flutter Performance Optimization Guide (Official)
- Medium: "Scaling Multi-tenant SaaS Apps in MySQL"
- User Project Prompt (Sarvaj Edtech)
