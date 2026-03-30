-- 1. Which staff members are assigned to each store, along with their contact details?
SELECT 
	first_name,
    last_name,
    email,
    store_id
FROM staff;

-- 2. How many inventory items are currently held in each store?
SELECT
	store_id,
    COUNT(inventory_id) AS inventory_items
FROM inventory
GROUP BY 
	store_id;

-- 3. How many active customers does each store currently serve?
SELECT
	store_id,
    COUNT(customer_id) AS active_customers
FROM customer
WHERE active = 1
GROUP BY 
	store_id;

-- 4. How many customer email addresses are available in the database?
SELECT
	COUNT(email) AS emails_count
FROM customer;

-- 5. How many distinct film titles are stocked in each store?
SELECT
    store_id,
    COUNT(DISTINCT film_id) AS unique_titles
FROM inventory
GROUP BY 
	store_id;

-- 6. How many unique film categories are represented in the catalog?
SELECT
	COUNT(DISTINCT category_id) as unique_categories
FROM film_category;

-- 7. What are the minimum, maximum, and average replacement costs across all films?
SELECT 
	MIN(replacement_cost) AS least_expensive_film,
    MAX(replacement_cost) AS most_expensive_film,
    AVG(replacement_cost) AS average_film_cost
FROM film;

-- 8. What are the average and highest payment amounts recorded from customers?
SELECT
	AVG(amount) AS average_payment,
    MAX(amount) AS maximum_payment
FROM payment;

-- 9. How many rentals has each customer completed?
SELECT
	customer_id,
    COUNT(rental_id) AS number_of_rentals
FROM rental
GROUP BY 
	customer_id
ORDER BY 
	COUNT(rental_id) DESC;

use mavenmovies;

-- 10. Who manages each store and where is each store located?
SELECT
	s.store_id,
    m.first_name,
    m.last_name,
    a.address,
    a.district,
    c.city,
    co.country
FROM store s
LEFT JOIN staff m 
	ON s.manager_staff_id = m.staff_id
LEFT JOIN address a 
	ON s.address_id = a.address_id
LEFT JOIN city c 
	ON a.city_id = c.city_id
LEFT JOIN country co 
	ON c.country_id = co.country_id;

-- 11. Which inventory items are available in each store and what are their key film attributes?
SELECT 
	i.inventory_id,
    i.store_id,
    f.title,
    f.rating,
    f.rental_rate,
    f.replacement_cost
FROM inventory i
LEFT JOIN film f
	ON i.film_id = f.film_id
ORDER BY 
	i.inventory_id;

-- 12. How is store inventory distributed by film rating?
SELECT 
	i.store_id,
    f.rating,
    COUNT(i.inventory_id) AS number_of_items
FROM inventory i
LEFT JOIN film f 
	ON i.film_id = f.film_id
GROUP BY 
	i.store_id,
    f.rating;

-- 13. What is the inventory volume and replacement cost exposure by category in each store?
SELECT
	i.store_id,
    c.name AS category,
    COUNT(i.inventory_id) AS number_of_films,
    AVG(f.replacement_cost) AS averace_replacement_cost,
    SUM(f.replacement_cost) AS total_replacement_cost
FROM inventory i
LEFT JOIN film f
	ON i.film_id = f.film_id
LEFT JOIN film_category fc
	ON f.film_id = fc.film_id
LEFT JOIN category c
	ON fc.category_id = c.category_id
GROUP BY
	i.store_id,
    c.name
ORDER BY
	SUM(f.replacement_cost);

-- 14. Who are the customers, which store are they assigned to, and where are they located?
SELECT
	c.first_name,
    c.last_name,
    c.store_id,
    c.active,
    a.address,
    ci.city,
    co.country
FROM customer c
LEFT JOIN address a
	ON c.address_id = a.address_id
LEFT JOIN city ci
	ON a.city_id = ci.city_ID
LEFT JOIN country co
	ON ci.country_id = co.country_id;

-- 15. Which customers generate the highest rental activity and payment value?
SELECT
	c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_rentals,
    SUM(p.amount) AS total_payment_amount
FROM customer c
LEFT JOIN rental r
	ON c.customer_id = r.customer_id
LEFT JOIN payment p
	ON c.customer_id = p.customer_id
GROUP BY
	c.first_name,
    c.last_name
