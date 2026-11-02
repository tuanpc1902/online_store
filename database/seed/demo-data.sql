-- Run after Flyway V1 creates the schema. Synthetic data only; run once.
USE ecommerce_platform;

INSERT INTO roles(role_id,code,name,description) VALUES
(1,'CUSTOMER','Customer','Storefront customer account'),
(2,'SUPPORT','Support agent','Customer service and order lookup'),
(3,'CATALOG_MANAGER','Catalog manager','Manage catalog, pricing and stock'),
(4,'FULFILLMENT','Fulfillment operator','Pick, pack and ship orders'),
(5,'FINANCE','Finance operator','Manage payments, refunds and purchasing'),
(6,'ADMIN','Administrator','Full application administration');
INSERT INTO permissions(permission_id,code,description) VALUES
(1,'catalog.read','View catalog'),(2,'catalog.write','Create and edit products'),
(3,'orders.read','View orders'),(4,'orders.manage','Process and cancel orders'),
(5,'inventory.manage','Adjust inventory'),(6,'fulfillment.manage','Pack and ship orders'),
(7,'returns.manage','Review product returns'),(8,'payments.manage','Issue refunds and reconcile payments'),
(9,'purchasing.manage','Create and receive supplier purchase orders'),
(10,'users.manage','Manage staff, roles and access'),(11,'reports.read','View operational reports');
INSERT INTO role_permissions(role_id,permission_id) VALUES
(1,1),(2,1),(2,3),(3,1),(3,2),(3,5),(4,1),(4,3),(4,4),(4,6),(5,3),(5,8),(5,9),
(6,1),(6,2),(6,3),(6,4),(6,5),(6,6),(6,7),(6,8),(6,9),(6,10),(6,11);
-- Seed staff accounts are invite-only. Set password_hash via the Spring admin bootstrap flow.
INSERT INTO app_users(user_id,email,password_hash,display_name,phone,user_status) VALUES
(1,'admin@shop.example',NULL,'Store Administrator','+84-90-000-0001','invited'),
(2,'support@shop.example',NULL,'Customer Support','+84-90-000-0002','invited'),
(3,'warehouse@shop.example',NULL,'Warehouse Operator','+84-90-000-0003','invited'),
(4,'finance@shop.example',NULL,'Finance Operator','+84-90-000-0004','invited');
INSERT INTO user_roles(user_id,role_id) VALUES(1,6),(2,2),(3,4),(4,5);
INSERT INTO employees(user_id,employee_code,department,job_title,hired_at) VALUES
(1,'EMP-0001','Management','Store Administrator','2024-01-15'),
(2,'EMP-0002','Customer Service','Support Agent','2024-06-01'),
(3,'EMP-0003','Operations','Fulfillment Operator','2024-08-12'),
(4,'EMP-0004','Finance','Finance Operator','2024-09-02');

