-- Q1: Display every USERNAME and the lowest RATING they have left in a review
SELECT 
u.Username,
MIN(r.Rating) AS LowestRating
FROM UserBase u
LEFT JOIN Reviews r
ON u.UserID = r.UserID
GROUP BY 
u.UserID,
u.Username;

--Q2: Display ever user's EMAIL, QUESTION and ANSWER
SELECT 
u.Email,
sq.Question,
sq.Answer
FROM UserBase u
LEFT JOIN SecurityQuestion sq
ON u.UserID = sq.UserID;

--Q3: Display the FIRSTNAME, EMAIL, and WALLETFUNDS of every user that does not have a WISHLIST
SELECT
u.FirstName,
u.Email,
u.WalletFunds
FROM UserBase u
WHERE NOT EXISTS 
(
    SELECT 1
    FROM Wishlist w
    WHERE w.UserID = u.UserID
);

--Q4: Display every USERNAME and number of products they have ordered
SELECT u.Username,
COUNT(o.ProductCode) AS ProductOrdered
FROM UserBase u
LEFT JOIN Orders o
ON u.UserID = o.UserID
GROUP BY 
u.UserID,
u.Username;

--Q5: Display the age of any user who has ordered a product within the last 6 months
SELECT 
FLOOR(
    MONTHS_BETWEEN(SYSDATE, u.Birthday) / 12
) AS Age
FROM UserBase u
WHERE EXISTS
(
    SELECT 1
    FROM Orders o
    WHERE o.UserID = u.UserID
    AND o.PurchaseDate >= ADD_MONTHS(SYSDATE,-6)
);

--Q6: Display the USERNAME and BIRTHDAY of the user who has the highest friend count
SELECT u.Username,
u.Birthday
FROM UserBase u
JOIN (
    SELECT 
    UserID,
    COUNT(*) AS FriendCount
    FROM FriendsList
    GROUP BY UserID
) f
ON u.UserID = f.UserID
WHERE f.FriendCount =
(
   SELECT MAX(FriendCount)
   FROM
   (
    SELECT
    COUNT(*) AS FriendCount
    FROM FriendsList
    GROUP BY UserID
   )
);

-- Q7: Display PRODUCTNAME, RELEASEDATE, PRICE, and DESCRIPTION for any product found in WISHLIST.
SELECT DISTINCT
p.ProductName,
p.ReleaseDate,
p.Price,
p.Description
FROM ProductList p
JOIN Wishlist w
ON p.ProductCode = w.ProductCode;

-- Q8: Display PRODUCTNAME, highest RATING, and number of reviews for each product in REVIEWS. Order descending by RATING
SELECT 
p.ProductName,
MAX(r.Rating) AS HighestRating,
COUNT(*) AS ReviewCount
FROM ProductList p
JOIN Reviews r
ON p.productCode = r.ProductCode
GROUP BY
p.ProductCode,
p.ProductName
ORDER BY 
HighestRating DESC;

-- Q9: Create a view displaying PRODUCTNAME, GENRE, and RATING for products with a 5 or 1 RATING. Order by ascending by Rating
CREATE OR REPLACE VIEW VW_PRODUCT_RATINGS AS
SELECT DISTINCT
p.ProductName,
p.Genre,
r.Rating
FROM ProductList p
JOIN Reviews r
ON p.ProductCode = r.ProductCode
WHERE r.Rating IN (1, 5);
-- Display in the required order
SELECT 
Productname,
Genre,
Rating 
FROM VW_PRODUCT_RATINGS
ORDER BY Rating ASC;

-- Q10: Display count products ordered, grouped by GENRE. Order alphabetically by GENRE.
SELECT 
p.Genre,
COUNT(o.ProductCode) AS ProductsOrdered
FROM ProductList p
JOIN Orders o
ON p.ProductCode = o.ProductCode
GROUP BY 
p.Genre
ORDER BY 
p.Genre ASC;

-- Q11: Create a view displaying each PUBLISHER, average PRICE, and sum of HOURSPLAYED for their products.
CREATE OR REPLACE VIEW VW_PUBLISHER_STATS AS
SELECT
p.Publisher,
AVG(p.Price) AS AveragePrice,
SUM(NVL(h.TotalHours, 0)) AS TotalHoursPlayed
FROM ProductList p
LEFT JOIN 
(
    SELECT 
    ProductCode,
    SUM(HoursPlayed) AS TotalHours
    FROM UserLibrary
    GROUP BY ProductCode
) h
ON p.ProductCode = h.ProductCode
GROUP BY 
p.Publisher;

-- Check
SELECT *
FROM VW_PUBLISHER_STATS;

-- Q12: Display sum of money spent on products and corresponding PUBLISHER from ORDERS. Order desc by money spent.
SELECT
p.Publisher,
SUM(o.Price) AS TotalMoneySpent
FROM Orders o
JOIN ProductList p
ON o.ProductCode = p.ProductCode
GROUP BY 
p.Publisher
ORDER BY TotalMoneySpent DESC;

