-- 1 Eliminate the STOREFRONT table (Steve Albino)
-- pt 1 Alter the Productlist table
alter table ProductList
add (PRICE NUMBER(8,2),
DESCRIPTION varchar2(250)
);
-- pt 2 series of statements to move the price and description 
UPDATE Productlist P
SET PRICE =
(
    SELECT StoreFront.Price
    from StoreFront
    WHERE StoreFront.ProductCode = ProductList.ProductCode
);

-- Copy description data from StoreFront
UPDATE ProductList
SET DESCRIPTION = (
    SELECT StoreFront.Description
    FROM StoreFront
    WHERE
    StoreFront.ProductCode = ProductList.ProductCode
    );
    
-- Remove StoreFront Table 
DROP TABLE StoreFront;

-- 2 Create CHATLOG Table

CREATE TABLE CHATLOG
(
    ChatID NUMBER(3),
    ReceiverID NUMBER(3),
    SenderID NUMBER(3),
    DateSent DATE,
    Content varchar2(250),

    CONSTRAINT PK_ChatLog
    PRIMARY KEY (ChatID),

    CONSTRAINT 
    FK_ChatLog_Receiver
    FOREIGN KEY
    (ReceiverID)
    REFERENCES
    UserBase(UserID),

    CONSTRAINT
    FK_ChatLog_Sender
    FOREIGN KEY (SenderID)
    REFERENCES
UserBase(UserID)
);

-- Sample Date
INSERT INTO ChatLog VALUES (1,102,101,SYSDATE-20,'Hello!');
INSERT INTO ChatLog VALUES (2,101,102,SYSDATE-20,'Hi Ashley.');
INSERT INTO ChatLog VALUES (3,103,104,SYSDATE-18,'Want to play GAME7?');
INSERT INTO ChatLog VALUES (4,104,103,SYSDATE-18,'Sure.');
INSERT INTO ChatLog VALUES (5,105,106,SYSDATE-15,'What are you playing?');
INSERT INTO ChatLog VALUES (6,106,105,SYSDATE-15,'GAME6 currently.');
INSERT INTO ChatLog VALUES (7,107,108,SYSDATE-12,'Good morning.');
INSERT INTO ChatLog VALUES (8,108,107,SYSDATE-12,'Morning!');
INSERT INTO ChatLog VALUES (9,109,110,SYSDATE-10,'Need help with a quest.');
INSERT INTO ChatLog VALUES (10,110,109,SYSDATE-10,'I can help.');
INSERT INTO ChatLog VALUES (11,111,112,SYSDATE-8,'Ready to play?');
INSERT INTO ChatLog VALUES (12,112,111,SYSDATE-8,'Absolutely.');


-- 3 Create FRIENDSLIST Table
CREATE TABLE FRIENDSLIST
(
    UserID NUMBER(3),
    FriendID Number(3),

    CONSTRAINT PK_FriendsList
    PRIMARY KEY (UserID, FriendID),

    CONSTRAINT FK_FriendsList_User
    FOREIGN KEY (UserID)
    REFERENCES
    UserBase(UserID),

    CONSTRAINT 
    FK_FriendsList_Friend
    FOREIGN KEY (FriendID)
    REFERENCES
    UserBase(UserID)
);
-- Sample Date
INSERT INTO FriendsList VALUES (101,102);
INSERT INTO FriendsList VALUES (101,103);
INSERT INTO FriendsList VALUES (102,101);
INSERT INTO FriendsList VALUES (103,104);
INSERT INTO FriendsList VALUES (104,105);
INSERT INTO FriendsList VALUES (105,106);
INSERT INTO FriendsList VALUES (106,107);
INSERT INTO FriendsList VALUES (107,108);
INSERT INTO FriendsList VALUES (108,109);
INSERT INTO FriendsList VALUES (109,110);
INSERT INTO FriendsList VALUES (110,111);
INSERT INTO FriendsList VALUES (111,112);

-- 4 Create WISHLIST TABLE

CREATE TABLE WISHLIST
(
    UserId NUMBER(3),
    ProductCode varchar2(5),
    Position NUMBER(3),

    CONSTRAINT PK_WishList
    PRIMARY KEY (UserID, ProductCode),

    CONSTRAINT
    FK_WishList_User
    FOREIGN KEY (UserID)
    REFERENCES UserBase(UserID),

    CONSTRAINT FK_WishList_Product
    FOREIGN KEY (ProductCode)
    REFERENCES ProductList(ProductCode)
);
-- Sample Data
INSERT INTO WishList VALUES (101,'GAME1',1);
INSERT INTO WishList VALUES (101,'GAME2',2);
INSERT INTO WishList VALUES (102,'GAME3',1);
INSERT INTO WishList VALUES (103,'GAME4',1);
INSERT INTO WishList VALUES (104,'GAME5',1);
INSERT INTO WishList VALUES (105,'GAME6',1);
INSERT INTO WishList VALUES (106,'GAME7',1);
INSERT INTO WishList VALUES (107,'GAME8',1);
INSERT INTO WishList VALUES (108,'GAME9',1);
INSERT INTO WishList VALUES (109,'RPG10',1);
INSERT INTO WishList VALUES (110,'PZL11',1);
INSERT INTO WishList VALUES (111,'GME12',1);

