# Maven Movies SQL Analysis

This project presents a business-focused SQL analysis of the **Maven Movies** database.

The goal of the project was to explore relational data, answer practical business questions, and build a portfolio project that demonstrates core SQL skills used in data analysis.

The analysis covers customer behavior, store performance, inventory structure, rental activity, revenue generation, and time-based trends. The queries were written to simulate real business scenarios and show how raw transactional data can be transformed into useful insights.

## Business Questions
- Which staff members are assigned to each store, along with their contact details?
- How many inventory items are currently held in each store?
- How many active customers does each store currently serve?
- How many customer email addresses are available in the database?
- How many distinct film titles are stocked in each store?
- How many unique film categories are represented in the catalog?
- What are the minimum, maximum, and average replacement costs across all films?
- What are the average and highest payment amounts recorded from customers?
- How many rentals has each customer completed?
- Who manages each store and where is each store located?
- Which inventory items are available in each store and what are their key film attributes?
- How is store inventory distributed by film rating?
- What is the inventory volume and replacement cost exposure by category in each store?
- Who are the customers, which store are they assigned to, and where are they located?
- Which customers generate the highest rental activity and payment value?
- What is the full list of advisors and investors in a single combined view?
- How does film participation vary across actors with different award profiles?
- Which films in inventory have never been rented out?
- Which films achieve the highest rental frequency relative to the number of copies available?
- Which film categories generate the most revenue and rental activity?
- How do film categories perform by rating in terms of revenue and rental volume?
- Do films featuring Deleted Scenes drive more rentals and revenue than those without?
- How do documentary-style films perform in terms of rentals and revenue?
- Which actors are associated with the highest revenue and the largest number of films?
- Which customers generate the highest revenue within each store?
- Which films are rented most frequently within each category?
- How does each payment compare with the customer's previous payment?
- What is the daily sales trend and cumulative revenue over time?
- How does each payment compare with the customer's average payment amount?
- What percentage of total revenue is contributed by each film category?
- Which customers spend more than the overall average customer?
- Which films are the longest in the catalog and how do they rank by duration?
- How much time passes between consecutive rentals for each customer?
- Which film generates the highest revenue within each category?
- How does monthly revenue change over time, both in value and percentage terms?

## Skills Demonstrated
- `JOIN`
- `GROUP BY`
- aggregate functions
- `CASE WHEN`
- `CTE` (Common Table Expressions)
- window functions (`ROW_NUMBER`, `RANK`, `LAG`, `LEAD`)
- filtering with `WHERE` and `HAVING`
- trend and ranking analysis

## Dataset
Data used in this project comes from the **Maven Movies** dataset provided by **Maven Analytics**, commonly used for SQL practice and portfolio projects.

This repository contains my own SQL analysis, business questions, and query solutions.

## Project File
- `mavenmovies_analysis.sql` — full SQL script with business questions and analytical queries