-- Q13: Display TICETID, USERNAME, EMAIL, and ISSUE for NEW or IN PROGRESS tickets sorted by latest DATEUPDATED
SELECT
s.TicketID,
u.Username,
s.Email,
s.Issue
FROM UserSupport s
LEFT JOIN UserBase u
ON LOWER(s.EMAIL) = LOWER(u.Email)
WHERE s.Status IN ('NEW', 'IN PROGRESS')
ORDER BY 
s.DateUpdated DESC;

-- Q14: Display USERNAME and count of TICKETIT users have submitted
SELECT 
u.Username,
COUNT(s.TicketID) AS TicketCount
FROM UserBase u
JOIN UserSupport s
ON LOWER(u.Email) = LOWER(s.Email)
GROUP BY 
u.UserID,
u.Username;

-- Q15: Display USERID and EMAIL of users who submitted a support ticket and used FIRSTNAME, LASTNAME, or a combination in their EMAIL address.
SELECT DISTINCT
u.UserID,
u.Email
FROM UserBase u
JOIN UserSupport s
ON LOWER(u.Email) = LOWER(s.Email)
WHERE
LOWER(u.Email) LIKE '%' || LOWER(u.FirstName) || '%'
OR LOWER(u.Email) LIKE '%' || LOWER(u.LastName) || '%';

-- Q16: Display EMAIL of any user with NEW or IN PROGRESS ticket where EMAIL is not saved in USERBASE
SELECT s.Email
FROM UserSupport s
WHERE s.Status IN ('NEW', 'IN PROGRESS')
AND NOT EXISTS
(
    SELECT 1
    FROM UserBase u
    WHERE LOWER(u.Email) = LOWER(s.Email)
);

-- Q17: Display TICKETID, FIRSTNAME, LASTNAME, and USERNAME where the user's USERNAME is mentioned in the issue
SELECT 
s.TicketID,
u.FirstName,
u.LastName,
u.Username
FROM UserSupport s
JOIN UserBase u 
ON INSTR(
    LOWER(s.Issue),
    LOWER(u.Username)
) > 0;

-- Q18: Display USERNAME and PASSWORD associated with the EMAIL provided in suppoprt tickets
SELECT DISTINCT
u.Username,
u.Password
FROM UserBase u
JOIN UserSupport s
ON LOWER(u.Email) = LOWER(s.Email);

-- Q19: Create a view displaying USERNAME, DATEASSIGNED and PENALTY where PENALTY isn't NULL and infraction was assigned within the last month
CREATE OR REPLACE VIEW VW_RECENT_PENALTIES AS
SELECT
u.Username,
i.DateAssigned,
i.Penalty
FROM UserBase u
JOIN Infractions i
ON u.UserID = i.UserID
WHERE i.Penalty IS NOT NULL
AND i.DateAssigned >= ADD_MONTHS(SYSDATE, -1);

--Checking
SELECT *
FROM VW_RECENT_PENALTIES;

-- Q20: Display USERNAME and EMAIL of users at least 18 who have not received an infraction within the last 4 months.
SELECT u.Username,
u.Email
FROM UserBase u
WHERE u.Birthday <= ADD_MONTHS(TRUNC(SYSDATE), -216)
AND NOT EXISTS
(
    SELECT 1
    FROM Infractions i
    WHERE i.UserID = u.UserID
    AND i.DateAssigned >= ADD_MONTHS(SYSDATE, -4)
);

-- Q21: Display USERNAME, DATEASSIGNED, and full guideline name RULENUM and TITLE separated by a blank space.
SELECT 
u.Username,
i.DateAssigned,
TO_CHAR(c.RuleNum) || ' ' || c.Title as GuidelineName
FROM UserBase u
JOIN Infractions i
ON u.UserID = i.UserID
JOIN CommunityRules c
ON i.RuleNum = c.RuleNum;

-- Q22: Display USERIDm USERNAME, EMAIL, and sum of all SEVERITYPOINTS each user has received 
SELECT
u.UserID,
u.Username,
u.Email,
NVL(SUM(c.SeverityPoint), 0) AS TotalSeverityPoints
FROM UserBase u
LEFT JOIN Infractions i
ON u.UserId = i.UserID
LEFT JOIN CommunityRules c
ON i.RuleNum = c.RuleNum
GROUP BY
u.UserID,
u.Username,
u.Email;

-- Q23: Display TITLE, DESCRIPTION, and PENALTY for all infractions assigned 
SELECT 
c.Title,
c.Description,
i.Penalty
FROM Infractions i
JOIN CommunityRules c
ON i.RuleNum = c.RuleNum;

-- Q24: Display USERNAME and count of infractions for users who violated community rules at least 15 times
SELECT
    u.Username,
    COUNT(i.InfractionID) AS InfractionCount
FROM UserBase u
JOIN Infractions i
    ON u.UserID = i.UserID
GROUP BY
    u.UserID,
    u.Username
HAVING
    COUNT(i.InfractionID) >= 15;