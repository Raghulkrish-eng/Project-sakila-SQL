use sakila;

SELECT 
    f.film_id,
    f.title,
    f.release_year,
    f.rental_rate,
    f.length,
    f.rating,
    f.special_features,
    GROUP_CONCAT(DISTINCT a.first_name, ' ', a.last_name) AS actors,
    c.name AS category,
    l.name AS language,
    SUM(p.amount) AS total_revenue,
    COUNT(r.rental_id) AS total_rentals
FROM 
    film f
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
JOIN 
    film_text ft ON f.film_id = ft.film_id
JOIN 
    language l ON f.language_id = l.language_id
LEFT JOIN 
    inventory i ON f.film_id = i.film_id
LEFT JOIN 
    rental r ON i.inventory_id = r.inventory_id
LEFT JOIN 
    payment p ON r.rental_id = p.rental_id
LEFT JOIN 
    film_actor fa ON f.film_id = fa.film_id
LEFT JOIN 
    actor a ON fa.actor_id = a.actor_id
WHERE 
    f.title IS NOT NULL 
    AND l.name IS NOT NULL 
    AND c.name IS NOT NULL 
    AND p.amount IS NOT NULL
GROUP BY 
    f.film_id, f.title, f.release_year, f.rental_rate, f.length, f.rating, f.special_features, c.name, l.name
ORDER BY 
    total_revenue DESC;

# 1,Customer Activity Analysis
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_rentals, SUM(p.amount) AS total_spent
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id;

# 2,Top-Rented Movies Analysis
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 10;

# 3,Revenue Analysis by Store
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM store s
JOIN inventory i ON s.store_id = i.store_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.store_id;

# 4,Movie Genre Popularity Analysis
SELECT c.name AS genre, COUNT(r.rental_id) AS rental_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY rental_count DESC;

# 5,Customer Demographics Analysis
SELECT ci.city, COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY ci.city
ORDER BY rental_count DESC;

# 6,Staff Performance Analysis
SELECT s.first_name, s.last_name, COUNT(r.rental_id) AS total_rentals, SUM(p.amount) AS total_revenue
FROM staff s
JOIN rental r ON s.staff_id = r.staff_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.staff_id
ORDER BY total_revenue DESC;

# 7,Inventory Turnover Analysis
SELECT i.inventory_id, f.title, COUNT(r.rental_id) AS total_rentals
FROM inventory i
JOIN film f ON i.film_id = f.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY i.inventory_id
ORDER BY total_rentals DESC;

# 8,Late Returns Analysis
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS late_returns
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
WHERE r.return_date > r.rental_date
GROUP BY c.customer_id
ORDER BY late_returns DESC;

# 9,Movie Availability and Stock Management
SELECT f.title, COUNT(i.inventory_id) AS available_copies
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id AND r.return_date IS NULL
WHERE r.rental_id IS NULL
GROUP BY f.title
ORDER BY available_copies ASC;

# 10,Most Profitable Movies
SELECT f.title, SUM(p.amount) AS total_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.title
ORDER BY total_revenue DESC;

# 11,Rental Duration Analysis
SELECT f.title, AVG(DATEDIFF(r.return_date, r.rental_date)) AS avg_rental_duration
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
GROUP BY f.title
ORDER BY avg_rental_duration DESC;

# 12,Customer Loyalty and Retention
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_rentals, SUM(p.amount) AS total_spent
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id
HAVING total_rentals > 10
ORDER BY total_spent DESC;

# 13,Movie Release Year and Popularity
SELECT f.release_year, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.release_year
ORDER BY rental_count DESC;

# 14,Store Performance by City Store Performance by City
SELECT ci.city, COUNT(r.rental_id) AS rental_count, SUM(p.amount) AS total_revenue
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN inventory i ON s.store_id = i.store_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY ci.city
ORDER BY total_revenue DESC;

# 15,Staff Sales Performance
SELECT s.first_name, s.last_name, SUM(p.amount) AS total_revenue
FROM staff s
JOIN rental r ON s.staff_id = r.staff_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.staff_id
ORDER BY total_revenue DESC;

# 16,Seasonal Rental Trends
SELECT MONTH(r.rental_date) AS rental_month, COUNT(r.rental_id) AS rental_count
FROM rental r
GROUP BY rental_month
ORDER BY rental_count DESC;

# 17,Film Length vs Popularity
SELECT f.title, f.length, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY rental_count DESC;

