# Project Research Summary

**Domain:** School Management System Mobile Apps (Teacher/Parent)
**Researched:** 2026-03-23
**Confidence:** HIGH

---

## 🏗 Stack Summary

- **Frontend**: **Flutter** (Dart) - Single codebase for iOS/Android, rich UI via **Riverpod** + **Dio**.
- **Backend**: **Node.js** (**Express**) - REST API with **JWT** Auth and **RBAC** for Teachers/Parents.
- **Database**: **MySQL** - Shared-schema multi-tenant model scoped by `school_id`.
- **Infrastructure**: **VPS** + **PM2** for process management; **FCM** for notifications.

---

## 🎯 Target Features (Phase 1)

### Table Stakes
- **Auth**: Role-based (Teacher/Parent) with multi-tenant `school_id` isolation.
- **Teacher Dashboard**: Today's classes, stats (Students/HW Pending), and Quick Actions.
- **Attendance**: Real-time marking (Present/Absent/Late/Leave) with auto-alerts.
- **Parent Portal**: Child stats, attendance calendar, and progress monitoring.
- **LMS Lite**: Homework upload/download and study material distribution.

### Differentiators
- **Financials**: Integrated Fee payments via Razorpay for Parents.
- **Communications**: Meeting booking (PTM) system and behaviour reports.
- **Administration**: Teacher lesson planning and timetable management.

---

## 🏛 Architecture Patterns

- **Multi-Tenant Scoping**: Shared DB with mandatory `school_id` filtering on all backend queries.
- **Middleware-First**: Role-based access and school isolation enforced at the routing level.
- **Reactive UI**: Flutter Riverpod managing hierarchical state (Parent → Child → Section-specific data).

---

## ⚠️ Watch Out For (Pitfalls)

- **Performance**: Heavy attendance grids (40+ students) and PDF generation on the Node.js main thread.
- **Consistency**: High risk of data bleed between different schools if `school_id` scoping is missed on any write/delete route.
- **User Experience**: Token expiration/refresh handling in Flutter (JWT + Refresh token logic).

---

## 📅 Suggested Roadmap

1. **Phase 1: Foundation (Auth & Multi-tenancy)**
2. **Phase 2: Teacher Core (Attendance & Classes)**
3. **Phase 3: Parent Core (Child Stats & Dashboards)**
4. **Phase 4: Learning Management (Homework & Materials)**
5. **Phase 5: Financials & Analytics (Fees & Marks)**
6. **Phase 6: Advanced (Notifications, Meetings, Behaviour)**

---

## Sources
- Stack Research (`.planning/research/STACK.md`)
- Features Research (`.planning/research/FEATURES.md`)
- Architecture Research (`.planning/research/ARCHITECTURE.md`)
- Pitfalls Research (`.planning/research/PITFALLS.md`)
- User Project Prompt (Sarvaj Edtech)
