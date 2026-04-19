/*
CIS 4331 Principles of Database Systems
Rent a Hero Database
Zachary Sonntag, Joey Huang, Adam Marx, Sofia Borukhovich
*/

--USERS Table
CREATE TABLE app_users
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
CONSTRAINT users_email_uq
    UNIQUE(emailaddress)
);

--CONTRACTORS Table
CREATE TABLE contractors
(   contractorID NUMBER NOT NULL,
servicelocation VARCHAR2(50) NOT NULL,
accountbio VARCHAR2(200) NOT NULL,
rate NUMBER NOT NULL,
userID NUMBER NOT NULL UNIQUE,
CONSTRAINT contractors_pk
    PRIMARY KEY (contractorID)
CONSTRAINT contractors_userid_uq
    UNIQUE(userID)
);

--CONTRACTORS_SKILLS
CREATE TABLE contractors_skills
(   contractorID NUMBER NOT NULL,
skill VARCHAR2(50) NOT NULL,
CONSTRAINT contractors_skills_pk
    PRIMARY KEY (contractorID, skill)
);
    

--JOBS TABLE
CREATE TABLE jobs
(
  jobID NUMBER PRIMARY KEY,
  status VARCHAR2(50) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  timestamp TIMESTAMP NOT NULL,
  created_by_userID NUMBER,
  accepted_by_contractorID NUMBER
);

--RATINGS TABLE
CREATE TABLE ratings
(
  ratingID NUMBER UNIQUE PRIMARY KEY,
  rating_score NUMBER NOT NULL,
  date_written DATE NOT NULL,
  comments VARCHAR2(255),
  contractorID NUMBER,
  userID NUMBER,
  jobID NUMBER
);

--Indexing for jobs and ratings
CREATE INDEX rating_score_index ON ratings(rating_score);


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

-- -- FK Constraints employees_proj
-- ALTER TABLE employees_proj
-- ADD CONSTRAINT fk_site
-- FOREIGN KEY (siteID) 
-- REFERENCES company_sites(siteID),

-- ALTER TABLE employees_proj
-- CONSTRAINT fk_department
-- FOREIGN KEY (departmentID) 
-- REFERENCES departments(departmentID)


CREATE TABLE it_service_tickets (
    ticketID NUMBER PRIMARY KEY,
    serviceIssues VARCHAR2(255),
    status VARCHAR2(50),
    userID NUMBER NOT NULL,
    employeeID NUMBER NULL
    );
    
-- FK Constraints it_service_tickets
-- ALTER TABLE it_service_tickets
-- CONSTRAINT fk_ticket_employee
-- FOREIGN KEY (employeeID) 
-- REFERENCES employees_proj(employeeID)

-- ALTER TABLE it_service_tickets
-- CONSTRAINT fk_ticket_user
-- FOREIGN KEY (userID)
-- REFERENCES users(userID),


CREATE TABLE communication_log (
    logID NUMBER PRIMARY KEY,
    messageHistory VARCHAR2(500),
    ticketID NUMBER NOT NULL
);

-- -- FK Constraints communication_log
-- ALTER TABLE communication_log
-- CONSTRAINT fk_log_ticket
-- FOREIGN KEY (ticketID)
-- REFERENCES it_service_tickets(ticketID)

--Indexing for users and contractors
CREATE INDEX userlastname_index ON app_users(lastname);
CREATE INDEX contractorlocation_index ON contractors(servicelocation);
CREATE INDEX useremail_index ON app_users(emailaddress);
CREATE INDEX contractoruseris_index ON contractors(userID);

--Sequences for tables
CREATE SEQUENCE USERS_ID_SEQ
    START WITH 70001234;
CREATE SEQUENCE CONTRACTORS_ID_SEQ
    START WITH 1001;

--CONSULTANTS Table
CREATE TABLE consultants
(   consultantID NUMBER NOT NULL UNIQUE,
    firstName CHAR(20) NOT NULL,
    lastName CHAR(20) NOT NULL,
    startDate DATE NOT NULL,
    emailAddress VARCHAR2(254) NOT NULL,
    workNumber INT NOT NULL,
    senority INT NOT NULL,
    departmentID NUMBER NOT NULL UNIQUE,
    siteID NUMBER UNIQUE,
    employeeID NUMBER UNIQUE,
    CONSTRAINT consultants_pk
        PRIMARY KEY (consultantID),
);

