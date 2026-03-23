# Requirements: DG Smart – Teacher & Parent Panel

**Defined:** 2026-03-23
**Core Value:** Seamless real-time communication and management bridge between teachers, parents, and school administration.

## v1 Requirements

### Authentication & Infrastructure (AUTH)

- [ ] **AUTH-01**: User can login with role + credentials (Teacher/Parent).
- [ ] **AUTH-02**: Support for OTP-based login for mobile verification.
- [ ] **AUTH-03**: Secure JWT-based stateless authentication with Access + Refresh tokens.
- [ ] **AUTH-04**: Multi-tenant database scoping using `school_id` on all queries.
- [ ] **AUTH-05**: FCM token registration and management per user device.

### Teacher Portal: Core (T-CORE)

- [ ] **T-CORE-01**: Dashboard showing greeting, daily timeline, and key stats.
- [ ] **T-CORE-02**: "My Classes" view listing all assigned class-divisions.
- [ ] **T-CORE-03**: Interactive timetable view with "Now" period indicator.
- [ ] **T-CORE-04**: Student list search and detail view with parent contact quick-dial.

### Teacher Portal: Actionable (T-ACT)

- [ ] **T-ACT-01**: Mark attendance (P/A/L/LV) with real-time submission.
- [ ] **T-ACT-02**: Upload homework and study materials (file attachments supported).
- [ ] **T-ACT-03**: Enter exam marks with automated grade calculation (A+ through F).
- [ ] **T-ACT-04**: Lesson plan creation and history tracking (Draft/Published).

### Parent Portal: Core (P-CORE)

- [ ] **P-CORE-01**: Dashboard with child stats and multi-child selector tabs.
- [ ] **P-CORE-02**: Detailed child profile view (Academic summary + Bio).
- [ ] **P-CORE-03**: Read-only child timetable view.

### Parent Portal: Actionable (P-ACT)

- [ ] **P-ACT-01**: Attendance calendar with monthly status icons and "At-risk" alerts (<75%).
- [ ] **P-ACT-02**: Exam results view with subject progress bars and trend analytics.
- [ ] **P-ACT-03**: Fee management: View status, breakdown, and transaction history.
- [ ] **P-ACT-04**: Online fee payment integration (Razorpay/PayU).
- [ ] **P-ACT-05**: Book PTM meetings with teachers based on available time slots.

### Communication & Reports (COMM)

- [ ] **COMM-01**: Push notifications for key events (Absence, Homework, Results, Fees).
- [ ] **COMM-02**: School-wide notifications and notices list.
- [ ] **COMM-03**: Behavioural reports tracking qualitative discipline/teamwork metrics.
- [ ] **COMM-04**: PDF report card and fee receipt generation/download.

---

## v2 Requirements

### Advanced Features (ADV)

- **ADV-01**: AI-powered student at-risk prediction based on multi-variate data.
- **ADV-02**: IoT-based biometric attendance integration.
- **ADV-03**: In-app real-time chat between Parent and Class Teacher.
- **ADV-04**: Bus/Transport live tracking for Parents.

---

## Out of Scope

| Feature | Reason |
|---------|--------|
| Super Admin Web Panel | Existing infrastructure; outside mobile scope. |
| Student Self-Login | v1 focus is on Teacher and Parent accountability/communication. |
| Cross-school data sharing | Strict multi-tenant isolation requirement. |
| Payroll/HR Management | ERP-level feature; outside current mobile portal scope. |

---

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| AUTH-01 | Phase 1 | Pending |
| AUTH-02 | Phase 1 | Pending |
| AUTH-03 | Phase 1 | Pending |
| AUTH-04 | Phase 1 | Pending |
| AUTH-05 | Phase 1 | Pending |
| T-CORE-01| Phase 2 | Pending |
| T-CORE-02| Phase 2 | Pending |
| T-ACT-01 | Phase 2 | Pending |
| P-CORE-01| Phase 3 | Pending |
| P-ACT-01 | Phase 3 | Pending |
| T-ACT-02 | Phase 4 | Pending |
| P-ACT-02 | Phase 4 | Pending |
| T-ACT-03 | Phase 5 | Pending |
| P-ACT-03 | Phase 5 | Pending |
| P-ACT-04 | Phase 5 | Pending |
| COMM-01 | Phase 6 | Pending |
| COMM-04 | Phase 6 | Pending |
| T-CORE-03| Phase 6 | Pending |
| P-MEET-01| Phase 6 | Pending |

**Coverage:**
- v1 requirements: 23 total
- Mapped to phases: 23
- Unmapped: 0 ✓

---
*Requirements defined: 2026-03-23*
*Last updated: 2026-03-23 after initial definition*
