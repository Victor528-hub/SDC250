-- Question 1: Enforce referential integrity for ORDERS, REVIEWS, and USERLIBRARY
ALTER TABLE ORDERS
ADD CONSTRAINT FK_Orders_User
FOREIGN KEY (UserID)
REFERENCES UserBase(UserID);

ALTER TABLE ORDERS
ADD CONSTRAINT FK_Orders_Product
FOREIGN KEY (ProductCode)
REFERENCES ProductList(ProductCode);

ALTER TABLE REVIEWS
ADD CONSTRAINT FK_Reviews_User
FOREIGN KEY (UserID)
REFERENCES UserBase(UserID);

ALTER TABLE USERLIBRARY
ADD CONSTRAINT FK_UserLibrary_User
FOREIGN KEY (UserID)
REFERENCES UserBase(UserID);

ALTER TABLE USERLIBRARY
ADD CONSTRAINT FK_UserLibrary_Product
FOREIGN KEY (ProductCode)
REFERENCES ProductList(ProductCode);

-- Question 2: Display users who are at least 18 years old
SELECT 
FirstName || '' || LastName AS FullName,
Username
FROM UserBase
WHERE BirthDay <= ADD_MONTHS(SYSDATE, -216);

-- Question 3: Find maximum and average username length
SELECT 
MAX(LENGTH(Username)) AS MaxUsernameLength,
AVG(LENGTH(Username)) AS AvgUsernameLength
FROM UserBase;

-- Question 4: Display security questions beginning with 'What is' or 'What was'
SELECT Question
FROM SecurityQuestion
WHERE Question LIKE 'What is%'
OR Question LIKE 'What was%';

-- Question 5: Display lowest rating and number of reviews for each product
SELECT 
ProductCode,
MIN(Rating) AS LowestRating,
COUNT(*) AS ReviewCount
FROM Reviews
GROUP BY ProductCode
ORDER BY ReviewCount DESC;

-- Question 6: Display products ranked at position 1 and the number of users
SELECT 
ProductCode,
COUNT(DISTINCT UserID) AS UserCount
FROM WishList
WHERE Position = 1
GROUP BY ProductCode;

-- Question 7: Display total amount spent by each user
SELECT 
UserID,
SUM(Price) AS TotalSpent
FROM Orders
GROUP BY UserID;

-- Question 8: Display gross profits by purchase date
SELECT 
TRUNC(PurchaseDate) AS PurchaseDate,
SUM(Price) AS GrossProfit
FROM Orders
GROUP BY TRUNC(PurchaseDate)
ORDER BY GrossProfit DESC;

-- Question 9: Display the top 5 games with the most total hours played
SELECT
ProductCode,
SUM(HoursPlayed) AS TotalHoursPlayed
FROM UserLibrary
GROUP BY ProductCode
ORDER BY TotalHoursPlayed DESC
FETCH FIRST 5 ROWS ONLY;

-- Question 10: Create a view showing each user and their total infractions
-- PT 1 Create View
CREATE OR REPLACE VIEW VW_USERINFRACTIONS AS
SELECT
UserID,
COUNT(*) AS InfractionCount
FROM Infractions
GROUP BY UserID;
-- PT 2 Display view
SELECT *
FROM VW_USERINFRACTIONS
ORDER BY InfractionCount DESC;

-- Question 11: Create a view showing how many times each user broke each rule
-- PT 1 
CREATE OR REPLACE VIEW VW_USERRULEINFRACTIONS AS
SELECT
UserID,
RuleNum,
COUNT(*) AS TimesBroken
FROM Infractions
GROUP BY UserID, RuleNum;
-- PT 2
SELECT *
FROM VW_USERRULEINFRACTIONS
ORDER BY UserID;

-- Question 12: Display each rule, penalty, and number of times the penalty was assigned
SELECT 
RuleNum,
Penalty,
COUNT(*) AS PenaltyCount
FROM Infractions 
GROUP BY RuleNum, Penalty;

-- Question 13: Display average, maximum, and minimum turnaround time for closed tickets

SELECT 
AVG(DateUpdated - DateSubmitted) AS AverageTime,
MAX(DateUpdated - DateSubmitted) AS MaximumTime,
MIN(DateUpdated - DateSubmitted) AS MinimumTime
FROM UserSupport
WHERE Status = 'CLOSED';

-- Question 14: Display new ticket issues and the number of times submitted
SELECT
Email,
Issue,
COUNT(*) AS IssueCount
FROM UserSupport
WHERE Status = 'NEW'
GROUP BY DateSubmitted, Email, Issue
ORDER BY IssueCount;

-- Question 15: Display users whose first or last name appears in their password
SELECT
UserID,
FirstName,
LastName,
Username,
Password
FROM UserBase
WHERE LOWER(Password) LIKE '&' || LOWER(FirstName) || '&'
OR LOWER(Password) LIKE '&' || LOWER(LastName) || '&';

-- Question 16: Display each publisher and the average price of their products
SELECT 
Publisher,
AVG(Price) AS AveragePrice
FROM ProductList
GROUP BY Publisher
ORDER BY Publisher;

-- Question 17: Create a view for products released over 5 years ago with a 25% discount
-- PT 1
CREATE OR REPLACE VIEW VW_OLDPRODUCTDISCOUNT AS
SELECT
ProductName,
Price * 0.75 AS DiscountedPrice
FROM ProductList
WHERE ReleaseDate < ADD_MONTHS(SYSDATE, -60);

-- PT 2
SELECT *
FROM VW_OLDPRODUCTDISCOUNT;

-- Question 18: Display the maximum and minimum product price by genre
SELECT
Genre,
MAX(Price) AS MaximumPrice,
MIN(Price) AS MinimumPrice
FROM ProductList
GROUP BY Genre;

-- Question 19: Create a view showing chat messages from the previous week
-- PT 1
CREATE OR REPLACE VIEW VW_RECENTCHATLOG AS
SELECT *
FROM ChatLog
WHERE DateSent BETWEEN SYSDATE - 7 AND SYSDATE;
-- PT 2
SELECT *
FROM VW_RECENTCHATLOG;

-- Question 20: Create a view showing recent assigned penalties
-- PT 1
CREATE OR REPLACE VIEW VW_RECENTPENALTIES AS 
SELECT 
UserID,
DateAssigned,
Penalty
FROM Infractions
WHERE Penalty IS NOT NULL
AND DateAssigned >= ADD_MONTHS(SYSDATE, -1);

-- PT 2
SELECT *
FROM VW_RECENTPENALTIES;