use dac;

-- 31. Find all salespeople whose name starts with ‘P’ and the fourth character is ‘l’

select sname
from salespeople
where SNAME like "___l%"
;
-- 32. Write a query that uses a subquery to obtain all orders for the customer named Cisneros.
-- Assume you do not know his customer number.

select * 
from orders
where CNUM = (select CNUM
                from customers
                where CNAME = "Cisneros")
;

-- 33. Find the largest orders for Serres and Rifkin.

select *
from orders 
where (SNUM,AMT) in 
(select SNUM,
		max(AMT) from orders 
        where SNUM in (
		select SNUM 
        from salespeople 
        where SNAME in ('Serres', 'Rifkin' )
        )
        group by SNUM
)
;
-- 34. Extract the Salespeople table in the following order : SNUM, SNAME, COMMISSION, CITY.
select snum,
		SNAME,
        COMM,
        CITY
from salespeople;

-- 35. Select all customers whose names fall in between ‘A’ and ‘G’ alphabetical range.
select * 
from customers
where CNAME between 'a' and 'g'
;
-- 36. Select all the possible combinations of customers that you can assign.
select c.cname as customer1, c1.CNAME as customer2
from customers c
join customers c1 on c1.CNUM < c.CNUM
;

-- 37. Select all orders that are greater than the average for October 4.
select *
from orders
where ODATE = '1996-10-04'
and amt > (
select avg(AMT) from orders where ODATE = '1996-10-04')
;

-- 38. Write a select command using a corelated subquery that selects the names and numbers of all
-- customers with ratings equal to the maximum for their city.

select c1.CNUM, c1.CNAME
from customers c1
where RATING = (select max(c.RATING) from customers c
					where c1.CITY = c.CITY)
;
-- using window function
SELECT CNUM, CNAME, CITY, RATING
FROM (
    SELECT 
        CNUM, CNAME, CITY, RATING,
        MAX(RATING) OVER (PARTITION BY CITY) AS max_city_rating
    FROM customers
) t
WHERE RATING = max_city_rating;

-- 39. Write a query that totals the orders for each day and places the results in descending order.

select odate,
		sum(AMT) as total
from orders
group by ODATE
order by total desc
;

-- 40. Write a select command that produces the rating followed by the name of each customer in
-- San Jose
select RATING, CNAME
from customers
where CITY="San Jose"
;

-- 41. Find all orders with amounts smaller than any amount for a customer in San Jose.

select ODATE, AMT, CNUM
from orders
where AMT < any (
		select o.amt from orders o
        join customers c on c.SNUM = o.SNUM
        where c.CITY='san Jose'
        )
;
-- 42. Find all orders with above average amounts for their customers.

select odate, amt
from orders
where amt > (select avg(amt)
			from orders)
            ;

-- 43. Write a query that selects the highest rating in each city.

select city,
		max(RATING)
from customers
group by city
;
-- 44. Write a query that calculates the amount of the salesperson’s commission on each order by a
-- customer with a rating above 100.00.

select s.snum, s.SNAME,
		(o.AMT * s.COMM) as commission, 
        o.ODATE
from salespeople s
join customers c on c.SNUM = s.SNUM
join orders o on o.CNUM = c.CNUM
where c.RATING > 100
;

-- 45. Count the customers with ratings above San Jose’s average.

select count(*) as total_customers
from customers
where RATING > (select avg(RATING)
				from customers
                where CITY ='San Jose');

-- 46. Write a query that produces all pairs of salespeople with themselves as well as duplicate rows
-- with the order reversed.

select s1.SNAME as salesperson1,
		s2.SNAME as salesperson2
from salespeople s1
join salespeople s2
on 1=1;

-- 47. Find all salespeople that are located in either Barcelona or London.
select sname
from salespeople
where CITY in ('Barcelona','london')
;

-- 48. Find all salespeople with only one customer.

select s.SNUM, s.SNAME,
		count(*) as customers
from salespeople s
join customers c on c.SNUM = s.SNUM
group by s.SNUM
having count(*) = 1
-- order by count(*) desc
;

-- 49. Write a query that joins the Customer table to itself to find all pairs of customers served by a
-- single salesperson.

select c1.cname as customer1,
		c2.CNAME as customer2
from customers c1
join customers c2
on c1.CNUM = c2.CNUM

;

-- 50. Write a query that will give you all orders for more than $1000.00
select *
from orders
where AMT> 1000
;

-- 51. Write a query that lists each order number followed by the name of the customer who made
-- that order.

select o.onum, c.CNAME 
from orders o
join customers c on c.CNUM = o.CNUM
;

-- 52. Write 2 queries that select all salespeople (by name and number) who have customers in their
-- cities who they do not service, one using a join and one a corelated subquery. Which solution
-- is more elegant?

select distinct s.snum, s.sname
from salespeople s
join customers c on c.CITY = s.CITY
and s.SNUM <> c.SNUM
;

select s.snum, s.sname
from salespeople s
where exists(
	select 1
    from customers c
    where c.CITY = s.CITY
    and c.SNUM <> s.SNUM
);

-- 53. Write a query that selects all customers whose ratings are equal to or greater than ANY (in the
-- SQL sense) of Serres’?

select *
from customers
where rating >= any (
	select rating from customers where snum =(
			select snum from salespeople where sname='Serres')
	)
;

-- 54. Write 2 queries that will produce all orders taken on October 3 or October 4.

select *
from orders
where ODATE in ('1996-10-03', '1996-10-04')
;

select *
from orders
where ODATE = '1996-10-04' or ODATE = '1996-10-03'
;

-- 55. Write a query that produces all pairs of orders by a given customer. Name that customer and
-- eliminate duplicates.

select c.CNAME AS Customer,
       o1.ONUM AS Order1,
       o2.ONUM AS Order2
from orders o1
join orders o2 on o1.CNUM = o2.CNUM   -- same customer
 and o1.ONUM < o2.ONUM   -- eliminate duplicates & self-pairs
join customers c on o1.CNUM = c.CNUM;

-- 56. Find only those customers whose ratings are higher than every customer in Rome.

select *
from customers
where RATING > any (
		select RATING from customers
        where CITY ='Rome'
        )
;

-- 57. Write a query on the Customers table whose output will exclude all customers with a rating <=
-- 100.00, unless they are located in Rome.

select *
from customers
where RATING > 100 or CITY='Rome';

-- 58. Find all rows from the Customers table for which the salesperson number is 1001.

select *
from customers
where SNUM=1001;

-- 59. Find the total amount in Orders for each salesperson for whom this total is greater than the
-- amount of the largest order in the table.

select snum,
		sum(AMT) as total_amount
from orders
group by snum
having sum(AMT) > (
	select max(amt)
    from orders
	)
;
-- 60. Write a query that selects all orders save those with zeroes or NULLs in the amount field

select *
from orders
where amt is not null and amt <> 0
;

