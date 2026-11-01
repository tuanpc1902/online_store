# Online Store Web App: implementation plan

## Product and architecture decision

Build one business platform with three independently developed apps:
- apps/api: Spring Boot REST API and the only component that writes business data.
- apps/storefront: React + TypeScript client storefront.
- apps/admin: Vue 3 + TypeScript back-office UI.
- MySQL is the source of truth. Both UIs consume one versioned REST/OpenAPI contract.
- Start as a modular monolith. Do not split checkout, payments or stock into Go services while those workflows are being learned.
- Go is a later learning track: implement one isolated worker/service (for example report export or webhook event processing) after the Spring API owns stable boundaries. It must not write the same order/inventory rows independently.

Suggested repository:
online-store/
  apps/api/
  apps/storefront/
  apps/admin/
  apps/inventory-worker-go/       (later milestone)
  database/migrations/
  database/seed/
  infra/docker-compose.yml
  docs/database-design.md
  docs/business-workflows.md
  docs/api-contract.md
  docs/adr/
  README.md

## Database design deliverables

- database/migrations/V1__create_ecommerce_schema.sql: Flyway-ready baseline with the domain schema. It does not create/select the database; configure ecommerce_platform in the application or create it once in MySQL.
- database/seed/demo-data.sql: fictional starter data, imported after V1. Intended for a fresh schema and one run only.
- Standalone copies remain in the Temp folder as ecommerce_platform.sql and ecommerce_platform_seed.sql for direct MySQL Shell import.
- The schema models accounts/staff permissions; customer profiles and saved addresses; brands/categories/products/variants; carts and wishlists; coupons; order and address snapshots; payments and provider transactions; stock by warehouse and reservation/movement history; suppliers, purchase orders and partial goods receipts; shipments; returns/refunds; reviews; status history and audit logs.

Design details to preserve while implementing:
1. A product is the merchandising record; a variant is the sellable SKU. Inventory always references a variant and warehouse.
2. Customer and staff login identity is in app_users; the customer profile and employee record are separate. Seed accounts are invitations without credentials.
3. An order stores customer/contact/address/product/price snapshots. Historical orders must not depend on current catalog or current address rows.
4. Order, payment and fulfillment statuses are independent. Every order-status transition is appended to history.
5. inventory.on_hand is physical stock; inventory.reserved is committed but not yet shipped stock. Available = on_hand - reserved. Reservation rows can be split across warehouses for one order line.
6. stock_movements has separate physical and reserved deltas. The stock policy is reserve at checkout, release on cancellation/expiry, decrement physical stock on shipment, and put returned stock back only after inspection.
7. A purchase order does not add inventory. A goods receipt does, and supports partial delivery.
8. Payment attempts and financial operations are distinct. Webhook event IDs are unique per provider so callbacks can be idempotent.
9. Amounts use DECIMAL and Java BigDecimal. The backend calculates totals and applies coupon caps. Browser totals are display-only.
10. Coupon redemption rows can represent more than one applied coupon per order; the business service still defines compatibility/stacking policy.
11. Use Flyway after first import. Never edit an already-applied migration; create the next version.
12. Seed data is fictional and supports joins/workflow demos. Replace sample URLs and add fuller ledger history before treating stock rows as a reconciled accounting ledger.

## Technology choices

### Use now
- Java 25 LTS, Spring Boot, Spring Security, Spring Data JPA, Bean Validation, Maven, MySQL Connector/J, Flyway and OpenAPI.
- React + TypeScript + Vite for the customer store.
- Vue 3 + TypeScript + Vite for the admin app. The framework split is intentional practice; both call the same API.
- Docker Compose for local MySQL. Keep application code runnable locally at first.
- JUnit/Spring Boot Test/Testcontainers and frontend component/e2e tests when each workflow is implemented.

Use the JDK version explicitly supported by the selected Spring Boot release. Keep JDK 27 installed for experimentation, but base the long-lived portfolio project on Java 25 LTS.

### Add later
- Go only after the Spring API and event boundaries are stable. Good first tasks: report export worker, webhook processor or stock reconciliation read-model. Start with a single service and one clear owner for each write model.
- Redis only when a concrete need appears (distributed cache, rate limiting or ephemeral sessions). Do not add Kafka or microservices just for the initial version.
- Object storage for product media when moving beyond local placeholder assets.

## Delivery milestones

### M0 — Database foundation (design draft complete; import validation pending)
Review ERD and state transitions; import V1 and seed once; inspect every FK and practice joins. Resolve any schema correction through a new draft before calling V1 applied.

### M1 — Project skeleton (scaffold started)
Create monorepo directories, Docker Compose MySQL, Spring Boot app, React storefront, Vue admin, environment examples, health endpoint, Flyway and OpenAPI. No real checkout yet.

### M2 — Identity and roles
Bootstrap first admin securely; login/session strategy; staff invitations; server-side permission checks; customer registration and profiles. Add seed password setup only through local bootstrap, never plaintext in SQL.

### M3 — Catalog
Category and product/variant reads; product search/filter; admin catalog CRUD and media metadata. Build React browsing and Vue catalog screens.

### M4 — Cart and checkout
Cart mutation, stock/price revalidation, coupon rules, tax/shipping snapshots, order creation, address/item snapshots and inventory reservation all handled server-side in a transaction.

### M5 — Order and payment
Customer order history; admin order queue/detail; fake payment provider first; signed, idempotent webhook flow; separate payment and order lifecycle transitions.

### M6 — Inventory and procurement
Warehouse stock views, adjustment reason/audit, low-stock report, supplier management, purchase order lifecycle and partial receipt.

### M7 — Fulfillment and returns
Pick/pack, shipment/tracking, split shipments, return approval/inspection, refund and restocking rules.

### M8 — Reviews and reports
Verified-purchase review, moderation, sales/margin/stock/returns dashboard, pagination and filtering.

### M9 — Reliability and portfolio finish
Integration and browser tests for core workflows, concurrency test for oversell prevention, seed/reset instructions, CI, Dockerized app deployment, OpenAPI docs and screenshots.

## API boundaries

Use one API server. Suggested route namespaces:
- /api/v1/auth/*
- /api/v1/store/products, /api/v1/store/cart, /api/v1/store/checkout, /api/v1/store/orders
- /api/v1/admin/catalog/*, /api/v1/admin/orders/*, /api/v1/admin/inventory/*, /api/v1/admin/purchasing/*, /api/v1/admin/fulfillment/*, /api/v1/admin/returns/*, /api/v1/admin/reports/*

Namespacing separates use cases, not trust. Every admin call checks backend permissions. Generate TypeScript clients from OpenAPI so React and Vue use the same DTO contract.

## First implementation boundary

The first useful vertical slice should be:
1. GET catalog/category/product/variant endpoints;
2. React category and product detail screens;
3. Vue admin product list/detail/create screens;
4. Spring validation, pagination, error format and OpenAPI.
Then move to auth and cart. Checkout comes after identity, catalog, pricing and stock policies are working.

