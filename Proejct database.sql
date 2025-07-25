CREATE DATABASE Banking_System;
USE Banking_System;

CREATE TABLE Branch(
Branch_ID INT PRIMARY KEY,
Branch_Name VARCHAR(50)
);

CREATE TABLE employee (               
    Employeeid INT PRIMARY KEY,
    Employeename VARCHAR(50),
	Branch_ID INT,
	Designation VARCHAR(50),
    FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID)
);

CREATE TABLE customers (
    Customerid INT PRIMARY KEY,
    Customername VARCHAR(100),
    DOB DATE,
    Address varchar(50),
    Phone VARCHAR(15),
    Email VARCHAR(100) UNIQUE
);


CREATE TABLE accounts(
    Accountid INT PRIMARY KEY,
    Customerid INT,
    Accounttype varchar(100),
    Branch_ID INT,
	Balance DECIMAL(12,2) DEFAULT 0.00,
    FOREIGN KEY (Customerid) REFERENCES customers (Customerid),
    FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID)
);

CREATE TABLE transactions(
    Transactionid  INT IDENTITY(24,1) PRIMARY KEY,
    Accountid INT,
    Transactiontype VARCHAR(100),
    Amount DECIMAL(12,2),
    transaction_date DATE,
    FOREIGN KEY (Accountid) REFERENCES accounts(Accountid)
);

CREATE TABLE transfers (
    Transferid INT IDENTITY(1,1)PRIMARY KEY,
    From_Accountid INT,
    To_Accountid INT,
    Amount DECIMAL(12,2),
    FOREIGN KEY (From_Accountid) REFERENCES accounts(Accountid),
    FOREIGN KEY (To_Accountid) REFERENCES accounts(Accountid)
);

CREATE TABLE loans (
    Loanid INT PRIMARY KEY,
    Customerid INT,
    Amount DECIMAL(12,2),
    Applydate DATE,
    FOREIGN KEY (Customerid) REFERENCES customers (Customerid),
);


CREATE TABLE Complain(
Complain_ID INT PRIMARY KEY,
Customerid INT,
Description VARCHAR(50),
FOREIGN KEY (Customerid) REFERENCES customers(Customerid)
);

CREATE TABLE LoanDistribution(
Distribution_Amount DECIMAL(15,3), 
Loanid INT
FOREIGN KEY (Loanid) REFERENCES loans
);

CREATE TABLE AccountCard(
Card_ID INT PRIMARY KEY,
Accountid INT,
Expiry_Date DATE,
Status VARCHAR(20),
FOREIGN KEY (Accountid) REFERENCES accounts
);

CREATE TABLE Repayment(
Repay_ID INT IDENTITY(601,1) PRIMARY KEY,
Loanid INT,
Amount DECIMAL(15,3)
FOREIGN KEY (Loanid) REFERENCES loans
);

CREATE TABLE Service(
Customerid INT,
Service_Type VARCHAR(50),
FOREIGN KEY (Customerid) REFERENCES customers(Customerid)
);

-------------------------------------view------------------------------------------------- 
--1. Customers Account Info
CREATE VIEW View_Customer_Accounts
AS
SELECT 
    customers.Customerid,
    customers.Customername,
    customers.Phone,
    customers.Email,
    accounts.Accountid,
    accounts.Accounttype,
    accounts.Balance,
    Branch.Branch_Name
FROM  customers 
JOIN accounts  ON customers.Customerid = accounts.Customerid
JOIN Branch  ON accounts.Branch_ID = Branch.Branch_ID;

--2. Transaction History
CREATE VIEW Transaction_History 
AS
SELECT 
    transactions.Transactionid,
    transactions.Accountid,
    customers.Customername,
    transactions.Transactiontype,
    transactions.Amount,
    transactions.transaction_date
FROM transactions 
JOIN accounts  ON transactions.Accountid = accounts.Accountid
JOIN customers  ON accounts.Customerid = customers.Customerid;

--3. View customer loans
CREATE VIEW View_Customer_Loans AS
SELECT 
    loans.Loanid,
    customers.Customername,
    loans.Amount ,
    loans.Applydate
FROM 
    loans 
INNER JOIN customers  ON loans.Customerid = customers.Customerid;

--4. Loan_Distribution
CREATE VIEW View_Loan_Distribution AS
SELECT 
    loans.Loanid,
    customers.Customername,
    loans.Amount AS Loan_Amount,
    LoanDistribution.Distribution_Amount
FROM LoanDistribution
JOIN loans  ON LoanDistribution.Loanid= loans.Loanid
JOIN customers ON loans.Customerid = customers.Customerid;
--------------------------------------
SELECT * FROM View_Loan_Distribution;
--------------------------------------