-- 5 Create USERPROFILE Table
CREATE TABLE USERPROFILE
(
    UserID NUMBER(3),
    ImageFile varchar2(250),
    Description varchar2(250),

    CONSTRAINT PK_UserProfile
    PRIMARY KEY (UserID),

    CONSTRAINT FK_UserProfile_User
    FOREIGN KEY (UserID)
    REFERENCES
    UserBase(UserID)
);

-- Sample Data 
INSERT INTO UserProfile VALUES (101,'images/ashley.jpg','Competitive RPG player.');
INSERT INTO UserProfile VALUES (102,'images/isabel.jpg','Enjoys indie games.');
INSERT INTO UserProfile VALUES (103,'images/gavin.jpg','Achievement hunter.');
INSERT INTO UserProfile VALUES (104,'images/carey.jpg','Casual gamer.');
INSERT INTO UserProfile VALUES (105,'images/matthew.jpg','Strategy game fan.');
INSERT INTO UserProfile VALUES (106,'images/alex.jpg','Multiplayer enthusiast.');
INSERT INTO UserProfile VALUES (107,'images/michael.jpg','Action game player.');
INSERT INTO UserProfile VALUES (108,'images/sean.jpg','Loves co-op games.');
INSERT INTO UserProfile VALUES (109,'images/ellie.jpg','Adventure gamer.');
INSERT INTO UserProfile VALUES (110,'images/marcus.jpg','Collector.');
INSERT INTO UserProfile VALUES (111,'images/brian.jpg','FPS specialist.');
INSERT INTO UserProfile VALUES (112,'images/veronica.jpg','Visual novel fan.');

-- 6 Create SECURITYQUESTION TABLE

CREATE TABLE SECURITYQUESTION
(
    QuestionID NUMBER,
    UserID NUMBER(3),
    Question varchar2(250),
    Answer varchar2(250),

    CONSTRAINT PK_SecurityQuestion 
    PRIMARY KEY (QuestionID),

    CONSTRAINT FK_SecurityQuestion_User
    FOREIGN KEY (UserID)
    REFERENCES
    UserBase(UserID)
);

-- Sample Data
INSERT INTO SecurityQuestion VALUES (1,101,'What was your first pet''s name?','Max');
INSERT INTO SecurityQuestion VALUES (2,102,'What city were you born in?','Boston');
INSERT INTO SecurityQuestion VALUES (3,103,'What was your first school?','Lincoln');
INSERT INTO SecurityQuestion VALUES (4,104,'What is your favorite game?','GAME7');
INSERT INTO SecurityQuestion VALUES (5,105,'What is your favorite food?','Pizza');
INSERT INTO SecurityQuestion VALUES (6,106,'What was your first car?','Honda');
INSERT INTO SecurityQuestion VALUES (7,107,'What is your dream job?','Developer');
INSERT INTO SecurityQuestion VALUES (8,108,'Who was your favorite teacher?','Smith');
INSERT INTO SecurityQuestion VALUES (9,109,'What is your favorite movie?','Avatar');
INSERT INTO SecurityQuestion VALUES (10,110,'What color was your first bicycle?','Blue');
INSERT INTO SecurityQuestion VALUES (11,111,'What is your favorite sport?','Soccer');
INSERT INTO SecurityQuestion VALUES (12,112,'What is your best friend''s name?','Alex');

-- 7 Create COMMUNITYRULES Table
CREATE TABLE COMMUNITYRULES
(
    RuleNum NUMBER(3),
    Title varchar2(250),
    Description varchar2(250),
    SeverityPoint Number(4),

    CONSTRAINT PK_CommunityRules
    PRIMARY KEY (RuleNum)
);

-- Sample Data
INSERT INTO CommunityRules VALUES (1,'Respect','Treat all users respectfully.',100);
INSERT INTO CommunityRules VALUES (2,'Harassment','No harassment allowed.',400);
INSERT INTO CommunityRules VALUES (3,'Spam','No spam messages.',150);
INSERT INTO CommunityRules VALUES (4,'Cheating','No cheating or exploits.',500);
INSERT INTO CommunityRules VALUES (5,'Offensive Content','No offensive language.',350);
INSERT INTO CommunityRules VALUES (6,'Advertising','No unauthorized advertising.',200);
INSERT INTO CommunityRules VALUES (7,'Impersonation','No impersonating users.',450);
INSERT INTO CommunityRules VALUES (8,'Threats','No threats.',600);
INSERT INTO CommunityRules VALUES (9,'Scams','No scams.',700);
INSERT INTO CommunityRules VALUES (10,'Privacy','Protect user privacy.',550);
INSERT INTO CommunityRules VALUES (11,'Account Sharing','No account sharing.',300);
INSERT INTO CommunityRules VALUES (12,'Appropriate Content','Use appropriate content.',250);

