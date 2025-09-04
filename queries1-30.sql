-- 1. List all the columns of the Salespeople table.

select * from salespeople;

-- 2. List all customers with a rating of 100.

select *
from customers
where RATING = 100
;

-- 3. Find all records in the Customer table with NULL values in the city column.

select *
from customers
where CITY is null;

-- 4. Find the largest order taken by each salesperson on each date.

select s.SName,
		o.ODATE,
		max(o.AMT) as largest_order
from salespeople s
join orders o on o.SNUM = s.SNUM
group by SNAME, o.ODATE
;

-- 5. Arrange the Orders table by descending customer number.

select *
from orders
order by CNUM desc;

-- 6. Find which salespeople currently have orders in the Orders table.

select distinct snum
from orders 
;

-- 7. List names of all customers matched with the salespeople serving them.

select c.CNAME,
		sp.SNAME
from customers c
join salespeople sp on sp.SNUM = c.SNUM
-- group by c.CNAME, sp.SNAME
;

-- 8. Find the names and numbers of all salespeople who had more than one customer.

select SNUM,
		count(*) as total_customers
from salespeople
group by SNUM
having count(*) > 1
;

-- 9. Count the orders of each of the salespeople and output the results in descending order.

select snum,
		count(onum) as total_orders
from orders
group by snum
order by count(onum) desc
;

-- 10. List the Customer table if and only if one or more of the customers in the Customer table are
-- located in San Jose.

select *
from customers
where exists(select * from customers where CITY='San Jose')
;

-- 11. Match salespeople to customers according to what city they lived in.

select c.cname,
		s.SNAME
from customers c
join salespeople s on s.SNUM = c.SNUM
where c.CITY = s.CITY
;
-- 12. Find the largest order taken by each salesperson.

select s.SName,
		max(o.AMT) as largest_order
from salespeople s
join orders o on o.SNUM = s.SNUM
group by SNAME
;

-- 13. Find customers in San Jose who have a rating above 200.

select *
from customers
where CITY = "San Jose" and RATING > 200
;

-- 14. List the names and commissions of all salespeople in London.

select sname, COMM
from salespeople
where CITY='London'
;
-- 15. List all the orders of salesperson Motika from the Orders table.

select o.snum,
		o.ONUM
from orders o
join salespeople s on s.SNUM = o.SNUM
where s.SNAME="Motika"
;
-- 16. Find all customers with orders on October 3.

select c.cname
from customers c
join orders o on o.CNUM = c.CNUM
where o.ODATE = '1996-10-03' 
;

-- 17. Give the sums of the amounts from the Orders table, grouped by date, eliminating all those
-- dates where the SUM was not at least 2000.00 above the MAX amount.

select odate,
		sum(AMT) as amount
from orders
group by ODATE
having sum(AMT) >= (select max(AMT) from orders) + 2000
;

-- 18. Select all orders that had amounts that were greater than at least one of the orders from
-- October 6.

select odate,
		sum(AMT) as amount
from orders
group by ODATE
having sum(AMT) > (select min(amt) from orders 
					where ODATE = '1996-10-06'
                    )
;

-- 19. Write a query that uses the EXISTS operator to extract all salespeople who have customers
-- with a rating of 300.

select * 
from salespeople s
where exists(select * from customers c where c.SNUM = s.SNUM
							and RATING = 300)
;
-- 20. Find all pairs of customers having the same rating

select c1.CNAME AS Customer1,
       c2.CNAME AS Customer2,
       c1.RATING
from customers c1
join customers c2 on c2.RATING = c1.RATING
and c1.CNUM < c2.CNUM
;

-- 21. Find all customers whose CNUM is 1000 above the SNUM of Serres.

select *
from customers c
where c.CNUM = (select s.snum + 1000
					from salespeople s
                    where s.SNAME="Serres");

-- 22. Give the salespeople’s commissions as percentages instead of decimal numbers.

select snum,
		SNAME,
        concat(COMM * 100, "%") as commission
from salespeople
;
-- 23. Find the largest order taken by each salesperson on each date, eliminating those MAX orders
-- which are less than $3000.00 in value.

select snum,
		ODATE,
        max(AMT) as largest_order
from orders
group by snum, odate
having max(amt) > 3000
;
-- 24. List the largest orders for October 3, for each salesperson.

select snum,
		ODATE,
        max(AMT) as largest_order
from orders
where ODATE='1996-10-03'
group by snum, odate
;
-- 25. Find all customers located in cities where Serres (SNUM 1002) has customers.

select c.CNUM,
		c.CNAME
from customers c
join salespeople s on s.SNUM = c.SNUM
where s.SNUM = 1002
;
-- 26. Select all customers with a rating above 200.00.

select *
from customers
where RATING > 200
;
-- 27. Count the number of salespeople currently listing orders in the Orders table.

select count(distinct snum) as total_salespeople_with_orders
from orders;

-- 28. Write a query that produces all customers serviced by salespeople with a commission above
-- 12%. Output the customer’s name and the salesperson’s rate of commission.

select c.CNAME,
		s.COMM
from customers c
join salespeople s on s.SNUM = c.SNUM
where s.COMM > 0.12
;

-- 29. Find salespeople who have multiple customers.

select snum,
		count(*) as customers
from customers
group by snum
having count(*) > 1
;

-- 30. Find salespeople with customers located in their city

select distinct s.SNAME,
		c.CNAME
from salespeople s
join customers c on c.SNUM = s.SNUM
where c.CITY = s.CITY
;
