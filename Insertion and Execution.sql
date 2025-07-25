Use Banking_System;

INSERT INTO Branch(Branch_ID,Branch_Name)
VALUES(1,'Multan'),
(2,'Lahore'),
(3,'karachi');

INSERT INTO accounts (Accountid, Customerid, Accounttype, Branch_ID, Balance)
VALUES
(105, 5, 'savings', 1, 25000.00),
(106, 6, 'current', 1, 35000.00),
(107, 7, 'savings', 1, 15000.00),
(108, 8, 'fixed_deposit', 1, 60000.00),
(109, 9, 'current', 1, 18000.00);

INSERT INTO customers (Customerid, Customername, DOB, Address, Phone, Email)
VALUES
(5, 'Zainab Fatima', '1999-12-05', 'Faisalabad-Pakistan', '03011234567', 'zainab.fatima@example.com'),
(6, 'Ahsan Javed', '1998-08-17', 'Gujranwala-Pakistan', '03222334455', 'ahsan.javed@example.com'),
(7, 'Sara Khan', '2000-01-30', 'Karachi-Pakistan', '03144556677', 'sara.khan@example.com'),
(8, 'Hamid Raza', '1997-11-15', 'Rawalpindi-Pakistan', '03311223344', 'hamid.raza@example.com'),
(9, 'Laiba Sheikh', '2002-03-10', 'Quetta-Pakistan', '03455667788', 'laiba.sheikh@example.com');

INSERT INTO employee (Employeeid, Employeename,Branch_ID,Designation)
VALUES
(201, 'Ali Nawaz', 1,'Manager'),
(202, 'Hina Tariq', 1,'Cashier'),
(203, 'Usman Aslam', 1,'Loan Officer'),
(204, 'Kiran Ahmed',1, 'Service Rep'),
(205, 'Bilal Iqbal',1, 'IT Support');

INSERT INTO loans (Loanid, Customerid, Amount,Applydate)
VALUES
(301, 5,50000.00, '2000-12-05'),
(302, 6,100000.00,'1999-08-17'),
(303, 7, 30000.00,'2000-06-30'),
(304, 8,70000.00,'1998-11-15'),
(305, 9,20000.00,'2003-03-10');

INSERT INTO Complain(Complain_ID, Customerid, Description)
VALUES
(401, 5,'ATM did not dispense cash but deducted amount'),
(402, 6, 'Unable to access account online'),
(403, 7,'Lost debit card, need replacement'),
(404, 8,'Loan approval is taking too long'),
(405, 9,'Staff behavior was unprofessional');

INSERT INTO Service(Customerid,Service_Type)
VALUES
(5, 'Online Banking Activation'),
(6, 'New Cheque Book'),
(7, 'Mobile Banking Setup'),
(8, 'Credit Card Request'),
(9, 'Update Contact Info');

INSERT INTO AccountCard (Card_ID, Accountid, Expiry_Date, Status)
VALUES
(501, 105, '2026-12-31', 'Active'),
(502, 106, '2025-10-31', 'Active'),
(503, 107, '2027-05-31', 'Active'),
(504, 108, '2026-08-31', 'Inactive'),
(505, 109, '2025-11-30', 'Active');

INSERT INTO LoanDistribution (Distribution_Amount, Loanid)
VALUES
(25000.000, 301),  -- Partial distribution for Zainab's loan
(50000.000, 302),  -- Partial distribution for Ahsan's loan
(15000.000, 303),  -- Partial distribution for Sara's loan
(35000.000, 304),  -- Partial distribution for Hamid's loan
(10000.000, 305);  -- Partial distribution for Laiba's loan

INSERT INTO Repayment (Loanid, Amount)
VALUES
(301, 5000.000),  -- Zainab's repayment
(302, 10000.000), -- Ahsan's repayment
(303, 3000.000), -- Sara's repayment
(304, 7000.000),  -- Hamid's repayment
(305, 2000.000);  -- Laiba's repayment

INSERT INTO transactions (Accountid, Transactiontype, Amount, transaction_date)
VALUES
(105, 'deposit', 10000.00, '2025-05-01'),  -- Zainab's deposit
(106, 'withdrawal', 5000.00, '2025-05-02'), -- Ahsan's withdrawal
(107, 'deposit', 15000.00, '2025-05-03'),   -- Sara's deposit
(108, 'transfer_out', 3000.00, '2025-05-04'), -- Hamid's transfer
(109, 'transfer_in', 2000.00, '2025-05-05'); -- Laiba's transfer

INSERT INTO transfers ( From_Accountid, To_Accountid, Amount)
VALUES
(105, 106, 5000.00),  -- Zainab to Ahsan
(106, 107, 3000.00),  -- Ahsan to Sara
(107, 108, 4000.00),  -- Sara to Hamid
(108, 109, 2000.00), -- Hamid to Laiba
(109, 105, 1000.00); -- Laiba to Zainab

select * from View_Customer_Accounts;

select * from Transaction_History;

SELECT * FROM View_Customer_Loans;

SELECT * FROM View_Loan_Distribution;

SELECT * FROM View_Active_Cards;

SELECT * FROM View_Customer_Services;

select * from View_Customer_Complaints;

SELECT * FROM View_Active_Cards;

EXEC InsertNewCustomer
    @customerid = 4,
    @Customername = 'hassaan',
    @DOB = '2001-11-25',
    @Address = 'Karachi-Pakistan',
    @Phone = '03123456789',
    @Email = 'h5566@example.com',
    @Accountid = 104,
    @Accounttype = 'Savings',
    @Balance = 30000.00;

EXEC UpdateCustomerInfo
    @Customerid = 5, 
    @Phone = '555-987-6543', 
    @Address = 'Multan-pakistan', 
    @Email = 'zainab.com'; 

	EXEC ApplyLoan
    @Loanid = 306,             
    @Customerid = 4,          
    @Amount = 10000.00, 
    @Applydate = '2025-05-24';

	EXEC RecordRepayment
    @Repay_ID = 606,  
    @Loanid = 306,   
    @Amount = 1500.500; 

	EXEC RegisterComplaint
    @Complain_ID = 406,           
    @Customerid = 4,   
    @Description = 'Unauthorized transaction'; 

	EXEC IssueCard
    @Card_ID = 506,               
    @Accountid = 104,             
    @Expiry_Date = '2028-12-31',
    @Status = 'Active';  
	
	EXEC DeactivateCard 
    @Card_ID = 506; 
    
	EXEC DeleteCustomerAccount
	@Customerid=4;

    EXEC ShowData @Accounttype='savings';

	EXEC ProcessDeposit
	@Accountid=105,
	@Amount=1000.00,
	@TransactionDate='2025-12-1',
	@Transactionid=30;

	EXEC ProcessWithdrawal
	@Accountid=105,
	@Amount=1000.00,
	@TransactionDate='2025-12-1',
	@Transactionid=29;

	EXEC ProcessTransfer 
    @FromAccount = 105,
    @ToAccount = 106,
    @Amount = 500.00,
    @TransactionDate = '2025-06-15';

	EXEC ProcessLoanDistribution 
    @Loanid = 302,
    @DistAmount = 30000.00;

	select * from LoanDistribution;

	EXEC ProcessRepayment 
    @Loanid = 301,
    @RepayAmount = 5000.00;

