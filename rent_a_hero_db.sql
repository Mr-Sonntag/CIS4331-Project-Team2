/*
CIS 4331 Principles of Database Systems
Rent a Hero Database
Zachary Sonntag, Joey Huang, Adam Marx, Sofia Borukhovich
*/

--USERS Table
CREATE TABLE users
(   userID NUMBER NOT NULL,
firstname CHAR(20) NOT NULL,
lastname CHAR(20) NOT NULL,
userpassword VARCHAR2(50) NOT NULL,
emailaddress VARCHAR2(50) NOT NULL UNIQUE,
phonenumber VARCHAR2(15) NOT NULL,
dateofbirth DATE NOT NULL,
paymentinformation VARCHAR(50) NOT NULL,
middlename CHAR(20),
refferedbyemployeeID NUMBER,
CONSTRAINT users_pk
    PRIMARY KEY (userID),
CONSTRAINT users_fk_employees
    FOREIGN KEY (refferedbyemployeeID)
        REFERENCES employees,
CONSTRAINT users_email_uq
    UNIQUE(emailaddress)
);


--CONTRACTORS Table
CREATE TABLE contractors
(   contractorID NUMBER NOT NULL,
servicelocation VARCHAR2(50) NOT NULL,
accountbio VARCHAR2(50) NOT NULL,
rate NUMBER NOT NULL,
userID NUMBER NOT NULL UNIQUE,
CONSTRAINT contractors_pk
    PRIMARY KEY (contractorID),
CONSTRAINT contractors_fk_users
    FOREIGN KEY (userID) 
        REFERENCES users,
CONSTRAINT contractors_userid_uq
    UNIQUE(userID)
);

--CONTRACTORS_SKILLS
CREATE TABLE contractors_skills
(   contractorID NUMBER NOT NULL,
skill VARCHAR2(50) NOT NULL,
CONSTRAINT contractors_skills_pk
    PRIMARY KEY (contractorID, skill),
CONSTRAINT contractors_skills_fk_contractors
    FOREIGN KEY (contractorID) 
        REFERENCES contractors
);


--Drop table statements for testing
--DROP TABLE users;
--DROP TABLE contractors;
--DROP TABLE contractors_skills;

--Indexing for users and contractors
CREATE INDEX userlastname_index ON users(lastname);
CREATE INDEX contractorlocation_index ON contractors(servicelocation);
CREATE INDEX useremail_index ON users(emailaddress);
CREATE INDEX contractoruseris_index ON contractors(userID);

--Drop index statements for testing
--DROP INDEX userlastname_index ON users(lastname);
--DROP INDEX contractorlocation_index ON contractors(servicelocation);

--Sequences for tables
CREATE SEQUENCE USERS_ID_SEQ
    START WITH 70001234;
CREATE SEQUENCE CONTRACTORS_ID_SEQ
    START WITH 1001;
    
--Drop sequence statements for testing
--DROP SEQUENCE IF EXISTS USERS_ID_SEQ;
--DROP SEQUENCE IF EXISTS CONTRACTORS_ID_SEQ;

--Insert statements
INSERT INTO USERS
VALUES();
INSERT INTO USERS
VALUES();
INSERT INTO CONTRACTORS
VALUES();
INSERT INTO CONTRACTORS
VALUES();
INSERT INTO CONTRACTORS_SKILLS
VALUES();
INSERT INTO CONTRACTORS_SKILLS
VALUES();