--------------------------------------
--5. View_Customer_Services
CREATE VIEW View_Customer_Services AS
SELECT 
    customers.Customerid,
    customers.Customername,
    Service.Service_Type
FROM 
    customers
JOIN Service ON customers.Customerid = Service.Customerid;
--------------------------------
--6. View_Account_Cards
CREATE VIEW View_Account_Cards AS
SELECT 
    AccountCard.Card_ID,
    accounts.Accountid,
    customers.Customername,
    AccountCard.Expiry_Date,
    AccountCard.Status
FROM 
    AccountCard
JOIN accounts ON AccountCard.Accountid = accounts.Accountid
JOIN customers ON accounts.Customerid = customers.Customerid;


--7. View_Customer_Services
CREATE VIEW View_Customer_Services AS
SELECT 
    customers.Customerid,
    customers.Customername,
    Service.Service_Type
FROM 
    customers
JOIN Service ON customers.Customerid = Service.Customerid;  

--8. Customer_Complaints
CREATE VIEW View_Customer_Complaints AS
SELECT 
    Complain.Complain_ID,
    customers.Customername,
    Complain.Description
FROM 
    Complain
JOIN customers ON Complain.Customerid = Complain.Customerid;

--9. View_Employee_Branch
CREATE VIEW View_Employee_Branch AS
SELECT 
    employee.Employeeid,
    employee.Employeename,
    Branch.Branch_Name
FROM 
    employee
JOIN Branch ON employee.Branch_ID =Branch.Branch_ID;


--------------View Active Card----------------------
CREATE VIEW View_Active_Cards AS
SELECT 
    accounts.Accountid,
    customers.Customername,
    AccountCard.Card_ID,
    AccountCard.Expiry_Date
FROM AccountCard
JOIN accounts ON AccountCard.Accountid =accounts.Accountid
JOIN customers ON accounts.Customerid = customers.Customerid
WHERE AccountCard.Status = 'Active';

--------------------------procedures---------------------------

CREATE PROCEDURE InsertNewCustomer
    @customerid int ,
    @Customername VARCHAR(100),
    @DOB DATE,
    @Address VARCHAR(50),
    @Phone VARCHAR(15),
    @Email VARCHAR(100),
	@Accountid int,
    @Accounttype VARCHAR(100),
    @Balance DECIMAL(12,2)
AS
BEGIN
    INSERT INTO customers (Customerid, Customername, DOB, Address, Phone, Email)
    VALUES (@customerid,@Customername, @DOB, @Address, @Phone, @Email);
   

    INSERT INTO accounts (Accountid, Customerid, Accounttype, Balance)
    VALUES (@Accountid , @customerid, @Accounttype, @Balance);

    PRINT 'Customer and account inserted successfully.';
END;

----Update Customer Information----
CREATE PROCEDURE UpdateCustomerInfo
    @Customerid INT,
    @Phone VARCHAR(15),
    @Address VARCHAR(50),
    @Email VARCHAR(100)
AS
BEGIN
    UPDATE customers
    SET Phone = @Phone,
        Address = @Address,
        Email = @Email
    WHERE Customerid = @Customerid;

    PRINT 'Customer information updated successfully.';
END;

CREATE PROCEDURE ApplyLoan---------------------------
    @Loanid INT,
    @Customerid INT,
    @Amount DECIMAL(12,2),
    @Applydate DATE
AS
BEGIN
    INSERT INTO loans (Loanid, Customerid, Amount, Applydate)
    VALUES (@Loanid, @Customerid, @Amount, @Applydate);

    PRINT 'Loan application submitted.';
END;


CREATE PROCEDURE RecordRepayment-----------------------------------
    @Repay_ID INT,
    @Loanid INT,
    @Amount DECIMAL(15,3)
AS
BEGIN
    INSERT INTO Repayment (Repay_ID, Loanid, Amount)
    VALUES (@Repay_ID, @Loanid, @Amount);

    PRINT 'Repayment recorded successfully.';
END;

CREATE PROCEDURE RegisterComplaint---------------------------
    @Complain_ID INT,
    @Customerid INT,
    @Description VARCHAR(50)
AS
BEGIN
    INSERT INTO Complain (Complain_ID, Customerid, Description)
    VALUES (@Complain_ID, @Customerid, @Description);

    PRINT 'Complaint registered successfully.';
END;

CREATE PROCEDURE IssueCard------------------------------------------
    @Card_ID INT,
    @Accountid INT,
    @Expiry_Date DATE,
    @Status VARCHAR(20)
AS
BEGIN
    INSERT INTO AccountCard (Card_ID, Accountid, Expiry_Date, Status)
    VALUES (@Card_ID, @Accountid, @Expiry_Date, @Status);

    PRINT 'Card issued successfully.';
