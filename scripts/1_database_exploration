/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- Retrieve the list of tables in the database (DataWareHouse)
select * from INFORMATION_SCHEMA.TABLES
where TABLE_CATALOG = 'DataWareHouse'

-- Retrieve all columns for a specific table (crm_cust_info)
select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'crm_cust_info'