ORDER BY
	SUM(p.amount) DESC;

-- 16. What is the full list of advisors and investors in a single combined view?
SELECT
	first_name,
    last_name,
    'investor' as type,
    company_name
FROM investor
UNION
SELECT
	first_name,
    last_name,
    'advisor' as type,
    NULL as company_name
FROM advisor;

-- 17. How does film participation vary across actors with different award profiles?
SELECT
	CASE
		WHEN actor_award.awards ='Emmy, Oscar, Tony ' THEN '3 awards'
		WHEN actor_award.awards IN ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
        ELSE '1 award'
	END AS 'number_of_awards',
    AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film
FROM actor_award
GROUP BY
	CASE
		WHEN actor_award.awards ='Emmy, Oscar, Tony ' THEN '3 awards'
		WHEN actor_award.awards IN ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
        ELSE '1 award'
	END;

-- 18. Which films in inventory have never been rented out?
SELECT
	i.film_id,
    f.title,
    COUNT(r.inventory_id) AS rented_copies,
    f.replacement_cost
FROM inventory i
LEFT JOIN rental r 
	ON i.inventory_id =r.inventory_id
LEFT JOIN film f
	ON i.film_id = f.film_id
WHERE r.rental_id IS NULL
GROUP BY 
	i.film_id
ORDER BY 
	f.replacement_cost DESC;

-- 19. Which films achieve the highest rental frequency relative to the number of copies available?
SELECT
	f.film_id,
	COUNT(i.inventory_id) AS copies,
	COUNT(r.rental_id) AS number_of_rentals,
    COUNT(r.rental_id)/COUNT(i.inventory_id) AS pct_of_rentals
FROM film f
LEFT JOIN inventory i
	ON f.film_id = i.film_id
LEFT JOIN rental r
	ON i.inventory_id = r.inventory_id
GROUP BY 
	f.film_id
HAVING
	COUNT(i.inventory_id) >3
ORDER BY 
	COUNT(r.rental_id)/COUNT(i.inventory_id) DESC;

-- 20. Which film categories generate the most revenue and rental activity?
SELECT
	c.name AS category,
	SUM(p.amount) AS total_revenue,
	COUNT(r.rental_id) AS number_of_rentals
FROM category c
LEFT JOIN film_category fc
	ON c.category_id = fc.category_id
LEFT JOIN inventory i
	ON fc.film_id = i.film_id
LEFT JOIN rental r
	ON i.inventory_id = r.inventory_id
LEFT JOIN payment p
	ON r.rental_id = p.rental_id
GROUP BY 
	c.name
ORDER BY
	SUM(p.amount) DESC,
	COUNT(r.rental_id) DESC ;

-- 21. How do film categories perform by rating in terms of revenue and rental volume?
SELECT
	f.rating,
    c.name AS category,
	SUM(p.amount) AS total_revenue,
	COUNT(r.rental_id) AS number_of_rentals
FROM film f
LEFT JOIN film_category fc
	ON f.film_id = fc.film_id
LEFT JOIN category c
	ON fc.category_id = c.category_id
LEFT JOIN inventory i
	ON fc.film_id = i.film_id
LEFT JOIN rental r
	ON i.inventory_id = r.inventory_id
LEFT JOIN payment p
	ON r.rental_id = p.rental_id
GROUP BY 
	f.rating,
	c.name
ORDER BY 
	rating;

-- 22. Do films featuring Deleted Scenes drive more rentals and revenue than those without?
SELECT 
	CASE
    WHEN f.special_features LIKE '%Deleted Scenes%' THEN 'Group1'
    ELSE 'Group2'
    END AS 'Group',
    COUNT(DISTINCT f.film_id) AS total_films,
    COUNT(DISTINCT r.rental_id) AS total_rentals,
    SUM(p.amount) AS total_revenue
FROM film f
LEFT JOIN inventory i
	ON f.film_id = i.film_id
LEFT JOIN rental r
	ON i.inventory_id = r.rental_id
LEFT JOIN payment p
	ON r.rental_id = p.rental_id
GROUP BY
	CASE
    WHEN f.special_features LIKE '%Deleted Scenes%' THEN 'Group1'
    ELSE 'Group2'
    END
ORDER BY 
	COUNT(DISTINCT f.film_id) DESC;

