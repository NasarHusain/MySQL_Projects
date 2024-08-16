use film_rental;
select * from actor;
select * from address;
select * from category;
select * from city;
select * from country;
select * from customer;
select * from film;
select (rental_duration*rental_rate) from film;
select * from film_actor;
select * from film_category;
select * from inventory;
select * from language;
select * from payment;
select * from rental;
select * from staff; 
select * from store;
 # 1.	What is the total revenue generated from all rentals in the database? 
select sum(amount) from payment;

# 2.	How many rentals were made in each month_name
SELECT
    MONTHNAME(rental_date) AS month_name,
    COUNT(rental_id) AS rental_count
FROM rental
GROUP BY month_name
order by rental_count;

SELECT
    MONTHNAME(rental_date) AS month_name,
    COUNT(rental_id) AS rental_count
FROM rental
GROUP BY month_name
order by month_name;  #alphabatical order

#3.What is the rental rate of the film with the longest title in the database? 
SELECT film_id,title,description,MAX(length(description)) as MX,rental_rate from film
group by film_id #title,description,rental_rate      #Note group by we only used film_id
order by MX desc;
               #or
SELECT film_id,title,description,length(description) as MX,rental_rate from film
order by MX desc limit 1;
          #or
select film_id,title,description,length(description) as MX from film 
where length(description) = (select Max(length(description)) from film);
               #or
select film_id,title,description,length(description) as MX from film 
having MX = (select Max(length(description)) from film);   #should use alice with having cluase. if we use alice name in where clause it will show error
                 #or
#we can use alice name with where clause this method
select * from
 (select film_id,title,description,length(description) as Mx from film) as subquery
 where MX = (Select Max(length(description)) from film);
	   #or
select film_id,title,description,mx from
 (select  film_id,title,description,length(description) as Mx from film) as subquery
 where MX = (Select Max(length(description)) from film);
              #or
SELECT film_id, title, description, LENGTH(description) AS MX
FROM (
    SELECT film_id, title,description, LENGTH(description) AS len,
           RANK() OVER (ORDER BY LENGTH(description) DESC) AS rnk
    FROM film
) AS ranked_films
where rnk=1;
         #or
SELECT * 
FROM (
    SELECT film_id, title, description, LENGTH(description) AS len,
           RANK() OVER (ORDER BY LENGTH(description) DESC) AS rnk
    FROM film
) AS ranked_films
having rnk = 1;
		#or
SELECT film_id, title, description, LENGTH(description) AS len,rnk
FROM (
    SELECT *,
           RANK() OVER (ORDER BY LENGTH(description) DESC) AS rnk
    FROM film
)  ranked_films
WHERE rnk = 1;
		#or
 with cte as( SELECT film_id, title, description, LENGTH(description) as len ,
           RANK() OVER (ORDER BY LENGTH(description) DESC) AS rnk
    FROM film)
select * from cte where rnk =1;   #or select * from cte having rnk = 1;
        #or     
 SELECT film_id, title, description, LENGTH(description) AS len,rnk
FROM (
    SELECT *,
           RANK() OVER (ORDER BY LENGTH(description) DESC) AS rnk
    FROM film
) AS ranked_films
having len  = (select max(length(description)) from film);  #   #just for study purpose
      #or
 WITH ranked_films AS (
    SELECT *,
           RANK() OVER (ORDER BY LENGTH(description) DESC) AS rnk
    FROM film
)
SELECT film_id, title, description, LENGTH(description) AS len, rnk
FROM ranked_films
having len = (SELECT MAX(LENGTH(description)) FROM film);     #just for study purpose
  
SELECT film_id,title,description,MAX(length(description)) as MX,rental_rate from film
group by rental_rate;   #note the error becuause rental_rate is not eligible for group by

# 4.	What is the average rental rate for films that were taken from the last 30 days from the date("2005-05-05 22)
select rental_date from rental;

SELECT AVG(f.rental_rate) AS average_rental_rate
FROM Film f
JOIN Inventory i ON f.film_id = i.film_id
JOIN Rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date >= DATE_SUB('2005-05-05 22:04:30', INTERVAL 30 DAY)
AND r.rental_date <= '2005-06-05 22:04:30';
         #or
