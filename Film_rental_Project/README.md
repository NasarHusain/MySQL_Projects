# Film Rental Store Database

## Overview

This repository contains the schema and data for a film rental store database. The database is designed to manage film rentals, customers, staff, and other related entities. The ER (Entity-Relationship) diagram below outlines the relationships between the different tables in the database.

## ER Diagram

### Description of the ER Diagram:

- **Actor**: Contains information about actors, including the films they have appeared in.
- **Film**: Contains details about films available for rental.
- **Film_Actor**: Links actors to the films they have appeared in.
- **Language**: Contains the languages available for films.
- **Category**: Contains the categories of films.
- **Film_Category**: Links films to their respective categories.
- **Customer**: Contains information about customers who rent films.
- **Address**: Contains address information for customers and stores.
- **City**: Contains city information, linked to addresses.
- **Country**: Contains country information, linked to cities.
- **Store**: Contains information about the stores, including staff.
- **Staff**: Contains information about staff members.
- **Rental**: Tracks film rentals, including dates and the customer renting the film.
- **Payment**: Tracks payments made by customers for rentals.

## Tables and Their Structures

### Actor

- **actor_id**: Unique identifier for the actor.
- **first_name**: Actor's first name.
- **last_name**: Actor's last name.

### Film_Actor

- **actor_id**: Foreign key linking to the Actor table.
- **film_id**: Foreign key linking to the Film table.

### Language

- **language_id**: Unique identifier for the language.
- **name**: Name of the language.

### Film_Category

- **film_id**: Foreign key linking to the Film table.
- **category_id**: Foreign key linking to the Category table.

### Film

- **film_id**: Unique identifier for the film.
- **title**: Title of the film.
- **description**: Description of the film.
- **language_id**: Foreign key linking to the Language table.
- **rental_duration**: Duration for which the film can be rented.
- **rental_rate**: Rate at which the film is rented.
- **length**: Length of the film.
- **replacement_cost**: Cost to replace the film.
- **rating**: Rating of the film.

### Staff

- **staff_id**: Unique identifier for the staff member.
- **first_name**: Staff member's first name.
- **last_name**: Staff member's last name.
- **address_id**: Foreign key linking to the Address table.
- **email**: Staff member's email address.
- **store_id**: Foreign key linking to the Store table.

### Category

- **category_id**: Unique identifier for the category.
- **name**: Name of the category.

### Country

- **country_id**: Unique identifier for the country.
- **country**: Name of the country.

### Customer

- **customer_id**: Unique identifier for the customer.
- **store_id**: Foreign key linking to the Store table.
- **first_name**: Customer's first name.
- **last_name**: Customer's last name.
- **email**: Customer's email address.
- **address_id**: Foreign key linking to the Address table.

### Address

- **address_id**: Unique identifier for the address.
- **district**: District of the address.
- **city_id**: Foreign key linking to the City table.
- **postal_code**: Postal code of the address.
- **phone**: Phone number associated with the address.
- **location**: Location details.

### City

- **city_id**: Unique identifier for the city.
- **city**: Name of the city.
- **country_id**: Foreign key linking to the Country table.

### Store

- **store_id**: Unique identifier for the store.
- **manager_staff_id**: Foreign key linking to the Staff table.
- **address_id**: Foreign key linking to the Address table.

### Rental

- **rental_id**: Unique identifier for the rental.
- **rental_date**: Date the rental was made.
- **inventory_id**: Identifier for the rented item.
- **customer_id**: Foreign key linking to the Customer table.
- **return_date**: Date the rental was returned.
- **staff_id**: Foreign key linking to the Staff table.

### Payment

- **payment_id**: Unique identifier for the payment.
- **customer_id**: Foreign key linking to the Customer table.
- **staff_id**: Foreign key linking to the Staff table.
- **rental_id**: Foreign key linking to the Rental table.
- **amount**: Amount paid by the customer.
- **payment_date**: Date the payment was made.

## Instructions

### Step 1: Create the Tables

To create the tables in the database, run the `schema.sql` script provided.

### Step 2: Populate the Tables

After creating the tables, populate them by running the `data.sql` script provided.

## Queries Overview

### 1. Total Revenue Generated from All Rentals

Calculate the total revenue generated by summing up all the payments made by customers for film rentals.

### 2. Number of Rentals Made in Each Month

Count the number of rentals made in each month, grouped by the month name.

### 3. Rental Rate of the Film with the Longest Title

Identify the film with the longest title and find out its rental rate.

### 4. Average Rental Rate for Films Rented in the Last 30 Days from 2005-05-05

Calculate the average rental rate for films that were rented within the 30 days leading up to May 5, 2005.

### 5. Most Popular Film Category by Number of Rentals

Determine the most popular film category by counting the number of rentals for each category and identifying the one with the highest count.

### 6. Longest Movie Duration Not Rented by Any Customer

Find the longest film duration among films that have never been rented by any customer.

### 7. Average Rental Rate by Film Category

Calculate the average rental rate for films, grouped by their respective categories.

### 8. Total Revenue Generated from Rentals for Each Actor

Calculate the total revenue generated from rentals for each actor by summing up the payments for films they appeared in.

### 9. Actresses in Films with "Wrestler" in the Description

List all actresses who have worked in films that have the word "Wrestler" in their description.

### 10. Customers Who Rented the Same Film More Than Once

Identify customers who have rented the same film more than once by counting the instances for each customer and film combination.

### 11. Number of Comedy Films with a Rental Rate Higher than the Average

Count the number of comedy films that have a rental rate higher than the average rental rate across all films.

### 12. Most Rented Films by Customers in Each City

For each city, determine the film that has been rented the most by customers living in that city.

### 13. Total Amount Spent by Customers Whose Rental Payments Exceed $200

Calculate the total amount spent by customers whose individual rental payments exceed $200.

### 14. Foreign Key Constraints Related to the "Rental" Table

Display all fields that have foreign key constraints related to the "rental" table.

### 15. View for Total Revenue Generated by Each Staff Member by Store City and Country

Create a view that shows the total revenue generated by each staff member, broken down by the store's city and the country.

### 16. View for Rental Information Including Customer Spending Percentage

Create a view that displays rental information, including the day of the visit, customer name, film title, number of rental days, amount paid by the customer, and the percentage of total customer spending.

### 17. Customers Who Paid 50% of Their Total Rental Costs Within One Day

Display customers who paid 50% of their total rental costs within a single day.