# 18,Customer Segmentation Analysis
SELECT c.customer_id, c.first_name, c.last_name,
       CASE
         WHEN COUNT(r.rental_id) >= 50 THEN 'Platinum'
         WHEN COUNT(r.rental_id) >= 20 THEN 'Gold'
         ELSE 'Silver'
       END AS customer_segment
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

# 19,Film Genre Revenue Analysis
SELECT c.name AS genre, SUM(p.amount) AS total_revenue
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY total_revenue DESC;

# 20, Customer Churn Analysis
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
WHERE r.rental_date IS NULL
OR r.rental_date < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

# 21, Rental Price Optimization
SELECT f.title, f.rental_rate, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title, f.rental_rate
ORDER BY rental_count DESC;

# 22,Film Age vs Rental Frequency
SELECT f.title, f.release_year, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title, f.release_year
ORDER BY rental_count DESC;

# 23,Profitability by Rental Duration
SELECT f.title, DATEDIFF(r.return_date, r.rental_date) AS rental_duration, SUM(p.amount) AS total_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.title, DATEDIFF(r.return_date, r.rental_date)
ORDER BY total_revenue DESC;

# 24,Movie Popularity Based on Actor Performance
SELECT a.first_name, a.last_name, COUNT(r.rental_id) AS rental_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY a.actor_id
ORDER BY rental_count DESC;

# 25,Staff Efficiency in Handling Rentals
SELECT s.first_name, s.last_name, AVG(DATEDIFF(r.return_date, r.rental_date)) AS avg_rental_time
FROM staff s
JOIN rental r ON s.staff_id = r.staff_id
GROUP BY s.staff_id
ORDER BY avg_rental_time ASC;

# 26, Lost or Damaged Movie Analysis
SELECT f.title, COUNT(r.rental_id) AS lost_or_damaged
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NULL
GROUP BY f.title
ORDER BY lost_or_damaged DESC;

# 27,Geographical Distribution of Rentals
SELECT ci.city, COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY ci.city
ORDER BY rental_count DESC;

# 28,Promotions Impact on Rental Activity
SELECT c.customer_id, SUM(p.amount) AS total_spent, COUNT(r.rental_id) AS total_rentals
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN payment p ON r.rental_id = p.rental_id
WHERE p.amount < f.rental_rate 
GROUP BY c.customer_id
ORDER BY total_spent DESC;

# 29,Category-Specific Trends
SELECT c.name AS genre, YEAR(r.rental_date) AS year, COUNT(r.rental_id) AS rental_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name, year
ORDER BY year DESC, rental_count DESC;


# 30,Customer Retention Rate
SELECT YEAR(r.rental_date) AS rental_year, COUNT(DISTINCT r.customer_id) AS retained_customers
FROM rental r
GROUP BY rental_year
ORDER BY rental_year;
    
# 31,Average Rental Price Over Time
SELECT YEAR(r.rental_date) AS rental_year, AVG(f.rental_rate) AS average_rental_price
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY rental_year
ORDER BY rental_year;

# 32,Monthly Revenue Trends
SELECT MONTH(r.rental_date) AS rental_month, SUM(p.amount) AS total_revenue
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY rental_month
ORDER BY rental_month;

# 33,Top Customers by Spending
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 10;

# 34,Film Availability by Category
SELECT c.name AS category, COUNT(i.inventory_id) AS available_films
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN  film f ON fc.film_id = f.film_id
LEFT JOIN  inventory i ON f.film_id = i.film_id
GROUP BY  c.name
ORDER BY available_films DESC;

# 35,Revenue by Genre
SELECT c.name AS genre, SUM(p.amount) AS total_revenue
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY genre
ORDER BY total_revenue DESC;

# 36,Staff Performance Based on Rentals
SELECT s.staff_id, s.first_name, s.last_name, COUNT(r.rental_id) AS rentals_processed
FROM staff s
JOIN rental r ON s.staff_id = r.staff_id
GROUP BY s.staff_id
ORDER BY rentals_processed DESC;

# 37,Rental Duration vs. Revenue
SELECT DATEDIFF(r.return_date, r.rental_date) AS rental_duration, SUM(p.amount) AS total_revenue
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
WHERE r.return_date IS NOT NULL
GROUP BY rental_duration
ORDER BY rental_duration;

# 38,Impact of New Releases on Rentals
SELECT f.release_year, COUNT(r.rental_id) AS rentals_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.release_year
ORDER BY f.release_year;