SELECT AVG(f.rental_rate) AS average_rental_rate
FROM Film f
JOIN Inventory i ON f.film_id = i.film_id
JOIN Rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date >= DATE_SUB('2005-05-05 22:04:30', INTERVAL 30 DAY);
              #or
SELECT AVG(f.rental_rate) AS average_rental_rate
FROM Film f
JOIN Inventory i ON f.film_id = i.film_id
JOIN Rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date >=('2005-05-05 22:04:30') and r.rental_date <= ('2005-06-05 22:04:30'); 
				#or
SELECT AVG(f.rental_rate) AS average_rental_rate
FROM Film f
JOIN Inventory i ON f.film_id = i.film_id
JOIN Rental r ON i.inventory_id = r.inventory_id
WHERE DATE(r.rental_date) BETWEEN '2005-05-05' AND '2005-06-05';

select Avg(f.rental_rate) as Average_rental_rate from film f where f.film_id in
(select i.film_id from Inventory i where inventory_id in
(select r.inventory_id from rental r where DATE(r.rental_date) >= DATE_SUB('2005-05-05 22:04:30', INTERVAL 30 DAY))); 
         #or
SELECT AVG(rental_rate) AS average_rental_rate
FROM Film
WHERE film_id IN (
    SELECT film_id
    FROM Inventory
    WHERE inventory_id IN (
        SELECT inventory_id
        FROM Rental
        WHERE rental_date >= DATE_SUB('2005-05-05 22:04:30', INTERVAL 30 DAY )
    )
);


# 5.	What is the most popular category of films in terms of the number of rentals? 
select c.category_id,c.name,count(r.rental_id) as popular_category from category c
left join film_category fc
on c.category_id = fc.category_id
left join film f
on fc.film_id = f.film_id
left join inventory i
on f.film_id = i.film_id
left join rental r
on i.inventory_id = r.inventory_id 
group by c.category_id order by popular_category desc limit 1 ;
			#or
select c.category_id,c.name,count(*) as popular_category from category c
join film_category fc
on c.category_id = fc.category_id
join film f
on fc.film_id = f.film_id
join inventory i
on f.film_id = i.film_id
join rental r
on i.inventory_id = r.inventory_id group by c.category_id order by popular_category;

select * from rental;
select * from category;

# 6.Find the longest movie duration from the list of films that have not been rented by any customer. 
select f.film_id,f.title,f.length,group_concat(r.rental_id) as no_rentals from film f 
left join inventory i
on f.film_id = i.film_id
left join rental r
on i.inventory_id = r.inventory_id group by f.film_id having no_rentals is null order by f.length desc limit 1;

select f.film_id,f.title,max(f.length) as no_rentals from film f 
left join inventory i
on f.film_id = i.film_id
left join rental r
on i.inventory_id = r.inventory_id group by f.film_id;  #max function is not worked here properly because it is based on groupby

#count only filter value
select count(*) from
(select f.film_id,f.title,f.length,group_concat(r.rental_id) as no_rentals from film f 
left join inventory i
on f.film_id = i.film_id
left join rental r
on i.inventory_id = r.inventory_id group by f.film_id) as subquery;

 # 7.What is the average rental rate for films, broken down by category?
select c.category_id,c.name,avg(f.rental_rate) as average from category c
inner join film_category fc
on c.category_id = fc.category_id
inner join film f
on fc.film_id = f.film_id group by c.category_id;

SELECT c.category_id,c.name,AVG(f.rental_rate) AS average,COUNT(*) AS count_films
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id 
GROUP BY c.category_id, c.name;

select count(*) from(
SELECT c.category_id,c.name,AVG(f.rental_rate) AS average,COUNT(*) AS count_films
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id 
GROUP BY c.category_id, c.name) as subq;

  #understand difference between below and this query
SELECT 
    COUNT(*) AS total_categories,
    count(category_id) as tc,   #dont use c.category_id here
    count(sum_amount) as tc,
    Sum(count_films) AS total_films,
    SUM(sum_amount) AS total_rental_sum
FROM (
    SELECT c.category_id,c.name,SUM(f.rental_rate) AS Sum_amount,COUNT(*) AS count_films FROM category c 
    INNER JOIN film_category fc ON c.category_id = fc.category_id
    INNER JOIN film f ON fc.film_id = f.film_id 
    GROUP BY c.category_id, c.name
) AS subq;

