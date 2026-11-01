# Database design

## Scope

MySQL is the authoritative transactional store for one online retailer. The design covers storefront sales and staff operations in the same database. It is intended for a Spring modular monolith with separate React and Vue clients. It is not yet a multi-tenant or multi-store schema.

The database starts with 44 InnoDB tables. Flyway V1 creates tables; demo-data.sql is a separate one-time local seed. Create the ecommerce_platform database separately before running Flyway.

## Entity groups and relationships

### Identity and organization
- app_users 1:N user_roles; roles 1:N user_roles. This is a many-to-many user/role relationship.
- roles 1:N role_permissions; permissions 1:N role_permissions.
- app_users 1:0..1 customers and 1:0..1 employees. A guest checkout can have no customer record; order contact snapshots still exist.
- customer profiles own customer_addresses. Orders copy address data into order_addresses.

### Catalog
- brands 1:N products; categories have a parent-child hierarchy.
- products M:N categories through product_categories.
- products 1:N product_variants and product_media.
- product_variants have unique SKUs and are the units sold, stocked, purchased and shipped.
- suppliers M:N product_variants through supplier_variants, with supplier-specific cost, SKU, lead time and preferred source.
- Category/product content is independent from order snapshots.

### Storefront and promotion
- A customer may own carts and wishlists; guest carts can use a session key.
- carts 1:N cart_items; a cart item references one sellable variant and quantity.
- wishlists 1:N wishlist_items.
- coupons connect to orders through order_coupons and coupon_redemptions. Stacking is an application rule; the data model can record multiple coupons on an order.
- Checkout records source_cart_id to prevent converting the same cart into multiple orders.

### Order and money
- customers 1:N orders, but customer_id is nullable for guests.
- orders 1:N order_items and have exactly one billing and one shipping order_addresses snapshot.
- order_items optionally reference the current variant, but always preserve SKU, product name, variant name, unit price and cost snapshots.
- orders use separate order_status, payment_status and fulfillment_status. One status field cannot represent these separate operations safely.
- orders 1:N payments. Each payment 1:N payment_transactions, so retries, capture, void, failures and refunds remain auditable.
- payment_webhook_events uses a unique provider/event ID for idempotent webhook processing.
- Amount columns use DECIMAL; currency is stored with each order/payment. Do not aggregate different currencies without an explicit FX conversion model.

### Inventory and fulfillment
- warehouses M:N product_variants through inventory.
- inventory stores on_hand, reserved and reorder_point; available quantity is on_hand - reserved.
- inventory_reservations allocates order lines to warehouses. Multiple reservations can split one order line over warehouses.
- stock_movements has independent physical quantity_delta and reserved_delta values. It is the event ledger for receipts, reservations, shipments, returns and adjustments.
- orders 1:N shipments; shipments M:N order_items through shipment_items, allowing partial and split shipments.
- purchase_orders belong to suppliers and destination warehouses. purchase_order_items identify variants and ordered/received quantities.
- goods_receipts represent actual deliveries and can be partial. goods_receipt_items link each receipt to its PO lines.
- customer_returns belong to orders; return_items identify returned order lines, condition, quantity and refund amount. Restocking is an explicit decision.

### Customer voice and management
- reviews connect customers to products and optionally a purchased order item.
- order_status_history stores state transitions and actor/reason.
- audit_logs stores privileged before/after changes.
- RBAC tables are authoritative for staff authorization. Frontend visibility is only a convenience.

## Invariants to enforce in Spring services and transactions

1. Money is computed on the server with BigDecimal; persist DECIMAL and round at documented currency precision. Never accept a client-computed grand total as authoritative.
2. Define subtotal as merchandise before order discounts; discount_total as the discounts applied; tax_total and shipping_total as saved checkout amounts; grand_total = subtotal - discount_total + tax_total + shipping_total. Allocate discounts to lines when reporting line revenue.
3. Snapshot recipient/address/contact and product/SKU/title/variant/price/cost/tax details at order placement. Historical reads use these snapshots.
4. One active cart is associated with the authenticated customer/session policy. Cart quantity and pricing are revalidated at checkout.
5. Checkout should be one transactional workflow: lock inventory rows, verify available units, create order and snapshots, create reservations and stock movements, claim coupon redemption, mark cart converted. Roll back the whole unit if any validation fails.
6. Reserve stock by increasing inventory.reserved and writing reserved_delta positive. On cancellation/expiry, decrease reserved and write a negative reserved_delta. On shipment, decrease both on_hand and reserved and write quantity_delta negative plus reserved_delta negative. Use one consistent rule in every path.
7. A goods receipt increases on_hand and writes quantity_delta positive. A PO alone never increases stock. Partial receipt must not exceed quantity ordered.
8. Returned goods remain outside sellable stock until inspected. A restockable return increases on_hand only after receipt and must have a matching stock movement.
9. Payment callbacks are authenticated and idempotent by provider/event ID and payment transaction idempotency key. Never store card numbers or CVVs.
10. Order, payment and fulfillment state machines are validated on the server; each transition is recorded. Do not let a client set status strings directly.
11. Every admin mutation checks permission at the service/API boundary and writes an audit record with actor and entity.
12. Database deletion is generally restricted by foreign keys. Archive/deactivate catalog and staff rows; preserve order, transaction and audit history.

## Decisions to revisit after the core app

- Tax rates/jurisdictions and shipping tax need a country/region model and a trusted tax calculation strategy before real sales.
- Multi-currency requires exchange-rate snapshots and settlement currency; until then, keep each report grouped by currency.
- Product variants use JSON attributes for flexible display options. If faceted variant filtering becomes important, normalize option names/values.
- Media URLs are metadata only; use object storage for real uploads.
- Decide whether customers have one cart or multiple named carts and whether guest cart merges on sign-in.
- Define loyalty, gift cards, bundles, subscriptions and multiple store locations only when the product scope needs them.
- Protect personal data, define retention/deletion policy, backups and access logging before real customer use.

## Important naming

Use customer_returns rather than returns, which can conflict with SQL syntax and is clearer in domain code. Use order_items rather than order_lines consistently across Java entities, DTOs and SQL.
