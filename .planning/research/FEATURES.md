# Features Research

**Domain:** School Management System Mobile Apps (Teacher/Parent)
**Researched:** 2026-03-23
**Confidence:** HIGH

---

## Standard Feature Landscape

### Table Stakes (Must Have or Users Leave)

| Feature | Category | Rationale | Complexity |
|---------|----------|-----------|------------|
| Multi-tenant Auth | Authentication | Students/Teachers/Parents must all use a single login with role-based dashboard. | MEDIUM |
| Attendance Tracking | Core Functionality | Real-time "Mark Absent" is the #1 feature for teachers and parent peace-of-mind. | LOW |
| Dashboard Stats | Home Screen | Quick view of Homework, Exams, and Fees directly on launch. | LOW |
| Push Notifications | Communication | The primary reason schools use mobile apps over web portals. | MEDIUM |
| Homework/Study Material | Learning | Digital distribution of coursework is standard in 2025. | MEDIUM |

### Differentiators (Competitive Advantage)

| Feature | Category | Rationale | Complexity |
|---------|----------|-----------|------------|
| In-app Fee Payments | Finance | Integrated Razorpay/PayU reduces school collection overhead significantly. | HIGH |
| AI Analytics | Performance | Predicting student at-risk status based on attendance/marks data. | HIGH |
| Meeting Booking | Communication | Scheduling PTMs directly in-app prevents phone-tag. | MEDIUM |
| Behavioural Reports | Student Life | Tracking qualitative discipline/teamwork metrics alongside quantitative grades. | MEDIUM |
| Lesson Planning | Administration | Helping teachers organize their day directly from the app. | MEDIUM |

### Anti-Features (Things to Deliberately NOT Build in Phase 1)

| Feature | Category | Why Avoid |
|---------|----------|-----------|
| Full School ERP | Admin | Mobile apps are for *interaction*, not school-wide database management. |
| In-app Video Chat | Learning | High complexity/infrastructure cost; use Zoom/Google Meet links for v1. |
| Student-to-Student Chat| Social | Moderation and privacy risks in a school environment often outweigh benefits. |

---

## Expected Feature Flow

**Teacher Workflow:**
1. Login → Dashboard (Today's Classes)
2. Tap "Mark Attendance" → Select Class → Tap Present/Absent → Submit
3. Alert: Push/SMS auto-sent to Parents of absent students.

**Parent Workflow:**
1. Receive "Absence alert" notification.
2. Login → Dashboard → Tap "Attendance View"
3. Check calendar history → Message Teacher (if needed)

---

## Dependencies & Risks

- **SMS/Push API**: Crucial for the core value; requires background service reliability.
- **File Storage**: Homework uploads require reliable cloud or local VPS storage handling.
- **Relational Data**: Deleting a class or student must handle cascading impacts on attendance and marks history.

---

## Sources
- Classter Cloud SMS Blog (2025 School Feature Trends)
- DreamClass Feature List Comparison
- User Project Prompt (Sarvaj Edtech)
