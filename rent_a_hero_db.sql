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

--JOBS TABLE
CREATE TABLE jobs
(
  jobID NUMBER PRIMARY KEY,
  status VARCHAR2(50) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  timestamp TIMESTAMP NOT NULL,
  created_by_userID NUMBER REFERENCES users(userID),
  accepted_by_contractorID NUMBER REFERENCES contractors(contractorID)
);

--RATINGS TABLE
CREATE TABLE ratings
(
  ratingID NUMBER UNIQUE PRIMARY KEY,
  rating_score NUMBER NOT NULL,
  date_written DATE NOT NULL,
  comments VARCHAR2(255),
  contractorID NUMBER REFERENCES contractors(contractorID),
  userID NUMBER REFERENCES users(userID),
  jobID NUMBER REFERENCES jobs(jobID)
);

--Drop table statements for testing
--DROP TABLE jobs;
--DROP TABLE ratings;

--Indexing for jobs and ratings
CREATE INDEX rating_score_index ON ratings(rating_score);

--Drop index statements for testing
--DROP INDEX rating_score_index;

--Insert statements
INSERT INTO jobs
(jobID, status, description, timestamp, created_by_userID, accepted_by_contractorID)
VALUES(1, 'OPEN', 'Defeat Villian 1', CURRENT_TIMESTAMP, 70001234, 1001);

INSERT INTO jobs
(jobID, status, description, timestamp, created_by_userID, accepted_by_contractorID)
VALUES(2, 'ASSIGNED', 'Defeat Villian 2', CURRENT_TIMESTAMP, 70001235, 1002);

INSERT INTO ratings
(ratingID, rating_score, date_written, comments, contractorID, userID, jobID)
VALUES(1, 5, SYSDATE, 'Excellent work', 1001, 70001234, 1);

INSERT INTO ratings
(ratingID, rating_score, date_written, comments, contractorID, userID, jobID)
VALUES(1, 4, SYSDATE, 'Good work', 1002, 70001235, 2);

-- Summary queries
SELECT 
  c.contractorID,
  AVG(r.rating_score) AS avg_rating,
  COUNT(r.ratingID) AS total_reviews
FROM contractors c
JOIN ratings r ON c.contractorID = r.contractorID
GROUP BY c.contractorID;

SELECT 
  u.userID,
  COUNT(j.jobID) AS total_jobs_posted,
  AVG(r.rating_score) AS avg_job_rating
FROM users u
JOIN jobs j ON u.userID = j.created_by_userID
LEFT JOIN ratings r ON j.jobID = r.jobID
GROUP BY u.userID;