INSERT INTO app_users(user_id,email,password_hash,display_name,phone,user_status,email_verified_at) VALUES
(5,'linh.nguyen@example.com',NULL,'Linh Nguyen','+84-90-100-2001','invited',NULL),
(6,'minh.tran@example.com',NULL,'Minh Tran','+84-91-200-3002','invited',NULL),
(7,'jordan.lee@example.com',NULL,'Jordan Lee','+1-415-555-0144','invited',NULL),
(8,'mai.vo@example.com',NULL,'Mai Vo','+84-98-500-6005','invited',NULL),
(9,'alex.chen@example.com',NULL,'Alex Chen','+65-8123-4568','invited',NULL);
INSERT INTO user_roles(user_id,role_id) VALUES(5,1),(6,1),(7,1),(8,1),(9,1);
INSERT INTO customers(customer_id,user_id,customer_number,first_name,last_name,birth_date,marketing_opt_in,customer_status) VALUES
(1,5,'CUS-000001','Linh','Nguyen','1994-05-12',TRUE,'active'),
(2,6,'CUS-000002','Minh','Tran','1988-11-03',FALSE,'active'),
(3,7,'CUS-000003','Jordan','Lee','1991-07-18',TRUE,'active'),
(4,8,'CUS-000004','Mai','Vo','1985-09-09',FALSE,'active'),
(5,9,'CUS-000005','Alex','Chen','1990-01-30',TRUE,'active');
INSERT INTO customer_addresses(address_id,customer_id,label,recipient_name,phone,line1,line2,ward,district,city,region,postal_code,country_code,is_default_shipping,is_default_billing) VALUES
(1,1,'Home','Linh Nguyen','+84-90-100-2001','12 Nguyen Trai','Apt 08-03','Ben Thanh','District 1','Ho Chi Minh City','Ho Chi Minh','700000','VN',TRUE,TRUE),
(2,1,'Office','Linh Nguyen','+84-90-100-2001','55 Vo Thi Sau','Reception','Ward 6','District 3','Ho Chi Minh City','Ho Chi Minh','700000','VN',FALSE,FALSE),
(3,2,'Home','Minh Tran','+84-91-200-3002','88 Le Loi',NULL,'Hai Chau 1','Hai Chau','Da Nang','Da Nang','550000','VN',TRUE,TRUE),
(4,3,'Home','Jordan Lee','+1-415-555-0144','410 Market Street','Unit 12',NULL,NULL,'San Francisco','CA','94111','US',TRUE,TRUE),
(5,4,'Home','Mai Vo','+84-98-500-6005','7 Tran Phu',NULL,'Loc Tho','Nha Trang','Nha Trang','Khanh Hoa','650000','VN',TRUE,TRUE),
(6,5,'Home','Alex Chen','+65-8123-4568','31 Orchard Road','#12-01',NULL,NULL,'Singapore','Singapore','238888','SG',TRUE,TRUE);

