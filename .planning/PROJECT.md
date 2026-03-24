# DG Smart – Teacher & Parent Panel

## What This Is

DG Smart is a cloud-based SaaS multi-tenant school management system. This project involves building two fully functional mobile applications—one for Teachers and one for Parents—serving the DG Smart ecosystem with a shared Node.js backend and MySQL database.

## Core Value

Providing a seamless, real-time communication and management bridge between teachers, parents, and school administration to improve educational outcomes and operational efficiency.

## Requirements

### Validated

- [x] **Multi-tenant architecture**: Shared database infrastructure with strict `school_id` isolation. (Validated in Phase 1)
- [x] **Secure Auth System**: Dual-persona (Teacher/Parent) JWT login with OTP support and Refresh token rotation. (Validated in Phase 1)
- [x] **Foundational Backend**: Node.js + Express with Knex scoping middleware. (Validated in Phase 1)
- [x] **Foundational Flutter App**: Riverpod-based mobile base with responsive, role-based theming. (Validated in Phase 1)
- [x] **Teacher Dashboard**: Chronological timeline showing "Today's Schedule" with progress indicator. (Validated in Phase 2)
- [x] **Attendance Marking**: Multi-tenant marking grid with real-time tally and bulk submission. (Validated in Phase 2)
- [x] **Parent Dashboard**: Multi-child context switcher and hero attendance status. (Validated in Phase 3)
- [x] **Attendance History**: Weekly scroller and historical tracking for parental tracking. (Validated in Phase 3)
- [x] **Teacher Schedule**: 5-day weekly grid for advanced lesson planning. (Validated in Phase 4)
- [x] **Homework/Resource Assignment**: Multi-class targeting and photo/file upload. (Validated in Phase 4)
- [x] **Parent Fee Management**: Installment ledger with status-colored tracking. (Validated in Phase 5)
- [x] **Mock Payment Gateway**: Secure transaction simulation with PDF receipt download. (Validated in Phase 5)
- [x] **Teacher Marks Entry**: Spreadsheet-style batch listing for high-speed grading. (Validated in Phase 6)
- [x] **Academic Analytics**: Radar & Trend charts for multi-exam tracking. (Validated in Phase 6)
- [x] **Real-time Messaging**: Broadcast notice board and automated FCM triggers. (Validated in Phase 7)
- [x] **Automated Grade Calculation**: Percentage to A+/F mapping engine. (Validated in Phase 6/7)
- [x] **Meeting & PTM Booking**: TableCalendar request flow with teacher triage. (Validated in Phase 8)
- [x] **1-Hour Proximity Reminders**: Automated backend cron for meeting alerts. (Validated in Phase 8)
- [x] **Exam Session Management**: Teacher Control Hub, draft/publish lifecycle, and PDF Class Exports. (Validated in Phase 9)
- [x] **Predictive AI Engine**: Nightly compute scaling raw datasets to active high-risk anomalies triggering dynamic Parent Banner hijack UI. (Validated in Phase 10)

## Current Milestone: v1.1 System Hardening & Optimization

**Goal:** Transform the MVP into a highly fault-tolerant, performant, and deeply optimized production-ready system capable of handling thousands of active concurrent users securely.

**Target features:**
- Offline Caching Engine
- Database Query Tuning
- Comprehensive UX/UI Polish

### Active

- [ ] Native offline-caching for Flutter networks
- [ ] Query performance tuning and database indexing
- [ ] Expand UI skeleton loaders and micro-animations



### Out of Scope

- [ ] Super Admin/Admin Panel (already exists or handled by separate desktop/web panel).
- [ ] Student-specific Mobile App (scope is limited to Teacher and Parent panels for this phase).
- [ ] Cross-tenant communication (data isolation between schools is strictly enforced).

## Context

- **Client**: Sarvaj Edtech Pvt Ltd.
- **Project Scope**: Mobile expansion of existing school management infrastructure.
- **Branding**: "DreamsGuider Style" — high-end pastel aesthetic with specific gradients (#667eea → #764ba2 for Teachers, #f093fb → #e91e63 for Parents).

## Constraints

- **Technology**: Flutter (Dart), Node.js (Express), MySQL, JWT, FCM.
- **Security**: Role-based middleware and school-scoped queries are mandatory.
- **Performance**: Mobile apps must handle real-time notifications and offline caching for basic stats.
- **Aesthetics**: UI must be "premium and state-of-the-art" as per user requirements.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Flutter for Mobile | Single codebase for iOS and Android with high UI performance | **Finalized**: Riverpod 2.0 + Theme-flipping state. |
| MySQL + Knex | Relational consistency needed for complex academic records with custom scoping | **Finalized**: Multi-tenant `withSchoolScope`. |
| JWT with Refresh | Balance between security and user experience on mobile | **Finalized**: 1h Access / 30d Refresh strategy. |
| Multi-tenant Schema | Efficient scaling for multiple schools using shared infra | **Finalized**: One table per entity, `school_id` required for all queries. |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-03-23 after project initialization*