-- 23. How do documentary-style films perform in terms of rentals and revenue?
SELECT
	f.title AS documentary_title,
    COUNT(r.rental_id) AS rentals,
    SUM(p.amount) AS revenue
FROM film f
LEFT JOIN inventory i
	ON f.film_id = i.film_id
LEFT JOIN rental r
	ON i.inventory_id = r.rental_id
LEFT JOIN payment p
	ON r.rental_id = p.rental_id
WHERE f.description LIKE "%documentary of a%"
GROUP BY 
	f.title
ORDER BY 
	 COUNT(rental_id) DESC;

-- 24. Which actors are associated with the highest revenue and the largest number of films?
SELECT
	a.first_name,
    a.last_name,
    SUM(p.amount) AS revenue,
    COUNT(DISTINCT f.film_id) AS total_films
FROM actor a LEFT JOIN film_actor fa
	ON a.actor_id = fa.actor_id
LEFT JOIN film f
	ON fa.film_id = f.film_id
LEFT JOIN inventory i
	ON f.film_id = i.film_id
LEFT JOIN rental r
	ON i.inventory_id = r.rental_id
LEFT JOIN payment p
	ON r.rental_id = p.rental_id
GROUP BY
	a.actor_id
ORDER BY
	SUM(p.amount) DESC
LIMIT 20;

-- 25. Which customers generate the highest revenue within each store?
WITH customer_totals AS (
SELECT
	s.store_id,
    c.customer_id,
    CONCAT(c.first_name, " ", c.last_name) AS full_name,
    SUM(p.amount) AS total_paid
FROM payment p
LEFT JOIN customer c
ON p.customer_id = c.customer_id
LEFT JOIN staff s
ON p.staff_id = s.staff_id
GROUP BY
	s.store_id,
    c.customer_id,
    CONCAT(c.first_name, " ", c.last_name)
),
customer_ranking AS(SELECT 
	ct.store_id,
    ct.customer_id,
    ct.full_name,
    ct.total_paid,
    row_number() over(partition by ct.store_id order by ct.total_paid DESC, ct.customer_id ASC) AS ranking
FROM customer_totals ct)
SELECT
	cr.store_id,
    cr.customer_id,
    cr.full_name,
    cr.total_paid,
    cr.ranking
FROM customer_ranking cr
WHERE cr.ranking <=5
ORDER BY 
	cr.store_id, cr.ranking;

-- 26. Which films are rented most frequently within each category?
WITH film_rentals AS (
	SELECT 
		c.name AS category_name,
		f.title AS film_title,
		COUNT(r.rental_id) AS rental_count
	FROM category c
	JOIN film_category fc
		ON c.category_id = fc.category_id
	JOIN film f
		ON fc.film_id = f.film_id
	JOIN inventory i 
		ON f.film_id = i.film_id
	JOIN rental r
		ON i.inventory_id = r.rental_id
	GROUP BY
		c.name,
		f.title
),
film_ranking AS (
	SELECT
		fr.category_name,
		fr.film_title,
		fr.rental_count,
		RANK() OVER(
			PARTITION BY fr.category_name 
            ORDER BY fr.rental_count DESC
            ) AS category_rank
	FROM film_rentals fr
)
SELECT
	r.category_name,
    r.film_title,
    r.rental_count,
    r.category_rank
FROM film_ranking r
WHERE r.category_rank <3
ORDER BY
	r.category_name,
    r.category_rank,
    r.film_title;

-- 27. How does each payment compare with the customer's previous payment?
WITH previous_payment AS (
	SELECT
		p.customer_id,
		p.payment_date,
		p.amount,
    LAG(p.amount) OVER(
		PARTITION BY p.customer_id
		ORDER BY p.payment_date
    ) AS previous_payment
FROM payment p
)
SELECT 
	customer_id,
    payment_date,
    amount,
    COALESCE(previous_payment,0),
    amount - COALESCE(previous_payment, 0) AS diffrence_from_previous
FROM previous_payment
ORDER BY
	customer_id,
    payment_date;

-- 28. What is the daily sales trend and cumulative revenue over time?
WITH daily_sales AS (
    SELECT
        DATE(payment_date) AS payment_day,
        SUM(amount) AS daily_amount
    FROM payment
    GROUP BY DATE(payment_date)
)
SELECT
    payment_day,
    ROUND(daily_amount, 2) AS daily_amount,
    ROUND(
        SUM(daily_amount) OVER (
            ORDER BY payment_day
        ),
        2
    ) AS running_total
