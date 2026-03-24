# Phase 11: Production Hardening & Optimization - Context

**Gathered:** 2026-03-24
**Status:** Ready for planning
**Source:** Autonomous GSD Execution (User directive: "take better decisions")

<domain>
## Phase Boundary

This phase strictly focuses on non-functional requirements and foundational UI enhancements. It aims to solve the app's vulnerability to complete failure upon network drop-offs and improves database read-latency on large multi-tenant query matrices.
</domain>

<decisions>
## Implementation Decisions

### 1. Offline Caching Engine (OPT-01)
- **Tool**: `hive` and `hive_flutter` for local NoSQL caching due to high performance with simple Dart Objects.
- **Pattern**: The app should fetch from the API and save the response into a Hive Box. If the network call throws a SocketException, the Repository layer should gracefully fall back to returning the locally cached Hive Box data.
- **Scope**: Apply caching locally ONLY for reads to primary views (Teacher Dashboard, Parent Dashboard, and Timetables).

### 2. Database Query Tuning (OPT-02)
- **Tool**: Native MySQL indexes defined through Knex migrations.
- **Pattern**: Add composite indexes. Most queries are strictly isolated by `school_id`, meaning queries run `WHERE school_id = X AND target_id = Y`. Creating a composite index `(school_id, user_id)` or `(school_id, date)` will vastly improve latency.
- **Scope**: Target `attendance`, `results`, and `homework` tables.

### 3. Comprehensive UX/UI Polish (UI-01 & UI-02)
- **Tool**: `shimmer` package for Flutter.
- **Pattern**: Abstract the `CircularProgressIndicator` into a highly re-usable `SkeletonCard` displaying animated gradients to simulate layout shapes while data fetches.
- **Typography Check**: Wrap all textual constraints in Flexible/Expanded boxes to prevent overflow when `textScaleFactor` scales up.

### the agent's Discretion
- The implementation speed should take priority over excessive abstractions.

</decisions>

<canonical_refs>
## Canonical References
- `.planning/PROJECT.md` — Core constraints and Multi-tenant requirements.
</canonical_refs>

<specifics>
## Specific Ideas
- The `Shimmer` color parameters should rely on the existing `theme.colorScheme.surfaceVariant` to match light/dark modes organically.
</specifics>

<deferred>
## Deferred Ideas
- Pre-fetching large data assets (images/lessons). Keep it strictly to text/JSON payloads for this phase cache.
</deferred>