#understand difference above and this query,count is most important
SELECT sum(f.rental_rate) dd,COUNT(c.category_id) count_films,count(*) as cf
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id;

select count(*) from category;

SELECT sum(f.rental_rate) AS sss,COUNT(*) AS count_films
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id;

# 8.What is the total revenue generated from rentals for each actor in the database
select a.actor_id,concat(a.first_name,' ' ,a.last_name) as Name,sum(p.amount) as tot_rev from actor a
left join  film_actor fa  on a.actor_id = fa.actor_id
left join film f on fa.film_id = f.film_id 
left join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
left join payment p on r.rental_id= p.rental_id
group by a.actor_id;

# 9.Show all the actresses who worked in a film having a "Wrestler" in the description. 
select a.actor_id,a.first_name,a.last_name,f.description from actor a
left join film_actor fa
on a.actor_id = fa.actor_id
left join film f
on fa.film_id = f.film_id
where f.description like "%Wrestler%";

# 10.Which customers have rented the same film more than once? 
SELECT c.customer_id,concat(c.first_name," ",c.last_name) as Full_Name,f.title AS film_title,
COUNT(*) AS rental_count
FROM customer c 
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id 
GROUP BY customer_id,full_name,film_title
HAVING rental_count > 1
order by customer_id;

-- fix incompatible with sql_mode=only_full_group_by
-- SET sql_mode = '';
-- SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

#this is incompatible with sql_mode=only_full_group_by
SELECT c.customer_id,concat(c.first_name," ",c.last_name) as Full_Name,f.title AS film_title,
COUNT(*) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY c.customer_id   #full_name
HAVING rental_count > 1
order by customer_id desc;

#this is incompatible with sql_mode=only_full_group_by. this is not a proper way
SELECT c.customer_id,concat(c.first_name," ",c.last_name) as Full_Name,f.title AS film_title,
COUNT(*) AS rental_count
FROM customer c 
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id where c.customer_id in(511)
group by c.customer_id;

SELECT c.customer_id,concat(c.first_name," ",c.last_name) as Full_Name,f.title AS film_title,
COUNT(*) AS rental_count
FROM customer c 
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id where c.customer_id in(511)
GROUP BY customer_id,full_name,film_title;


# 11.	How many films in the comedy category have a rental rate higher than the average rental rate?
SELECT c.category_id,c.name,COUNT(*) AS comedy_films_count
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
where c.name ="comedy" and f.rental_rate > (select Avg(rental_rate) from film)
group by c.category_id,c.name;

# 12.Which films have been rented the most by customers living in each city? 
WITH RankedRentals AS (
    SELECT c.city_id,c.city,f.title AS film_title,COUNT(*) AS rental_count,
        ROW_NUMBER() OVER (PARTITION BY c.city_id ORDER BY count(*) DESC) AS ranking
    FROM customer cu
    JOIN rental r ON cu.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN address a ON cu.address_id = a.address_id
    JOIN city c ON a.city_id = c.city_id
    GROUP BY c.city_id,c.city,f.title
)
SELECT city_id,city,film_title,rental_count FROM RankedRentals WHERE ranking =1;   # select * we can use

#should give alice name because of use c_id,city in outer select query
select c_id,city,film_title,rental_count from(
	SELECT c.city_id as c_id,c.city city,f.title AS film_title,COUNT(*) AS rental_count,
        ROW_NUMBER() OVER (PARTITION BY c.city_id ORDER BY COUNT(*) DESC) AS ranking 
    FROM customer cu
    JOIN rental r ON cu.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN address a ON cu.address_id = a.address_id
    JOIN city c ON a.city_id = c.city_id
    GROUP BY c_id,city,film_title) as Ranked_rental where ranking =1 ;
    
              #or 
    SELECT c.city_id,c.city,f.title AS film_title,COUNT(*) AS rental_count
    FROM customer cu
    JOIN rental r ON cu.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN address a ON cu.address_id = a.address_id
    JOIN city c ON a.city_id = c.city_id
    GROUP BY c.city_id,c.city ,film_title having rental_count>1 order by rental_count desc;
  
		#just for study purpose
	SELECT c.city_id,c.city,f.title AS film_title,COUNT(*) AS rental_count
    FROM customer cu
    JOIN rental r ON cu.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN address a ON cu.address_id = a.address_id
    JOIN city c ON a.city_id = c.city_id where c.city_id = 285
    GROUP BY c.city_id,c.city ,film_title order by rental_count desc;
    
