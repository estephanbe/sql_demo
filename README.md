
1. Joins:

This modified query will combine the first and last name of each customer with a space between them, and display them as a single column named "full_name". The email address will still be displayed in a separate column.

| Query | Description |
|-------|-------------|
|`SELECT c.first_name, c.last_name, o.order_date FROM Customers c INNER JOIN Orders o ON c.id = o.customer_id;`| Inner join between the Customers and Orders table to retrieve the customer's name and order date. |
|`SELECT CONCAT(Customers.first_name, ' ', Customers.last_name) AS full_name, Customers.email, Orders.order_date FROM Customers INNER JOIN Orders ON Customers.id = Orders.customer_id;`| Select the first and last name concatenated with a space and the email address of all customers. The CONCAT() function is used to concatenate the first_name and last_name columns together. The AS keyword is used to give the resulting column the alias "full_name". |
|`SELECT CONCAT(Customers.first_name, ' ', Customers.last_name) AS full_name, SUM(Orders.total_amount) AS totals FROM Customers LEFT JOIN Orders ON Customers.id = Orders.customer_id GROUP BY full_name ORDER BY totals DESC;`| Left join between the Customers and Orders table to retrieve total number of order amounts aggregated by customer name. |
|`SELECT c.first_name, c.last_name, o.order_date FROM Customers c LEFT JOIN Orders o ON c.id = o.customer_id;`| Left join between the Customers and Orders table to retrieve all customers and their orders, even if they have not made any orders yet. |
|`SELECT c.first_name, c.last_name, o.order_date FROM Customers c FULL OUTER JOIN Orders o ON c.id = o.customer_id; MySQL SELECT Customers.first_name, Customers.last_name, Orders.order_date FROM Customers LEFT JOIN Orders ON Customers.id = Orders.customer_id UNION SELECT Customers.first_name, Customers.last_name, NULL AS order_date FROM Customers WHERE Customers.id NOT IN (SELECT DISTINCT customer_id FROM Orders);`| Full outer join between the Customers and Orders table to retrieve all customers and their orders, including those with null values. |

2. Subqueries:

| Query | Description |
|-------|-------------|
|`SELECT * FROM Customers WHERE id IN (SELECT customer_id FROM Orders);`| Retrieve all customers who have made an order. |
|`SELECT * FROM Customers WHERE id NOT IN (SELECT customer_id FROM Orders);`| Retrieve all customers who have not made an order. |
|`SELECT c.first_name, c.last_name, (SELECT SUM(total_amount) FROM Orders WHERE customer_id = c.id) AS total_spent FROM Customers c;`| Retrieve the total amount of orders made by each customer. |

3. Transactions in PHP:
https://www.w3schools.com/php/php_mysql_insert_multiple.asp

START TRANSACTION;    -- Begin a transaction.
INSERT INTO Customers (first_name, last_name, email) VALUES ('John', 'Doe', 'john.doe@example.com');    -- Insert a new customer.
INSERT INTO Orders (customer_id, order_date, total_amount, status) VALUES (LAST_INSERT_ID(), CURDATE(), 50.00, 'Complete');    -- Insert a new order for the customer just inserted.
COMMIT;    -- Commit the transaction.

-- Some time later...

START TRANSACTION;    -- Begin a new transaction.
DELETE FROM Orders WHERE customer_id = (SELECT id FROM Customers WHERE email = 'john.doe@example.com');    -- Delete the order(s) for the customer.
ROLLBACK;    -- Roll back the transaction.

Transactions are used to ensure data consistency and integrity in cases where multiple queries need to be executed as a single unit of work. By wrapping multiple queries in a transaction, you can ensure that either all of the queries are executed successfully, or none of them are executed at all.

In situations where you only need to execute a single query, transactions may not be necessary. However, in many real-world scenarios, data is modified by multiple queries that depend on each other. For example, consider a banking application where a user wants to transfer money from one account to another. This operation involves two separate queries: one to deduct the amount from the source account, and another to add the amount to the destination account. If these two queries are not executed atomically (i.e., as a single transaction), then it's possible for the data to become inconsistent if one query succeeds and the other fails. In this case, the user's balance could be debited without being credited to the destination account, resulting in an overall loss of funds.

Transactions also provide some additional benefits, such as:

- Rollback: If any of the queries within a transaction fail, you can roll back the entire transaction to its previous state, effectively undoing any changes that were made. This is especially useful when working with large and complex transactions that involve multiple queries.

- Isolation: Transactions provide a level of isolation between different queries, ensuring that changes made by one query are not visible to others until the transaction is committed. This prevents race conditions and other concurrency issues that can occur when multiple queries are executed simultaneously.

Overall, while transactions may not be necessary for simple queries that modify a single record or table, they are an essential tool for maintaining data integrity and consistency in more complex scenarios.

=================================
DATABASE Performance
=================================

4. Views:

| Query | Description |
|-------|-------------|
|`CREATE VIEW v_customer_orders AS SELECT c.first_name, c.last_name, o.order_date, o.total_amount FROM Customers c INNER JOIN Orders o ON c.id = o.customer_id;`| Create a view to retrieve the customer's name and order information. |
|`SELECT * FROM v_customer_orders WHERE total_amount > 100;`| Select data from the view to retrieve all orders where the total amount is greater than 100. |

5. Temporary Tables:

| Query | Description |
|-------|-------------|
|`CREATE TEMPORARY TABLE temp_orders (order_date DATE, total_amount DECIMAL(10,2));`| Create a temporary table to store order information. |
|`INSERT INTO temp_orders SELECT order_date, total_amount FROM Orders WHERE customer_id = 1;`| Insert data into the temporary table based on a query. |
|`SELECT * FROM temp_orders;`| Select data from the temporary table to retrieve all orders for a specific customer. |
|`DROP TEMPORARY TABLE temp_orders;`| Drop the temporary table. |


Views and temporary tables are both used in SQL to manipulate and retrieve data, but they serve different purposes and have some key differences.

A view is a virtual table that is based on the result of a SELECT statement. It allows you to present data from one or more tables in a customized way without actually modifying the underlying tables. Views can be used to simplify complex queries, restrict access to certain columns or rows of data, or present data in a way that's more meaningful or convenient for the user. Views are stored in the database and can be reused in multiple queries.

A temporary table, on the other hand, is a physical table that is created on-the-fly and exists only for the duration of a session or transaction. Temporary tables can be used to store intermediate results, break down complex queries into smaller parts, or create ad-hoc data structures for specific operations. Temporary tables are typically faster than views for complex queries because they are physical tables and have indexes, but they require more memory and can be slower to create and destroy.

In summary, views are virtual tables that allow you to present data from one or more tables in a customized way, while temporary tables are physical tables that are created on-the-fly and exist only for the duration of a session or transaction. Views are stored in the database and can be reused in multiple queries, while temporary tables are typically faster for complex queries but require more memory and can be slower to create and destroy.
