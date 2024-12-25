# Data_Mart_DWH

## Project Overview

Imagine you work at a company building a marketplace app for exclusive, handcrafted products. Artisans (craftsmen) post their items on several different websites—each with its own backend and database model. Your company acquires these websites but keeps their original domains, so masters (vendors) still upload products there, and customers continue to make purchases.

Your task is to set up a **corporate data warehouse (DWH)** that consolidates data from **three different sources** and then build a **final data mart** to provide key sales statistics.

This project demonstrates how to:

* Create source tables (for 3 different incoming data schemas).
* Build DWH tables and data mart tables (for analytics).
* Perform incremental loading of data from the sources into the DWH and from the DWH into the final data mart.
* Validate the end-to-end flow by simulating new orders and watching them appear in the final reporting layer.

## Repository Structure

* **Data sources/**

  Contains CSV files used to populate the three source databases (source1, source2, source3).

* **Sourses_tables/**

  SQL scripts to create the tables in each of the three source schemas.

* **Showcase_tables/**

  SQL scripts to create both the DWH tables and the final data mart (reporting) tables.

* **1_test_datamart.sql**

  A script to test the data mart updates. It inserts a new order and product into one of the sources, so you can check incremental loading afterward.

* **2_dwh_fill.sql**

  Fills (or updates) the DWH tables incrementally from the three sources.

* **3_datamart_fill.sql**

  Fills (or updates) the final data mart tables from the DWH tables.

* **docker-compose.yml**

  Defines a PostgreSQL service where all schemas (sources, DWH, data mart) reside.

* **README.md**

  This file—provides instructions and an overview of how to set up and run everything.

## Prerequisites

* [Docker](https://www.docker.com/products/docker-desktop/) installed on your machine.
* A SQL client such as [DBeaver](https://dbeaver.io/), if you want to manually inspect or manipulate the database.

## How to Run

**1. Clone the Repository**

        git clone https://github.com/cho-nado/Data_Mart_DWH.git

        cd Data_Mart_DWH

**2. Start the Docker Container**

  From within the project folder, run:

      docker compose up -d

  This spins up a PostgreSQL database in a container. By default, it will listen on port 5434 on your local machine (mapped to the container’s 5432). 5434 was chosen just because you can have some conflicts if you already have installed PosgreSQL locally. 

**3. Connect to the Database (Optional)**
* In DBeaver (or your preferred SQL client), create a new connection.
* Host: localhost
* Port: 5434
* Database name: demo_db
* Username: user_demo
* Password: pg_strong_password

**4. Create Source Tables & Populate with Data**
* Run the scripts from Sourses_tables to create the source tables in source1, source2, and source3.
* Import the CSV files from Data sources into those newly created tables.

**5. Create DWH and Data Mart Tables**
* Run the scripts in Showcase_tables to create the DWH schema (tables) and the data mart schema (reporting tables).

**6. Fill the DWH**
* Execute 2_dwh_fill.sql.

  This script performs an incremental (upsert) load from the source schemas into the DWH tables (d_craftsmans, d_customers, d_products, f_orders).

  * You can run it multiple times without duplicating data, thanks to INSERT ... ON CONFLICT.
 
**7. Fill the Data Mart**
* Execute 3_datamart_fill.sql.

  This aggregates the DWH data into the final reporting table craftsman_report_datamart.

  * Also uses ON CONFLICT to insert new rows or update existing ones (by craftsman_id and report_period).
 
## Testing Incremental Loads

**1. Simulate a New Order**
* Run 1_test_datamart.sql. This script inserts a new product and a new order into one of the sources (for example, source3). It also updates an existing entry in source1.craft_market_wide to demonstrate how order statuses and prices can change.

**2. Reload DWH & Data Mart**
* Re-run 2_dwh_fill.sql and then 3_datamart_fill.sql.
* Check that the new or modified records are incrementally updated in the DWH tables and in the craftsman_report_datamart.

**3. Verification**
* In 1_test_datamart.sql, there are commented queries at the bottom that let you confirm:

  1. The new craftsman_id or order_id is reflected in dwh.d_craftsmans / dwh.f_orders.
  2. The final metrics in dwh.craftsman_report_datamart match your expectations.
 
## Why This Project is Interesting
* **Realistic scenario**: Multiple legacy e-commerce sites acquired under one umbrella.
* **Incremental data loading**: Combines data from multiple sources without overwriting everything on each run.
* **Data warehousing**: Demonstrates best practices for building dimension tables (d_) and fact tables (f_).
* **Reporting**: Shows how to create a final data mart to calculate aggregated KPIs such as total orders, average product price, median completion time, and revenue split between craftsman and the marketplace.

This approach can be extended to many real-world integrations: you combine multiple source systems into a single corporate repository, preserving logic with upserts, and then build analytics on top.