--COMPANY_SITES Table
CREATE TABLE company_sites
(   siteID NUMBER NOT NULL UNIQUE,
    siteName VARCHAR2(100) NOT NULL,
    street VARCHAR2(50) NOT NULL,
    city VARCHAR2(100) NOT NULL,
    state VARCHAR2(100) NOT NULL,
    country VARCHAR2(100) NOT NULL,
    siteType VARCHAR2(50),
    sitePhoneNumber VARCHAR2(20),
    employeesCount NUMBER,
    consultantsCount NUMBER,
    CONSTRAINT company_sites_pk
        PRIMARY KEY (siteID)
);

--DEPARTMENTS Table
CREATE TABLE departments
(   departmentID NUMBER NOT NULL UNIQUE,
    departmentName VARCHAR2(100) NOT NULL,
    managedByEmployeeID NUMBER NOT NULL UNIQUE,
    siteID NUMBER UNIQUE,
    CONSTRAINT departments_pk
        PRIMARY KEY (departmentID),
);

--Indexing for consultants
CREATE INDEX consultantlastname_index ON consultants(lastname);
CREATE INDEX consultantemail_index ON consultants(emailAddress);

-- COMPANY_SITES sequence
CREATE SEQUENCE company_sites_id_seq
    START WITH 0
    INCREMENT BY 1;

-- DEPARTMENTS sequence
CREATE SEQUENCE departments_id_seq
    START WITH 0
    INCREMENT BY 1;

-- CONSULTANTS sequence
CREATE SEQUENCE consultants_id_seq
    START WITH 0
    INCREMENT BY 1;


-- FOREIGN KEY CONSTRAINTS ------------------------------------------------
-- app_users
ALTER TABLE app_users
ADD CONSTRAINT users_fk_employees
FOREIGN KEY (refferedbyemployeeID)
REFERENCES employees_proj(employeeID);

-- contractors
ALTER TABLE contractors
ADD CONSTRAINT contractors_fk_users
FOREIGN KEY (userID)
REFERENCES app_users(userID);

-- contractors_skills
ALTER TABLE contractors_skills
ADD CONSTRAINT contractors_skills_fk_contractors
FOREIGN KEY (contractorID)
REFERENCES contractors(contractorID);

-- jobs (created_by_userID)
ALTER TABLE jobs
ADD CONSTRAINT jobs_fk_users
FOREIGN KEY (created_by_userID)
REFERENCES app_users(userID);

-- jobs (accepted_by_contractorID)
ALTER TABLE jobs
ADD CONSTRAINT jobs_fk_contractors
FOREIGN KEY (accepted_by_contractorID)
REFERENCES contractors(contractorID);

-- ratings (contractor)
ALTER TABLE ratings
ADD CONSTRAINT ratings_fk_contractors
FOREIGN KEY (contractorID)
REFERENCES contractors(contractorID);

-- ratings (user)
ALTER TABLE ratings
ADD CONSTRAINT ratings_fk_users
FOREIGN KEY (userID)
REFERENCES app_users(userID);

-- ratings (job)
ALTER TABLE ratings
ADD CONSTRAINT ratings_fk_jobs
FOREIGN KEY (jobID)
REFERENCES jobs(jobID);

-- employees_proj (site)
ALTER TABLE employees_proj
ADD CONSTRAINT fk_site
FOREIGN KEY (siteID)
REFERENCES company_sites(siteID);

-- employees_proj (department)
ALTER TABLE employees_proj
ADD CONSTRAINT fk_department
FOREIGN KEY (departmentID)
REFERENCES departments(departmentID);

-- it_service_tickets (user)
ALTER TABLE it_service_tickets
ADD CONSTRAINT fk_ticket_user
FOREIGN KEY (userID)
REFERENCES app_users(userID);

-- it_service_tickets (employee)
ALTER TABLE it_service_tickets
ADD CONSTRAINT fk_ticket_employee
FOREIGN KEY (employeeID)
REFERENCES employees_proj(employeeID);

-- communication_log
ALTER TABLE communication_log
ADD CONSTRAINT fk_log_ticket
FOREIGN KEY (ticketID)
REFERENCES it_service_tickets(ticketID);

-- consultants
ALTER TABLE consultants
ADD CONSTRAINT fk_consult_employee
FOREIGN KEY (employeeID)
REFERENCES employees_proj(employeeID);
-------------------------------------------------------------------------

--Insert statements
INSERT INTO APP_USERS
    (userID, firstname, lastname, userpassword, 
    emailaddress, phonenumber, dateofbirth, paymentinformation,
    middlename, refferedbyemployeeID) 
