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


--Create COMMUNICATION_LOG, EMPLOYEES, and IT_SERVICE_TICKETS tables.
CREATE TABLE employees_proj (
    employeeID NUMBER PRIMARY KEY,
    firstName VARCHAR2(50) NOT NULL,
    middleName VARCHAR2(50) NULL,
    lastName VARCHAR2(50) NOT NULL,
    hireDate DATE NOT NULL,
    emailAddress VARCHAR2(100) UNIQUE,
    phoneNumber VARCHAR2(20),
    jobTitle VARCHAR2(50),
    salary NUMBER(10,2),
    bonus NUMBER(10,2),
    siteID NUMBER,
    departmentID NUMBER
);

-- FK Constraints employees_proj
ALTER TABLE employees_proj
ADD CONSTRAINT fk_site
FOREIGN KEY (siteID) 
REFERENCES company_sites(siteID),

ALTER TABLE employees_proj
CONSTRAINT fk_department
FOREIGN KEY (departmentID) 
REFERENCES departments(departmentID)


CREATE TABLE it_service_tickets (
    ticketID NUMBER PRIMARY KEY,
    serviceIssues VARCHAR2(255),
    status VARCHAR2(50),
    userID NUMBER NOT NULL,
    employeeID NUMBER NULL
    );
    
-- FK Constraints it_service_tickets
ALTER TABLE it_service_tickets
CONSTRAINT fk_ticket_employee
FOREIGN KEY (employeeID) 
REFERENCES employees_proj(employeeID)

ALTER TABLE it_service_tickets
CONSTRAINT fk_ticket_user
FOREIGN KEY (userID)
REFERENCES users(userID),


CREATE TABLE communication_log (
    logID NUMBER PRIMARY KEY,
    messageHistory VARCHAR2(500),
    ticketID NUMBER NOT NULL
);

-- FK Constraints communication_log
ALTER TABLE communication_log
CONSTRAINT fk_log_ticket
FOREIGN KEY (ticketID)
REFERENCES it_service_tickets(ticketID)


--Insert Statements for Employees, IT Service Ticekts and Communication Log
INSERT INTO employees_proj 
    (employeeID, firstName, middleName, lastName, hireDate, emailAddress, phoneNumber, jobTitle, salary, bonus, siteID, departmentID)
VALUES (
    1, 'Chris', 'A', 'Pine', TO_DATE('2022-05-10','YYYY-MM-DD'), 'chris.pine@email.com', '123-456-7890', 'IT Support', 60000, 5000, 1, 10);

INSERT INTO employees_proj (
    employeeID, firstName, middleName, lastName, hireDate, emailAddress, phoneNumber, jobTitle, salary, bonus, siteID, departmentID)
VALUES ( 
    2, 'Julia', NULL, 'Smith', TO_DATE('2021-03-15','YYYY-MM-DD'), 'julia.smith@email.com', '987-654-3210','Engineer', 80000, 7000, 2, 20
);

INSERT INTO it_service_tickets 
    (ticketID, serviceIssues, status, userID, employeeID)
VALUES (
    1, 'Can''t login into my account.', 'In Progress', 3, 2
);

INSERT INTO it_service_tickets 
    (ticketID, serviceIssues, status, userID, employeeID)
VALUES (
    2, 'My password is incorrect.', 'Resolved', 2, 1
);

INSERT INTO communication_log (logID, messageHistory, ticketID)
    VALUES ( 101, 'User cannot login.', 1);

INSERT INTO communication_log (logID, messageHistory, ticketID, employeeID, userID)
    VALUES (102, 'Password was reset.', 2, 1, 2);