INSERT INTO brands(brand_id,name,slug) VALUES(1,'Northstar','northstar'),(2,'Saigon Works','saigon-works'),(3,'BrightHome','brighthome'),(4,'Trailcraft','trailcraft');
INSERT INTO categories(category_id,parent_category_id,name,slug,description,sort_order) VALUES
(1,NULL,'Electronics','electronics','Devices and computer accessories',1),(2,1,'Audio','audio','Headphones, speakers and microphones',1),
(3,1,'Computers','computers','Computer peripherals and displays',2),(4,1,'Accessories','accessories','Adapters, cables and desk accessories',3),
(5,NULL,'Home & Living','home-living','Useful products for home and office',2),(6,5,'Kitchen','kitchen','Drinkware and kitchen accessories',1),
(7,NULL,'Outdoor','outdoor','Equipment for travel and outdoor use',3);
INSERT INTO products(product_id,brand_id,name,slug,description,product_status,tax_class) VALUES
(1,1,'Studio Headphones','studio-headphones','Closed-back wired headphones for work, calls and travel.','active','standard'),
(2,1,'Wireless Earbuds','wireless-earbuds','Noise reducing earbuds with USB-C charging case.','active','standard'),
(3,2,'Mechanical Keyboard','mechanical-keyboard','Hot-swappable tenkeyless keyboard with tactile switches.','active','standard'),
(4,2,'USB-C Hub','usb-c-hub','Seven-port hub with HDMI, card reader and USB ports.','active','standard'),
(5,3,'Insulated Water Bottle','insulated-water-bottle','750 ml double-wall stainless steel bottle.','active','standard'),
(6,4,'Daypack 28L','daypack-28l','Weather-resistant commuter and day-hiking pack.','active','standard'),
(7,3,'LED Desk Lamp','led-desk-lamp','Dimmable lamp with warm and cool modes.','active','standard'),
(8,1,'USB Condenser Microphone','usb-condenser-microphone','USB microphone for calls and home recording.','active','standard');
INSERT INTO product_categories(product_id,category_id,is_primary) VALUES
(1,2,TRUE),(2,2,TRUE),(3,3,TRUE),(4,4,TRUE),(5,6,TRUE),(6,7,TRUE),(7,5,TRUE),(8,2,TRUE);
INSERT INTO product_media(product_id,media_url,alt_text,sort_order,is_primary) VALUES
(1,'https://images.example.test/products/headphones-front.jpg','Black studio headphones',1,TRUE),
(2,'https://images.example.test/products/earbuds-front.jpg','Wireless earbuds and case',1,TRUE),
(3,'https://images.example.test/products/keyboard-top.jpg','Tenkeyless mechanical keyboard',1,TRUE),
(4,'https://images.example.test/products/hub-front.jpg','Seven-port USB-C hub',1,TRUE);
INSERT INTO product_variants(variant_id,product_id,sku,variant_name,attributes,barcode,price,cost,weight_kg) VALUES
(1,1,'AUD-HDP-100-BLK','Black','{"color":"black","connection":"wired"}','8938500001001',89,48,.320),
(2,1,'AUD-HDP-100-WHT','White','{"color":"white","connection":"wired"}','8938500001002',89,48,.320),
(3,2,'AUD-EAR-220-BLK','Black','{"color":"black"}','8938500002001',129,71,.085),
(4,2,'AUD-EAR-220-WHT','White','{"color":"white"}','8938500002002',129,71,.085),
(5,3,'CMP-KBD-104-US','US Layout','{"layout":"US","switch":"tactile"}','8938500003001',99,52,.880),
(6,3,'CMP-KBD-104-UK','UK Layout','{"layout":"UK","switch":"tactile"}','8938500003002',103,54,.900),
(7,4,'ACC-HUB-007-GRY','Space Gray','{"color":"space gray","ports":7}','8938500004001',46,21,.120),
(8,5,'KIT-BTL-750-SLV','Silver','{"color":"silver","volume_ml":750}','8938500005001',29,11,.410),
(9,6,'OUT-BAG-028-OLV','Olive','{"color":"olive","volume_l":28}','8938500006001',79,41,.820),
(10,7,'HOM-DESK-01-BLK','Black','{"color":"black","dimmable":true}','8938500007001',42,19,1.100),
(11,8,'AUD-MIC-USB-BLK','Black','{"color":"black","connection":"usb-c"}','8938500008001',119,65,.650);
INSERT INTO suppliers(supplier_id,supplier_code,company_name,contact_name,email,country_code,payment_terms_days) VALUES
(1,'SUP-NS','Northstar Audio Ltd','Evelyn Park','sales@northstar.example','US',30),
(2,'SUP-SG','Saigon Tech Supply','Bao Le','orders@saigontech.example','VN',15),
(3,'SUP-BH','Bright Home Works','Nora Patel','trade@brighthome.example','GB',30),
(4,'SUP-TC','Trailcraft Outdoor','Kenji Sato','supply@trailcraft.example','JP',45);
INSERT INTO supplier_variants(supplier_id,variant_id,supplier_sku,unit_cost,lead_time_days,is_preferred) VALUES
(1,1,'NSA-HD100-B',48,12,TRUE),(1,2,'NSA-HD100-W',48,12,TRUE),(1,3,'NSA-EAR220-B',71,14,TRUE),(1,4,'NSA-EAR220-W',71,14,TRUE),(1,11,'NSA-MICUSB',65,14,TRUE),
(2,5,'SG-KBD-US',52,7,TRUE),(2,6,'SG-KBD-UK',54,7,TRUE),(2,7,'SG-HUB007',21,6,TRUE),
(3,8,'BH-BTL750',11,9,TRUE),(3,10,'BH-LAMP01',19,11,TRUE),(4,9,'TC-BAG28',41,16,TRUE);
INSERT INTO warehouses(warehouse_id,code,name,line1,city,region,country_code) VALUES
(1,'SGN-01','Ho Chi Minh Fulfillment Center','Lot A, Tan Binh Logistics Park','Ho Chi Minh City','Ho Chi Minh','VN'),
(2,'SEA-01','Seattle West Coast Warehouse','200 Pine Street','Seattle','WA','US');
INSERT INTO inventory(warehouse_id,variant_id,on_hand,reserved,reorder_point) VALUES
(1,1,25,2,6),(1,2,12,0,4),(1,3,18,1,5),(1,4,10,0,4),(1,5,14,1,4),(1,6,7,0,3),(1,7,45,2,10),(1,8,55,0,12),(1,9,11,1,4),(1,10,16,0,5),(1,11,8,0,3),
(2,1,15,0,5),(2,2,8,0,3),(2,3,20,0,6),(2,4,9,0,3),(2,5,11,0,4),(2,6,5,0,2),(2,7,30,0,8),(2,8,20,0,7),(2,9,18,0,6),(2,10,14,0,5),(2,11,13,0,4);
INSERT INTO coupons(coupon_id,code,description,discount_type,discount_value,minimum_subtotal,max_discount,starts_at,ends_at,max_redemptions,per_customer_limit) VALUES
(1,'WELCOME10','10 percent off first order','percent',10,40,50,'2025-01-01','2027-01-01',1000,1),
(2,'SHIP5','Five dollars off qualifying orders','fixed',5,50,NULL,'2025-01-01','2027-01-01',500,3);