FROM daily_sales
ORDER BY payment_day;

-- 29. How does each payment compare with the customer's average payment amount?
SELECT
	customer_id,
    payment_id,
    amount,
    ROUND(AVG(amount) OVER(
		PARTITION BY customer_id
        ),2) AS avg_payment_customer,
	amount - ROUND(AVG(amount) OVER(
		PARTITiON BY customer_id
        ),2) AS diffrence_from_avg
FROM payment
ORDER BY
	customer_id,
    payment_id;

-- 30. What percentage of total revenue is contributed by each film category?
WITH category_revenue AS (
	SELECT
		c.name AS category_name,
		SUM(p.amount) AS total_revenue
	FROM category c
    JOIN film_category fc
		ON c.category_id = fc.category_id
	JOIN inventory i
		ON fc.film_id = i.film_id
	JOIN rental r
		ON i.inventory_id = r.inventory_id
	JOIN payment p 
		ON r.rental_id = p.rental_id
	GROUP BY
		c.name
)
SELECT 
	cr.category_name,
    cr.total_revenue,
    ROUND(
		cr.total_revenue / (SELECT SUM(amount) from payment)*100 ,2
    ) AS percentage_of_total
FROM category_revenue cr
ORDER BY
	cr.total_revenue DESC;

-- 31. Which customers spend more than the overall average customer?
WITH customer_totals AS (
	SELECT
		customer_id,
		SUM(amount) AS total_paid
	FROM payment
	GROUP BY
		customer_id
)
SELECT
	customer_id,
    total_paid
FROM customer_totals
WHERE total_paid > (
	SELECT AVG(total_paid)
    FROM customer_totals)
ORDER BY total_paid DESC;

-- 32. Which films are the longest in the catalog and how do they rank by duration?
SELECT
	title AS film_title,
    length,
    RANK() OVER(ORDER BY length DESc) AS rank_length
FROM film;

-- 33. How much time passes between consecutive rentals for each customer?
WITH next_rentals AS (
	SELECT
		customer_id,
		rental_date,
		LEAD(rental_date) OVER (
			PARTITION BY customer_id
            ORDER BY rental_date
		) AS next_rental_date
FROM rental
)
SELECT
	customer_id,
    rental_date,
    next_rental_date,
    DATEDIFF(next_rental_date, rental_date) AS days_to_next_rental
FROM next_rentals
ORDER BY
	customer_id,
    rental_date;

-- 34. Which film generates the highest revenue within each category?
WITH category_ranking AS (
	SELECT
		c.name AS category_name,
        f.title AS film_title,
        SUM(p.amount) AS revenue,
        ROW_NUMBER() OVER (
			PARTITION BY c.name
            ORDER BY SUM(p.amount) DESC
		) AS category_rank
	FROM category c
	JOIN film_category fc
		ON c.category_id = fc.category_id
	JOIN film f
		ON fc.film_id = f.film_id
	JOIN inventory i
		ON f.film_id = i.film_id
	JOIN rental r
		ON i.inventory_id = r.inventory_id
	JOIN payment p
		On r.rental_id = p.rental_id
	GROUP BY
		c.name,
        f.title
)
SELECT
	category_name,
    film_title,
    revenue
FROM category_ranking
WHERE category_rank = 1
ORDER BY
	category_name ASC;

-- 35. How does monthly revenue change over time, both in value and percentage terms?
WITH monthly_revenue AS (
	SELECT
		DATE_FORMAT(payment_date, '%Y-%m') AS month,
        ROUND(SUM(amount),2) AS revenue
	FROM payment
    GROUP BY
		DATE_FORMAT(payment_date, '%Y-%m')
),
previous_monthly_revenue AS (
	SELECT
		month,
        revenue,
        ROUND(LAG(revenue) OVER (
            ORDER BY month ASC
		),2) AS previous_month_revenue
	FROM monthly_revenue
)
SELECT
	month,
    revenue,
    previous_month_revenue,
    revenue - previous_month_revenue AS mom_diffrence,
    ROUND((revenue - previous_month_revenue) / previous_month_revenue * 100, 2) AS mom_percentage_change
FROM previous_monthly_revenue
ORDER BY 
	month ASC;