END;


CREATE PROCEDURE DeactivateCard-----------------------------------
    @Card_ID INT
AS
BEGIN
    UPDATE AccountCard
    SET Status = 'Inactive'
    WHERE Card_ID = @Card_ID;

    PRINT 'Card deactivated.';
END;

CREATE PROCEDURE DeleteCustomerAccount  -------------------
    @Customerid INT
AS
BEGIN
    DELETE FROM accounts
    WHERE Customerid = @Customerid;

    DELETE FROM customers
    WHERE Customerid = @Customerid;
    PRINT 'Customeraccount deleted successfully.';
END;


CREATE PROCEDURE ShowData             ----------------
    @Accounttype VARCHAR(100)
AS
BEGIN
    SELECT customers.Customerid,customers.Customername,accounts.Accountid,accounts.Accounttype,accounts.Balance FROM customers 
  inner JOIN accounts  
		ON
		customers.Customerid = accounts.Customerid
    WHERE  accounts.Accounttype = @Accounttype;
END;

--------------------------------- Procedures with transactions ---------------

CREATE PROCEDURE ProcessWithdrawal---------------
@Accountid INT,
@Amount DECIMAL(10,2),
@TransactionDate DATE,
@Transactionid INT 
AS
BEGIN
BEGIN TRANSACTION;
BEGIN TRY
UPDATE accounts SET Balance = Balance - @Amount
WHERE Accountid = @Accountid AND Balance >= @Amount;
IF @@ROWCOUNT=0
BEGIN
ROLLBACK;
PRINT 'Withdrawal failed: Insufficient funds or invalid account';
END
ELSE
BEGIN
INSERT INTO transactions (Transactionid,Accountid, Transactiontype, Amount, transaction_date)
VALUES (@Transactionid,@Accountid, 'withdrawal', @Amount, @TransactionDate);
COMMIT;
PRINT 'Withdrawal successful';
END
END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0
ROLLBACK;
PRINT 'Withdrawal failed: ' + ERROR_MESSAGE();
END CATCH
END;

CREATE PROCEDURE ProcessDeposit---------------
    @Accountid INT,
    @Amount DECIMAL(10,2),
    @TransactionDate DATE,
    @Transactionid INT  -- User must provide transaction ID
AS
BEGIN
BEGIN TRANSACTION;    
BEGIN TRY
UPDATE accounts 
SET Balance = Balance + @Amount  
WHERE Accountid = @Accountid;
INSERT INTO transactions (Transactionid, Accountid, Transactiontype, Amount, transaction_date)
VALUES (@Transactionid, @Accountid, 'deposit', @Amount, @TransactionDate);
COMMIT;
PRINT 'Deposit successful';
END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0
ROLLBACK;
PRINT 'Deposit failed: ' + ERROR_MESSAGE();
END CATCH
END;

CREATE PROCEDURE ProcessTransfer-------------------
    @FromAccount INT,
    @ToAccount INT,
    @Amount DECIMAL(10,2),
    @TransactionDate DATE
AS
BEGIN
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- 1. Update account balances
        UPDATE accounts SET Balance = Balance - @Amount WHERE Accountid = @FromAccount;
        UPDATE accounts SET Balance = Balance + @Amount WHERE Accountid = @ToAccount;
        
        -- 2. Record transfer (Transferid auto-generated)
        INSERT INTO transfers (From_Accountid, To_Accountid, Amount)
        VALUES (@FromAccount, @ToAccount, @Amount);
        
        -- 3. Record transactions (Transactionid auto-generated starting from 24)
        INSERT INTO transactions (Accountid, Transactiontype, Amount, transaction_date)
        VALUES (@FromAccount, 'transfer_out', @Amount, @TransactionDate);
        
        INSERT INTO transactions (Accountid, Transactiontype, Amount, transaction_date)
        VALUES (@ToAccount, 'transfer_in', @Amount, @TransactionDate);
        
        COMMIT;
        PRINT 'Transfer completed successfully';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        
        PRINT 'Transfer failed: ' + ERROR_MESSAGE();
    END CATCH
END;

-------------------------------------------------------------------

-------Repayment Transaction------------------
CREATE PROCEDURE ProcessRepayment
    @Loanid INT,
    @RepayAmount DECIMAL(15,3)
AS
BEGIN
    BEGIN TRANSACTION;
    
    BEGIN TRY
INSERT INTO Repayment (Loanid, Amount)
        VALUES (@Loanid, @RepayAmount);
        
        COMMIT;
        PRINT 'Repayment recorded successfully';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        
        PRINT 'Repayment failed: ' + ERROR_MESSAGE();
    END CATCH
END;