INSERT INTO orders(order_id,order_number,customer_id,source,order_status,payment_status,fulfillment_status,currency,customer_email,customer_name,customer_phone,subtotal,discount_total,shipping_total,tax_total,grand_total,placed_at,customer_note) VALUES
(1,'ORD-2025-00001',1,'web','completed','paid','fulfilled','USD','linh.nguyen@example.com','Linh Nguyen','+84-90-100-2001',135,13.50,5,9.72,136.22,'2025-04-02 10:15:00','Please leave with reception.'),
(2,'ORD-2025-00002',2,'web','shipped','paid','fulfilled','USD','minh.tran@example.com','Minh Tran','+84-91-200-3002',145,5,0,11.20,151.20,'2025-04-04 14:40:00',NULL),
(3,'ORD-2025-00003',3,'web','partially_returned','partially_refunded','fulfilled','USD','jordan.lee@example.com','Jordan Lee','+1-415-555-0144',428,42.80,12,30.82,428.02,'2025-04-08 09:05:00','Gift order.'),
(4,'ORD-2025-00004',4,'admin','processing','authorized','unfulfilled','USD','mai.vo@example.com','Mai Vo','+84-98-500-6005',158,0,4,12.64,174.64,'2025-04-12 18:25:00',NULL),
(5,'ORD-2025-00005',5,'web','completed','paid','fulfilled','USD','alex.chen@example.com','Alex Chen','+65-8123-4568',116,11.60,10,8.35,122.75,'2025-04-15 12:02:00',NULL),
(6,'ORD-2025-00006',1,'web','cancelled','refunded','unfulfilled','USD','linh.nguyen@example.com','Linh Nguyen','+84-90-100-2001',99,0,0,7.92,106.92,'2025-04-19 16:50:00','Wrong keyboard layout selected.');
INSERT INTO order_addresses(order_id,address_type,recipient_name,phone,line1,line2,ward,district,city,region,postal_code,country_code) VALUES
(1,'billing','Linh Nguyen','+84-90-100-2001','12 Nguyen Trai','Apt 08-03','Ben Thanh','District 1','Ho Chi Minh City','Ho Chi Minh','700000','VN'),
(1,'shipping','Linh Nguyen','+84-90-100-2001','55 Vo Thi Sau','Office reception','Ward 6','District 3','Ho Chi Minh City','Ho Chi Minh','700000','VN'),
(2,'billing','Minh Tran','+84-91-200-3002','88 Le Loi',NULL,'Hai Chau 1','Hai Chau','Da Nang','Da Nang','550000','VN'),
(2,'shipping','Minh Tran','+84-91-200-3002','88 Le Loi',NULL,'Hai Chau 1','Hai Chau','Da Nang','Da Nang','550000','VN'),
(3,'billing','Jordan Lee','+1-415-555-0144','410 Market Street','Unit 12',NULL,NULL,'San Francisco','CA','94111','US'),
(3,'shipping','Jordan Lee','+1-415-555-0144','410 Market Street','Unit 12',NULL,NULL,'San Francisco','CA','94111','US'),
(4,'billing','Mai Vo','+84-98-500-6005','7 Tran Phu',NULL,'Loc Tho','Nha Trang','Nha Trang','Khanh Hoa','650000','VN'),
(4,'shipping','Mai Vo','+84-98-500-6005','7 Tran Phu',NULL,'Loc Tho','Nha Trang','Nha Trang','Khanh Hoa','650000','VN'),
(5,'billing','Alex Chen','+65-8123-4568','31 Orchard Road','#12-01',NULL,NULL,'Singapore','Singapore','238888','SG'),
(5,'shipping','Alex Chen','+65-8123-4568','31 Orchard Road','#12-01',NULL,NULL,'Singapore','Singapore','238888','SG'),
(6,'billing','Linh Nguyen','+84-90-100-2001','12 Nguyen Trai','Apt 08-03','Ben Thanh','District 1','Ho Chi Minh City','Ho Chi Minh','700000','VN'),
(6,'shipping','Linh Nguyen','+84-90-100-2001','12 Nguyen Trai','Apt 08-03','Ben Thanh','District 1','Ho Chi Minh City','Ho Chi Minh','700000','VN');
INSERT INTO order_items(order_item_id,order_id,variant_id,sku_snapshot,product_name_snapshot,variant_name_snapshot,quantity,unit_price,unit_cost_snapshot,discount_amount,tax_amount,line_total) VALUES
(1,1,1,'AUD-HDP-100-BLK','Studio Headphones','Black',1,89,48,8.90,5.77,85.87),
(2,1,7,'ACC-HUB-007-GRY','USB-C Hub','Space Gray',1,46,21,4.60,3.95,45.35),
(3,2,5,'CMP-KBD-104-US','Mechanical Keyboard','US Layout',1,99,52,0,7.92,106.92),
(4,2,7,'ACC-HUB-007-GRY','USB-C Hub','Space Gray',1,46,21,0,3.28,49.28),
(5,3,1,'AUD-HDP-100-BLK','Studio Headphones','Black',1,89,48,8.90,6.41,86.51),
(6,3,5,'CMP-KBD-104-US','Mechanical Keyboard','US Layout',1,99,52,9.90,7.13,96.23),
(7,3,7,'ACC-HUB-007-GRY','USB-C Hub','Space Gray',1,46,21,4.60,3.31,44.71),
(8,3,11,'AUD-MIC-USB-BLK','USB Condenser Microphone','Black',1,119,65,11.90,8.57,115.67),
(9,3,2,'AUD-HDP-100-WHT','Studio Headphones','White',1,75,48,7.50,5.40,72.90),
(10,4,3,'AUD-EAR-220-BLK','Wireless Earbuds','Black',1,129,71,0,10.32,139.32),
(11,4,8,'KIT-BTL-750-SLV','Insulated Water Bottle','Silver',1,29,11,0,2.32,31.32),
(12,5,9,'OUT-BAG-028-OLV','Daypack 28L','Olive',1,79,41,7.90,5.69,76.79),
(13,5,10,'HOM-DESK-01-BLK','LED Desk Lamp','Black',1,37,19,3.70,2.66,35.96),
(14,6,5,'CMP-KBD-104-US','Mechanical Keyboard','US Layout',1,99,52,0,7.92,106.92);
INSERT INTO order_coupons VALUES(1,1,13.50),(2,2,5),(3,1,42.80),(5,1,11.60);
INSERT INTO coupon_redemptions(coupon_id,customer_id,order_id,redeemed_at) VALUES(1,1,1,'2025-04-02'),(2,2,2,'2025-04-04'),(1,3,3,'2025-04-08'),(1,5,5,'2025-04-15');
INSERT INTO payments(payment_id,order_id,payment_method,provider,payment_status,amount,currency,provider_reference,paid_at,created_at) VALUES
(1,1,'card','Stripe','captured',136.22,'USD','pi_demo_10001','2025-04-02 10:16:13','2025-04-02 10:15:30'),
(2,2,'bank_transfer','Manual','captured',151.20,'USD','bank_demo_20002','2025-04-04 15:02:00','2025-04-04 14:41:00'),
(3,3,'card','Stripe','partially_refunded',428.02,'USD','pi_demo_10003','2025-04-08 09:06:00','2025-04-08 09:05:40'),
(4,4,'cash_on_delivery','Manual','authorized',174.64,'USD',NULL,NULL,'2025-04-12 18:25:10'),
(5,5,'card','Stripe','captured',122.75,'USD','pi_demo_10005','2025-04-15 12:03:12','2025-04-15 12:02:30'),
(6,6,'card','Stripe','refunded',106.92,'USD','pi_demo_10006','2025-04-19 16:51:00','2025-04-19 16:50:30');
INSERT INTO payment_transactions(payment_id,transaction_type,amount,provider_transaction_id,transaction_status,idempotency_key,response_code,created_at) VALUES
(1,'capture',136.22,'ch_demo_10001','succeeded','idem-demo-10001','00','2025-04-02 10:16:13'),
(2,'capture',151.20,'bank_demo_20002','succeeded','idem-demo-20002','00','2025-04-04 15:02:00'),
(3,'capture',428.02,'ch_demo_10003','succeeded','idem-demo-10003','00','2025-04-08 09:06:00'),
(3,'refund',72.90,'re_demo_10003','succeeded','idem-demo-refund-10003','00','2025-04-18 14:00:00'),
(5,'capture',122.75,'ch_demo_10005','succeeded','idem-demo-10005','00','2025-04-15 12:03:12'),
(6,'refund',106.92,'re_demo_10006','succeeded','idem-demo-refund-10006','00','2025-04-20 10:00:00');
INSERT INTO shipments(shipment_id,order_id,warehouse_id,carrier,service_level,tracking_number,shipment_status,shipping_cost,shipped_at,delivered_at) VALUES
(1,1,1,'GHN','Standard','GHN-DEMO-0001','delivered',3.20,'2025-04-02 16:00:00','2025-04-04 11:20:00'),
(2,2,1,'Viettel Post','Standard','VTP-DEMO-0002','in_transit',3.40,'2025-04-05 09:00:00',NULL),
(3,3,2,'UPS','Ground','UPS-DEMO-0003','delivered',8.50,'2025-04-09 12:00:00','2025-04-11 14:03:00'),
(4,5,2,'USPS','Ground','USPS-DEMO-0005','delivered',6.75,'2025-04-16 10:00:00','2025-04-19 13:25:00');
INSERT INTO shipment_items VALUES(1,1,1),(1,2,1),(2,3,1),(2,4,1),(3,5,1),(3,6,1),(3,7,1),(3,8,1),(3,9,1),(4,12,1),(4,13,1);
INSERT INTO customer_returns(return_id,return_number,order_id,requested_by_customer_id,return_status,reason_code,customer_comment,resolution,requested_at,approved_by_user_id,received_at) VALUES
(1,'RMA-2025-0001',3,3,'refunded','damaged_shipping','One headphone box arrived crushed.','refund','2025-04-15 09:30:00',2,'2025-04-18 14:00:00'),
(2,'RMA-2025-0002',5,5,'approved','changed_mind','Would like a different color.','replacement','2025-04-19 10:12:00',2,NULL);
INSERT INTO return_items VALUES(1,9,1,'damaged',72.90,FALSE),(2,12,1,'unopened',0,TRUE);
INSERT INTO reviews(product_id,customer_id,order_item_id,rating,title,review_text,review_status,moderated_by_user_id,created_at) VALUES
(1,1,1,5,'Great for focused work','Comfortable on long calls and the cable feels durable.','published',2,'2025-04-06'),
(4,1,2,4,'Useful travel hub','Works well with my laptop.','published',2,'2025-04-07'),
(3,2,3,5,'Solid keyboard','Good typing feel and easy setup.','published',2,'2025-04-09'),
(6,5,12,4,'Good weekend pack','Comfortable fit and enough room for a day hike.','published',2,'2025-04-20');
INSERT INTO purchase_orders(purchase_order_id,po_number,supplier_id,warehouse_id,status,currency,ordered_at,expected_at,created_by_user_id,note) VALUES
(1,'PO-2025-0001',1,1,'partially_received','USD','2025-04-01','2025-04-15',1,'Spring audio replenishment'),
(2,'PO-2025-0002',2,1,'submitted','USD','2025-04-12','2025-04-20',1,'Keyboard and adapter replenishment');
INSERT INTO purchase_order_items(purchase_order_item_id,purchase_order_id,variant_id,quantity_ordered,quantity_received,unit_cost) VALUES
(1,1,1,30,20,48),(2,1,3,24,24,71),(3,2,5,20,0,52),(4,2,7,40,0,21);
INSERT INTO stock_movements(warehouse_id,variant_id,movement_type,quantity_delta,reserved_delta,reference_type,reference_id,performed_by,note,occurred_at) VALUES
(1,1,'receipt',20,'purchase_order',1,3,'Partial receipt from PO-2025-0001','2025-04-12'),
(1,1,'reservation',0,-1,'order',1,NULL,'Reserved for ORD-2025-00001','2025-04-02'),
(1,1,'shipment',-1,'shipment',1,3,'Shipped ORD-2025-00001','2025-04-02'),
(1,7,'reservation',0,-1,'order',1,NULL,'Reserved for ORD-2025-00001','2025-04-02'),
(1,7,'shipment',-1,'shipment',1,3,'Shipped ORD-2025-00001','2025-04-02'),
(2,1,'return',1,'return',1,3,'Damaged return held for inspection','2025-04-18');
INSERT INTO wishlists(wishlist_id,customer_id,name,is_default) VALUES(1,1,'Gift ideas',TRUE),(2,2,'Workspace upgrades',TRUE);
INSERT INTO wishlist_items(wishlist_id,variant_id) VALUES(1,4),(1,9),(2,5),(2,11);
INSERT INTO inventory_reservations(order_item_id,warehouse_id,variant_id,quantity,reservation_status,expires_at,created_at) VALUES
(10,1,3,1,'active','2025-04-13 18:25:00','2025-04-12 18:25:00');
INSERT INTO goods_receipts(receipt_id,receipt_number,purchase_order_id,received_by_user_id,received_at,note) VALUES
(1,'GR-2025-0001',1,3,'2025-04-12 15:00:00','First partial delivery against PO-2025-0001');
INSERT INTO goods_receipt_items(receipt_id,purchase_order_item_id,quantity_received,unit_cost) VALUES(1,1,20,48),(1,2,24,71);INSERT INTO carts(cart_id,customer_id,session_key,cart_status,currency) VALUES(1,2,NULL,'active','USD'),(2,NULL,'guest-session-demo-123','active','USD');
INSERT INTO cart_items(cart_id,variant_id,quantity) VALUES(1,2,1),(1,8,2),(2,4,1);
INSERT INTO order_status_history(order_id,old_status,new_status,changed_by_user_id,reason,changed_at) VALUES
(1,NULL,'pending',NULL,'Order placed','2025-04-02 10:15:00'),
(1,'pending','confirmed',NULL,'Payment captured','2025-04-02 10:16:13'),
(1,'confirmed','processing',3,'Pick list created','2025-04-02 13:00:00'),
(1,'processing','shipped',3,'Handed to carrier','2025-04-02 16:00:00'),
(1,'shipped','completed',NULL,'Delivery confirmed','2025-04-04 11:20:00'),
(3,'completed','partially_returned',2,'Return refunded','2025-04-18 14:00:00');
INSERT INTO audit_logs(actor_user_id,action,entity_type,entity_id,before_data,after_data,ip_address,created_at) VALUES
(1,'product.price.updated','product_variant','1','{"price":85}','{"price":89}','192.0.2.10','2025-04-01 09:00:00'),
(2,'return.approved','customer_return','2',NULL,'{"status":"approved","resolution":"replacement"}','192.0.2.11','2025-04-19 10:30:00'),
(3,'purchase_order.received','purchase_order','1','{"status":"submitted"}','{"status":"partially_received"}','192.0.2.12','2025-04-12 15:00:00');