# 13.What is the total amount spent by customers whose rental payments exceed $200? 
SELECT c.customer_id,concat(c.first_name," ",c.last_name) as fill_name,SUM(p.amount) AS total_amount_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
having total_amount_spent > 200;

# 14.Create a View for the total revenue generated by each staff member, broken down by store city with the country name
create view totrev_staff as
select s.staff_id,s.first_name,s.last_name,sum(p.amount),co.country,ci.city from staff s
join payment p on s.staff_id = p.staff_id
join address a on s.address_id = a.address_id
join city ci on ci.city_id = a.city_id
join country co on ci.country_id = co.country_id 
group by  s.staff_id;

select * from totrev_staff;

alter view totrev_staff as
select s.staff_id,s.first_name,s.last_name,sum(p.amount),co.country,ci.city from staff s
join payment p on s.staff_id = p.staff_id
join address a on s.address_id = a.address_id
join city ci on ci.city_id = a.city_id
join country co on ci.country_id = co.country_id 
group by  s.staff_id,s.first_name,s.last_name;

select * from totrev_staff;
Drop view totrev_staff;

-- 15.	Create a view based on rental information consisting of visiting_day, customer_name, the title of the film,
--   no_of_rental_days, the amount paid by the customer along with the percentage of customer spending.
SELECT
    DATE(r.rental_date) AS visiting_day,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    f.title AS film_title,
    DATEDIFF(r.return_date, r.rental_date) AS no_of_rental_days,
    p.amount AS amount_paid,
    (p.amount / (SELECT SUM(amount) FROM payment WHERE p.customer_id = c.customer_id)) * 100 AS percentage_spending
FROM
    rental r
JOIN
    customer c ON r.customer_id = c.customer_id
JOIN
    inventory i ON r.inventory_id = i.inventory_id
JOIN
    film f ON i.film_id = f.film_id
JOIN
    payment p ON r.rental_id = p.rental_id;

#not working. Try it later
# 16.	Display the customers who paid 50% of their total rental costs within one day.
SELECT
    DATE(r.rental_date) AS visiting_day,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    f.title AS film_title,
    DATEDIFF(r.return_date, r.rental_date) AS no_of_rental_days,
    p.amount AS amount_paid,
    (p.amount / (SELECT SUM(amount) FROM payment WHERE p.customer_id = c.customer_id)) * 100 AS percentage_spending
FROM
    rental r
JOIN
    customer c ON r.customer_id = c.customer_id
JOIN
    inventory i ON r.inventory_id = i.inventory_id
JOIN
    film f ON i.film_id = f.film_id
JOIN
    payment p ON r.rental_id = p.rental_id
HAVING
    percentage_spending >= 0.5
    AND no_of_rental_days <= 1;
       #or
       
 #This query is used to reduce lost connection and reduce running time      
SELECT c.customer_id,
    DATE(r.rental_date) AS visiting_day,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    f.title AS film_title,
    DATEDIFF(r.return_date, r.rental_date) AS no_of_rental_days,
    p.amount AS amount_paid,
    (p.amount / total_spending.total_amount) * 100 AS percentage_spending
FROM
    rental r
JOIN
    customer c ON r.customer_id = c.customer_id
JOIN
    inventory i ON r.inventory_id = i.inventory_id
JOIN
    film f ON i.film_id = f.film_id
JOIN
    payment p ON r.rental_id = p.rental_id
JOIN
    (SELECT customer_id, SUM(amount) AS total_amount 
     FROM payment 
     GROUP BY customer_id) AS total_spending 
     ON c.customer_id = total_spending.customer_id
HAVING
    percentage_spending >= 0.5
    AND no_of_rental_days <= 1;
    
    
#fix incompatible with sql_mode=only_full_group_by
SET sql_mode = '';
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
  
#redo old setting  
set sql_mode ='ONLY_FULL_GROUP_BY';