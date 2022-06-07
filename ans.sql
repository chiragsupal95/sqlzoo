1. Write a query to display the customer_id,customer full name ,city,pincode,and 
order details (order id,order date, product class desc, 
product desc, subtotal(product_quantity * product_price)) 
for orders shipped to cities whose pin codes do not have any 0s in them. 
Sort the output on customer name, order date and subtotal.

Ans:
SELECT CUSTOMER_ID,CUSTOMER_FNAME,CUSTOMER_LNAME,
	CITY,PINCODE,
    ORDER_ID,ORDER_DATE,
    PRODUCT_DESC,
    PRODUCT_CLASS_DESC,
    (order_items.PRODUCT_QUANTITY * product.PRODUCT_PRICE) AS SUBTOTAL
    FROM address
    JOIN online_customer
    ON online_customer.ADDRESS_ID = address.ADDRESS_ID
    JOIN order_header
    USING (CUSTOMER_ID)
    JOIN order_items
   	USING (ORDER_ID)
    JOIN product
    USING(PRODUCT_ID)
    JOIN product_class
    USING (PRODUCT_CLASS_CODE)
    WHERE PINCODE NOT LIKE "%0%"  
	ORDER BY CUSTOMER_FNAME,SUBTOTAL,ORDER_DATE 


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