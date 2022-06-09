1. Write a query to display the customer_id,customer full name ,city,pincode,and 
order details (order id,order date, product class desc, 
product desc, subtotal(product_quantity * product_price)) 
for orders shipped to cities whose pin codes do not have any 0s in them. 
Sort the output on customer name, order date and subtotal.

Ans:
SELECT CUSTOMER_ID,CONCAT(CUSTOMER_FNAME," ",CUSTOMER_LNAME) AS FULLNAME,
	CITY,PINCODE,
    ORDER_ID,ORDER_DATE,
    PRODUCT_DESC,
    PRODUCT_CLASS_DESC,
    (order_items.PRODUCT_QUANTITY * product.PRODUCT_PRICE) AS SUBTOTAL
    FROM address
    JOIN online_customer
    USING (ADDRESS_ID)
    JOIN order_header
    USING (CUSTOMER_ID)
    JOIN order_items
   	USING (ORDER_ID)
    JOIN product
    USING(PRODUCT_ID)
    JOIN product_class
    USING (PRODUCT_CLASS_CODE)
    WHERE PINCODE NOT LIKE "%0%"  
	ORDER BY FULLNAME,SUBTOTAL,ORDER_DATE 


2. Write a Query to display product id,product description,totalquantity(sum(product quantity) 
for a given item whose product id is 201 and which item has been bought along 
with it maximum no. of times. (USE SUB-QUERY) (1 ROW)

SELECT DISTINCT OI1.PRODUCT_ID,COUNT(*) AS COUNT, PRODUCT_DESC
FROM order_items OI1
JOIN product USING (PRODUCT_ID)
WHERE (ORDER_ID) IN (SELECT ORDER_ID
			FROM order_items OI2
			WHERE OI2.PRODUCT_ID = 201)
            GROUP BY OI1.PRODUCT_ID 
		ORDER BY COUNT DESC 
		LIMIT 2
3.
SELECT c.CARTON_ID,
MIN(c.LEN*c.WIDTH*c.HEIGHT) AS CARTON_VOL
FROM carton c
WHERE (c.LEN*c.WIDTH*c.HEIGHT) >
(SELECT SUM(p.LEN*p.WIDTH*p.HEIGHT) FROM product p NATURAL JOIN order_items
WHERE order_items.ORDER_ID=10005);


4. 

SELECT CUSTOMER_ID, CONCAT(CUSTOMER_FNAME,' ',CUSTOMER_LNAME)AS FULLNAME, ORDER_ID, COUNT(PRODUCT_QUANTITY) AS TOTALPRODUCT
FROM online_customer
JOIN order_header USING (CUSTOMER_ID)
JOIN order_items USING (ORDER_ID)
WHERE ORDER_STATUS IN (SELECT ORDER_STATUS FROM order_header WHERE ORDER_STATUS = 'Shipped') 
GROUP BY ORDER_ID
HAVING SUM(PRODUCT_QUANTITY) > 10


5. Write a query to display the order_id, customer id and cutomer full name of customers along with (product_quantity) as total quantity of products shipped for order ids > 10060

SELECT ORDER_ID, CUSTOMER_ID, CUSTOMER_FNAME, COUNT(PRODUCT_QUANTITY) AS TOTAL_QUANTITY
FROM order_items
JOIN order_header USING (ORDER_ID)
JOIN online_customer USING (CUSTOMER_ID)
WHERE ORDER_ID > 10060 AND ORDER_STATUS = 'Shipped'
GROUP BY ORDER_ID

6. 
SELECT COUNTRY, PRODUCT_CLASS_DESC, SUM(PRODUCT_QUANTITY) AS TOTAL_QUANTITY, (PRODUCT_QUANTITY*PRODUCT_PRICE) AS TOTAL_VALUE
FROM address
JOIN online_customer USING (ADDRESS_ID)
JOIN order_header USING (CUSTOMER_ID)
JOIN order_items USING (ORDER_ID)
 JOIN product USING (PRODUCT_ID)
JOIN product_class USING (PRODUCT_CLASS_CODE)
WHERE ORDER_STATUS = 'Shipped'
AND COUNTRY NOT IN ('India','USA')
GROUP BY COUNTRY
HAVING MAX(PRODUCT_QUANTITY)
ORDER BY TOTAL_QUANTITY DESC
LIMIT 1