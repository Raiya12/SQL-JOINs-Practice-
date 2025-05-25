Use JobRecruitment
-------------------------------------------------------------------------------
-- Company table
CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY,
    Name VARCHAR(100),
    Industry VARCHAR(50),
    City VARCHAR(50)
);

-- Job Seekers
CREATE TABLE JobSeekers (
    SeekerID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    ExperienceYears INT,
    City VARCHAR(50)
);

-- Job Postings
CREATE TABLE Jobs (
    JobID INT PRIMARY KEY,
    Title VARCHAR(100),
    CompanyID INT,
    Salary DECIMAL(10, 2),
    Location VARCHAR(50),
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

-- Applications
CREATE TABLE Applications (
    AppID INT PRIMARY KEY,
    JobID INT,
    SeekerID INT,
    ApplicationDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (SeekerID) REFERENCES JobSeekers(SeekerID)
);

-------------------------------------------------------------------------
-- Companies
INSERT INTO Companies VALUES
(1, 'TechWave', 'IT', 'Muscat'),
(2, 'GreenEnergy', 'Energy', 'Sohar'),
(3, 'EduBridge', 'Education', 'Salalah');

-- Job Seekers
INSERT INTO JobSeekers VALUES
(101, 'Sara Al Busaidi', 'sara.b@example.com', 2, 'Muscat'),
(102, 'Ahmed Al Hinai', 'ahmed.h@example.com', 5, 'Nizwa'),
(103, 'Mona Al Zadjali', 'mona.z@example.com', 1, 'Salalah'),
(104, 'Hassan Al Lawati', 'hassan.l@example.com', 3, 'Muscat');

-- Jobs
INSERT INTO Jobs VALUES
(201, 'Software Developer', 1, 900, 'Muscat'),
(202, 'Data Analyst', 1, 800, 'Muscat'),
(203, 'Science Teacher', 3, 700, 'Salalah'),
(204, 'Field Engineer', 2, 950, 'Sohar');

-- Applications
INSERT INTO Applications VALUES
(301, 201, 101, '2025-05-01', 'Pending'),
(302, 202, 104, '2025-05-02', 'Shortlisted'),
(303, 203, 103, '2025-05-03', 'Rejected'),
(304, 204, 102, '2025-05-04', 'Pending');

-- Task 1: Show each applicant’s full name, the job title they applied for, and the company name. Only include applicants who have actually applied.
--➡ Use INNER JOIN. 
SELECT js.FullName AS applicant_name, j.Title AS job_title, c.Name AS company_name
FROM Applications a
INNER JOIN JobSeekers js ON a.SeekerID = js.SeekerID
INNER JOIN Jobs j ON a.JobID = j.JobID
INNER JOIN Companies c ON j.CompanyID = c.CompanyID;

-- Task 2: Show all job titles and their company names, even if nobody has applied to them yet. 
--➡ Use LEFT JOIN from Jobs → Applications. 
SELECT j.Title AS job_title, c.Name AS company_name
FROM Jobs j
LEFT JOIN Applications a ON j.JobID = a.JobID
INNER JOIN Companies c ON j.CompanyID = c.CompanyID;

--Task 3:Find job seekers who applied to jobs in their own city. Display job seeker name, job title, and matching city. 
--➡ Use JOIN with matching condition on seeker.City = job.Location. 
SELECT js.FullName AS seeker_name, j.Title AS job_title, js.City AS matching_city
FROM Applications a
INNER JOIN JobSeekers js ON a.SeekerID = js.SeekerID
INNER JOIN Jobs j ON a.JobID = j.JobID
WHERE js.City = j.Location;

--Task 4:List all job seekers and, if available, the job titles they applied to. Show job seeker name, job title (if any), and application status (can be NULL). 
--➡ Use LEFT JOIN from JobSeekers → Applications → Jobs. 
SELECT js.FullName AS seeker_name, j.Title AS job_title, a.Status AS application_status
FROM JobSeekers js
LEFT JOIN Applications a ON js.SeekerID = a.SeekerID
LEFT JOIN Jobs j ON a.JobID = j.JobID;