-- 8 Create INFRACTIONS Table
CREATE TABLE INFRACTIONS
(
    InfractionID Number,
    UserID Number(3),
    RuleNum Number(3),
    DateAssigned DATE,
    Penalty varchar2(250),

    CONSTRAINT PK_Infractions
    PRIMARY KEY (InfractionID),

    CONSTRAINT 
    FK_Infractions_User
    FOREIGN KEY (UserID)
    REFERENCES
    UserBase(UserID),

    CONSTRAINT
    FK_Infractions_Rule
    FOREIGN KEY (RuleNum)
    REFERENCES
    CommunityRules(RuleNum)
);

-- Sample Data
INSERT INTO Infractions VALUES (1,107,3,SYSDATE-60,'Warning');
INSERT INTO Infractions VALUES (2,112,5,SYSDATE-58,'24 Hour Suspension');
INSERT INTO Infractions VALUES (3,104,2,SYSDATE-55,'3 Day Suspension');
INSERT INTO Infractions VALUES (4,101,1,SYSDATE-53,'Warning');
INSERT INTO Infractions VALUES (5,109,4,SYSDATE-50,'Permanent Ban');
INSERT INTO Infractions VALUES (6,103,6,SYSDATE-47,'Warning');
INSERT INTO Infractions VALUES (7,105,7,SYSDATE-42,'7 Day Suspension');
INSERT INTO Infractions VALUES (8,110,8,SYSDATE-40,'Permanent Ban');
INSERT INTO Infractions VALUES (9,102,10,SYSDATE-38,'Warning');
INSERT INTO Infractions VALUES (10,106,11,SYSDATE-35,'Warning');
INSERT INTO Infractions VALUES (11,111,12,SYSDATE-30,'Content Removed');
INSERT INTO Infractions VALUES (12,108,9,SYSDATE-25,'Permanent Ban');

-- 9 Create USERSUPPORT Table

CREATE TABLE USERSUPPORT 
(
    TicketID NUMBER,
    Email varchar2(250),
    Issue varchar2(250),
    DateSubmitted DATE,
    DateUpdated DATE,
    Status varchar2(250),

    CONSTRAINT PK_UserSupport
    PRIMARY KEY (TicketID)
);

-- Sample ID
INSERT INTO UserSupport VALUES (1,'Doherty@gmail.com','Cannot login',SYSDATE-10,SYSDATE-8,'NEW');
INSERT INTO UserSupport VALUES (2,'Isabel.Cooper@gmail.com','Payment error',SYSDATE-9,SYSDATE-5,'IN PROGRESS');
INSERT INTO UserSupport VALUES (3,'92Gavin@yahoo.com','Missing game',SYSDATE-8,SYSDATE-7,'CLOSED');
INSERT INTO UserSupport VALUES (4,'CoolGuy@gmail.com','Account recovery',SYSDATE-7,SYSDATE-6,'NEW');
INSERT INTO UserSupport VALUES (5,'MattWilson@yahoo.com','Profile issue',SYSDATE-6,SYSDATE-4,'IN PROGRESS');
INSERT INTO UserSupport VALUES (6,'AlexanderKingston@gmail.com','Chat problem',SYSDATE-5,SYSDATE-3,'CLOSED');
INSERT INTO UserSupport VALUES (7,'Smith.Smith2@gmail.com','Friend list issue',SYSDATE-4,SYSDATE-2,'NEW');
INSERT INTO UserSupport VALUES (8,'SSmith@gmail.com','Refund request',SYSDATE-3,SYSDATE-1,'IN PROGRESS');
INSERT INTO UserSupport VALUES (9,'EllieJo@gmail.com','Wishlist bug',SYSDATE-2,SYSDATE-1,'CLOSED');
INSERT INTO UserSupport VALUES (10,'GreenM@gmail.com','Password reset',SYSDATE-1,SYSDATE,'NEW');
INSERT INTO UserSupport VALUES (11,'BrianKim1998@gmail.com','Download issue',SYSDATE-12,SYSDATE-11,'IN PROGRESS');
INSERT INTO UserSupport VALUES (12,'RonyBrooks@gmail.com','Billing inquiry',SYSDATE-13,SYSDATE-10,'NEW');

-- 10 Create Required Views

-- View 1: Unique Security Questions
CREATE OR REPLACE VIEW
VW_SECURITYQUESTIONS
AS
SELECT DISTINCT Question
FROM SecurityQuestion;

-- View 2: Active Support Tickets
CREATE OR REPLACE VIEW
VW_ACTIVESUPPORT
AS
SELECT
    TicketID,
    Email,
    Issue,
    DateUpdated
FROM UserSupport
WHERE Status IN ('NEW', 'IN PROGRESS')
ORDER BY DateUpdated;

COMMIT;