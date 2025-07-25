🗃️ Database Setup
This project includes two structured SQL files that allow easy setup, initialization, and testing of the Banking Management System database.

📁 1. Project Database.sql
This file contains all the SQL CREATE statements required to initialize the complete database schema. It must be executed in sequence to ensure proper creation of tables, relationships, and constraints.

✅ Key Tables Created:

CUSTOMER

BRANCH

EMPLOYEE

ACCOUNT

TRANSACTION

LOAN

REPAYMENT

SERVICE

ACCOUNT_CARD

TRANSFERS

COMPLAIN

LOAN_DISTRIBUTION

Each table includes primary keys, foreign keys, and data integrity constraints to reflect a real-world relational model for a banking system.

📁 2. Insertion and Execution.sql
This file contains a collection of SQL INSERT statements used to populate the database with sample data for testing and demonstration purposes. These queries should also be run in sequence, after executing the Project Database.sql file.

✅ Purpose:

Insert test records into each table

Simulate customer activity, transactions, complaints, and loan distributions

Validate database relationships and constraints

Useful for demoing front-end/backend connectivity or running SQL test cases

⚙️ How to Use
Open your preferred SQL client (e.g., MySQL Workbench, phpMyAdmin, SSMS).

Run Project Database.sql to create the schema.

Then run Insertion and Execution.sql to insert sample data.

Begin executing queries or connecting to your application logic.

💾 Notes
Ensure foreign key checks are enabled if you're running these scripts in environments like MySQL.

Use transactions or rollback features if you're testing and want to reset the state easily.

Scripts are well-ordered and free of errors, assuming sequential execution.

 💾 Author:
    Name: Muhammad Uneeb Khan
