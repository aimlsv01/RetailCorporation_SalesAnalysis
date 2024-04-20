-- Removing Empty Blanks in orders table
UPDATE `retail corporation_sales`.`orders` 
SET
   order_id = NULLIF(order_id,''),
   customer_id = NULLIF(customer_id,''),
   order_status = NULLIF(order_status,''),
   order_purchase_timestamp = NULLIF(order_purchase_timestamp,''),
   order_approved_at = NULLIF(order_approved_at,''),
   order_delivered_carrier_date = NULLIF(order_delivered_carrier_date,''),
   order_delivered_customer_date = NULLIF(order_delivered_customer_date,''),
   order_estimated_delivery_date = NULLIF(order_estimated_delivery_date,'')
  ;

-- Changing Datatype of date type columns in orders table
ALTER TABLE `retail corporation_sales`.`orders` 
MODIFY COLUMN `order_purchase_timestamp` DATETIME NULL,
MODIFY COLUMN `order_approved_at` DATETIME NULL,
MODIFY COLUMN `order_delivered_carrier_date` DATETIME NULL,
MODIFY COLUMN `order_delivered_customer_date` DATETIME NULL,
MODIFY COLUMN `order_estimated_delivery_date` DATETIME NULL;


# Assigning Primary Keys and Foreign Keys
ALTER TABLE `retail corporation_sales`.`customers` 
CHANGE COLUMN `customer_id` `customer_id` CHAR(32) NOT NULL ,
ADD PRIMARY KEY (`customer_id`);

ALTER TABLE `retail corporation_sales`.`orders` 
CHANGE COLUMN `order_id` `order_id` CHAR(32) NOT NULL ,
ADD PRIMARY KEY (`order_id`);

ALTER TABLE `retail corporation_sales`.`orders` 
CHANGE COLUMN `customer_id` `customer_id` CHAR(32) NOT NULL ,
ADD INDEX `customer_id_idx` (`customer_id` ASC) VISIBLE;

ALTER TABLE `retail corporation_sales`.`orders` 
ADD CONSTRAINT `customer_id` FOREIGN KEY (`customer_id`)
REFERENCES `retail corporation_sales`.`customers` (`customer_id`);

ALTER TABLE `retail corporation_sales`.`payments` 
ADD CONSTRAINT `order_id` FOREIGN KEY (`order_id`)
REFERENCES `retail corporation_sales`.`orders` (`order_id`);