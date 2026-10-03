-- Question 1: Display users who have not made an order

SELECT UserID
FROM UserBase
MINUS
SELECT UserID
FROM Orders;


-- Question 2: Display products that have no reviews

SELECT ProductCode
FROM ProductList
MINUS
SELECT ProductCode
FROM Reviews;


-- Question 3: Display all users and identify them as Adult or Minor

SELECT U.*,
       'Adult' AS AgeGroup
FROM UserBase U
WHERE Birthday <= ADD_MONTHS(SYSDATE, -216)
UNION ALL
SELECT U.*,
       'Minor' AS AgeGroup
FROM UserBase U
WHERE Birthday > ADD_MONTHS(SYSDATE, -216)
   OR Birthday IS NULL;


-- Question 4: Display all products and identify them as On Sale or Base Price

SELECT P.*,
       'On Sale' AS PriceStatus
FROM ProductList P
WHERE Price <= 20
UNION ALL
SELECT P.*,
       'Base Price' AS PriceStatus
FROM ProductList P
WHERE Price > 20
   OR Price IS NULL;


-- Question 5: Display users who played GAME6 and have a profile image

SELECT UserID
FROM UserLibrary
WHERE ProductCode = 'GAME6'
INTERSECT
SELECT UserID
FROM UserProfile
WHERE ImageFile IS NOT NULL;


-- Question 6: Display products ranked position 1 or 2 that also have a review rating of 3 or higher

SELECT ProductCode
FROM WishList
WHERE Position IN (1, 2)
INTERSECT

SELECT ProductCode
FROM Reviews
WHERE Rating >= 3;


-- Question 7: Display users who share the same birthday SELF JOIN

SELECT
    U1.Username AS Username1,
    U1.Birthday AS Birthday1,
    U2.Username AS Username2,
    U2.Birthday AS Birthday2
FROM UserBase U1
JOIN UserBase U2
    ON U1.Birthday = U2.Birthday
   AND U1.UserID < U2.UserID;


-- Question 8: Display Cartesian Product of USERLIBRARY and WISHLIST

SELECT *
FROM UserLibrary
CROSS JOIN WishList;


-- Question 9: UNION ALL of USERBASE and PRODUCTLIST

SELECT
    'USER' AS RecordType,
    TO_CHAR(UserID) AS Identifier,
    Username AS Name,
    Email AS Detail
FROM UserBase
UNION ALL
SELECT
    'PRODUCT' AS RecordType,
    ProductCode AS Identifier,
    ProductName AS Name,
    Publisher AS Detail
FROM ProductList;


-- Question 10: UNION ALL of CHATLOG and USERPROFILE to generate user activity data

SELECT
    'CHAT' AS ActivityType,
    SenderID AS UserID,
    DateSent AS ActivityDate,
    Content AS ActivityDetail
FROM ChatLog
UNION ALL
SELECT
    'PROFILE' AS ActivityType,
    UserID,
    CAST(NULL AS DATE) AS ActivityDate,
    Description AS ActivityDetail
FROM UserProfile;


-- Question 11: Display usernames of users who have not received an infraction

SELECT Username
FROM UserBase
MINUS
SELECT Username
FROM UserBase
WHERE UserID IN
(
    SELECT UserID
    FROM Infractions
);


-- Question 12: Display Community Rules that have not been broken

SELECT
    Title,
    Description
FROM CommunityRules
MINUS
SELECT
    Title,
    Description
FROM CommunityRules
WHERE RuleNum IN
(
    SELECT RuleNum
    FROM Infractions
);


-- Question 13: Display username and email of users who have received a penalty

SELECT
    Username,
    Email
FROM UserBase
INTERSECT
SELECT
    U.Username,
    U.Email
FROM UserBase U
JOIN Infractions I
    ON U.UserID = I.UserID
WHERE I.Penalty IS NOT NULL;


-- Question 14: Display dates where an infraction was assigned and a support ticket was submitted on the same day

SELECT TRUNC(DateAssigned) AS ActivityDate
FROM Infractions
INTERSECT
SELECT TRUNC(DateSubmitted)
FROM UserSupport;


-- Question 15: Display every Community Rule title and its penalty

SELECT
    C.Title,
    I.Penalty
FROM CommunityRules C
CROSS JOIN Infractions I
WHERE C.RuleNum = I.RuleNum;


-- Question 16: Display all Community Rules and identify rules as Bannable or Appealable

SELECT C.*,
       'Bannable' AS RuleStatus
FROM CommunityRules C
WHERE SeverityPoint >= 10
UNION ALL
SELECT C.*,
       'Appealable' AS RuleStatus
FROM CommunityRules C
WHERE SeverityPoint < 10
   OR SeverityPoint IS NULL;


-- Question 17: Display all support tickets and identify high priority tickets

SELECT U.*,
       'High Priority' AS Priority
FROM UserSupport U
WHERE Status <> 'CLOSED'
  AND DateUpdated < SYSDATE - 7
UNION ALL
SELECT U.*,
       CAST(NULL AS VARCHAR2(20)) AS Priority
FROM UserSupport U
WHERE Status = 'CLOSED'
   OR DateUpdated >= SYSDATE - 7;


-- Question 18: Display Cartesian Product of USERSUPPORT and INFRACTIONS

SELECT *
FROM UserSupport
CROSS JOIN Infractions;


-- Question 19: Display CLOSED support tickets that were last updated on the same day SELF JOIN

SELECT
    U1.TicketID AS TicketID1,
    U1.DateUpdated AS DateUpdated1,
    U2.TicketID AS TicketID2,
    U2.DateUpdated AS DateUpdated2
FROM UserSupport U1
JOIN UserSupport U2
    ON TRUNC(U1.DateUpdated) = TRUNC(U2.DateUpdated)
   AND U1.TicketID < U2.TicketID
WHERE U1.Status = 'CLOSED'
  AND U2.Status = 'CLOSED';


-- Question 20: UNION ALL of USERBASE and INFRACTIONS to generate user activity data

SELECT
    'USER' AS ActivityType,
    UserID,
    CAST(NULL AS DATE) AS ActivityDate,
    Username AS ActivityDetail
FROM UserBase
UNION ALL
SELECT
    'INFRACTION' AS ActivityType,
    UserID,
    DateAssigned AS ActivityDate,
    Penalty AS ActivityDetail
FROM Infractions;