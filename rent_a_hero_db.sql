/*
CIS 4331
Rent a Hero Database
Zachary Sonntag, Joey Huang, Adam Marx, Sofia Borukhovich
*/

--USERS Table
CREATE TABLE users
(   userID NUMBER NOT NULL,
firstname CHAR(20) NOT NULL,
lastname CHAR(20) NOT NULL,
userpassword VARCHAR2(50) NOT NULL,
emailaddress VARCHAR2(50) NOT NULL,
phonenumber VARCHAR2(15) NOT NULL,
dateofbirth DATE NOT NULL,
paymentinformation VARCHAR(50) NOT NULL,
middlename CHAR(20),
refferedbyemployeeID NUMBER NOT NULL,
PRIMARY KEY (userID),
FOREIGN KEY (refferedbyemployeeID) REFERENCES employees
);

--CONTRACTORS Table
CREATE TABLE contractors
(   contractorID NUMBER NOT NULL,
servicelocation VARCHAR2(50) NOT NULL,
accountbio VARCHAR2(50) NOT NULL,
rate NUMBER NOT NULL,
userID NUMBER NOT NULL,
PRIMARY KEY (contractorID),
FOREIGN KEY (userID) REFERENCES users
);

--CONTRACTORS_SKILLS
CREATE TABLE contractors_skills
(   contractorID NUMBER NOT NULL,
skill VARCHAR2(50) NOT NULL,
PRIMARY KEY (contractorID, skill),
FOREIGN KEY (contractorID) REFERENCES contractors
);