VALUES(USER_ID_SEQ.NEXTVAL, 'Bruce', 'Wayne', 'L0v3Alffy', 
    'thedarkknight@hotmail.com', '215-440-1605', '02/19/1990', 'Wayne Enterprises', 'Thomas', 3);
    
INSERT INTO APP_USERS
    (userID, firstname, lastname, userpassword, 
    emailaddress, phonenumber, dateofbirth, paymentinformation,
    middlename, refferedbyemployeeID) 
VALUES(USER_ID_SEQ.NEXTVAL, 'Geoke', 'Ur', 'G0th@mi$min3!', 
    'bAtMaNsAvEuS@aol.com', '333-222-1111', '07/11/1991', 'Gotham Bank', null, null);

INSERT INTO APP_USERS
    (userID, firstname, lastname, userpassword, 
    emailaddress, phonenumber, dateofbirth, paymentinformation,
    middlename, refferedbyemployeeID) 
VALUES(USER_ID_SEQ.NEXTVAL, 'Clark', 'Kent', 'Lois0817<3', 
    'manofsteel@yahoo.com', '531-235-6795', '02/29/1985', 'Wayne Enterprises', 'Thomas', 3);

INSERT INTO CONTRACTORS 
    (contractorID, servicelocation, accountbio, rate, userID)
VALUES(CONTRACTORS_ID_SEQ.NEXTVAL, 'Gotham City', 
    'I seek the means to fight injustice, to turn fear against those who prey on the fearful.',
    20, (SELECT USERID
    FROM APP_USERS
    WHERE EMAILADDRESS = 'thedarkknight@hotmail.com'));

INSERT INTO CONTRACTORS
    (contractorID, servicelocation, accountbio, rate, userID)
VALUES(CONTRACTORS_ID_SEQ.NEXTVAL, 'Earth', 
    'Dreams save us... Ill never stop fighting.',
    0, (SELECT USERID
    FROM APP_USERS
    WHERE EMAILADDRESS = 'manofsteel@yahoo.com'));
    
INSERT INTO CONTRACTORS_SKILLS 
    (contractorID, skill)
VALUES(1001, 'Martial Arts');

INSERT INTO CONTRACTORS_SKILLS
    (contractorID, skill)
VALUES(1002, 'Ability to fly');

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


INSERT INTO company_sites
    (siteID, siteName, street, city, state, country, siteType, sitePhoneNumber, employeesCount, consultantsCount)
    VALUES
    (1, 'Gotham HQ', '100 Wayne St', 'Gotham', 'NJ', 'USA', 'Headquarters', '215-111-1111', 50, 5);

INSERT INTO company_sites
    (siteID, siteName, street, city, state, country, siteType, sitePhoneNumber, employeesCount, consultantsCount)
    VALUES
    (2, 'Metropolis Branch', '200 Daily Planet Ave', 'Metropolis', 'NY', 'USA', 'Branch', '212-222-2222', 40, 3);

INSERT INTO departments
    (departmentID, departmentName, managedByEmployeeID, siteID)
    VALUES
    (10, 'IT Support', 1, 1);

INSERT INTO departments
    (departmentID, departmentName, managedByEmployeeID, siteID)
    VALUES
    (20, 'Engineering', 2, 2);

INSERT INTO consultants
    (consultantID, firstName, lastName, startDate, emailAddress, workNumber, senority, departmentID, siteID, employeeID)
    VALUES
    (1, 'Tony', 'Stark', TO_DATE('2023-01-10','YYYY-MM-DD'), 'tony.stark@avengers.com', 1111111, 10, 10, 1, 1);

INSERT INTO consultants
    (consultantID, firstName, lastName, startDate, emailAddress, workNumber, senority, departmentID, siteID, employeeID)
    VALUES
    (2, 'Diana', 'Prince', TO_DATE('2022-06-15','YYYY-MM-DD'), 'diana.prince@justiceleague.com', 2222222, 8, 20, 2, 2);

    
--Drop table statements for testing

--DROP TABLE app_users;
--DROP TABLE contractors;
--DROP TABLE contractors_skills;
--DROP TABLE jobs;
--DROP TABLE ratings;


--Drop index statements for testing

--DROP INDEX userlastname_index ON users(lastname);
--DROP INDEX contractorlocation_index ON contractors(servicelocation);
--DROP INDEX rating_score_index;


--Drop sequence statements for testing

--DROP SEQUENCE IF EXISTS USERS_ID_SEQ;
--DROP SEQUENCE IF EXISTS CONTRACTORS_ID_SEQ;

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