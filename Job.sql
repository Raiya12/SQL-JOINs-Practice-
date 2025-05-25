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

--Task 5:Show each job title with the name of the job seeker who applied (if any). If no one applied, still show the job title. 
--➡ Use LEFT JOIN from Jobs → Applications → JobSeekers.
SELECT j.Title AS job_title, js.FullName AS seeker_name
FROM Jobs j
LEFT JOIN Applications a ON j.JobID = a.JobID
LEFT JOIN JobSeekers js ON a.SeekerID = js.SeekerID;

--Task 6:Find the names and emails of job seekers who haven’t applied to any job. Do not use NOT IN. 
--➡ Use LEFT JOIN from JobSeekers → Applications, filter NULL. 
SELECT js.FullName AS seeker_name, js.Email AS seeker_email
FROM JobSeekers js
LEFT JOIN Applications a ON js.SeekerID = a.SeekerID WHERE a.AppID IS NULL;

--Task 7: Find companies that have no jobs posted at all. 
--➡ Use LEFT JOIN from Companies → Jobs, filter where job ID is NULL.
SELECT c.Name AS company_name, c.Industry, c.City
FROM Companies c
LEFT JOIN Jobs j ON c.CompanyID = j.CompanyID WHERE j.JobID IS NULL;

--Task 8: List all pairs of job seekers who live in the same city but are not the same person. Show: Seeker1 Name, Seeker2 Name, Shared City 
--➡ Use SELF JOIN with condition: S1.City = S2.City AND S1.ID <> S2.ID
SELECT s1.FullName AS seeker1_name, s2.FullName AS seeker2_name, s1.City AS shared_city
FROM JobSeekers s1
JOIN JobSeekers s2 ON s1.City = s2.City AND s1.SeekerID <> s2.SeekerID;

--Task 9: Find job seekers who applied to jobs with salaries above 850 in a different city than where they live. 
--➡ Use JOIN + WHERE salary > 850 AND seeker.City <> job.Location
SELECT js.FullName AS seeker_name, js.City AS seeker_city, j.Title AS job_title, j.Location AS job_city, j.Salary
FROM Applications a
JOIN JobSeekers js ON a.SeekerID = js.SeekerID
JOIN Jobs j ON a.JobID = j.JobID
WHERE j.Salary > 850 AND js.City <> j.Location;

--Task 10 Show all job seekers and the job city they applied to, even if they live elsewhere. 
--➡ JOIN JobSeekers → Applications → Jobs; show seeker name, seeker city, job location. 
SELECT js.FullName AS seeker_name, js.City AS seeker_city,j.Location AS job_city
FROM Applications a
JOIN JobSeekers js ON a.SeekerID = js.SeekerID
JOIN Jobs j ON a.JobID = j.JobID;

--Task 11: Show all job titles where no application has been submitted. 
--➡ Use LEFT JOIN from Jobs → Applications, filter where AppID IS NULL. 
SELECT j.Title AS job_title
FROM Jobs j
LEFT JOIN Applications a ON j.JobID = a.JobID
WHERE a.AppID IS NULL;

--Task 12: Find job seekers who applied to jobs in the same city they live in. Show job seeker name, job title, and matching city. 
--➡ Use JOIN with seeker.City = job.Location.
SELECT js.FullName AS seeker_name, j.Title AS job_title, js.City AS matching_city
FROM Applications a
JOIN JobSeekers js ON a.SeekerID = js.SeekerID
JOIN Jobs j ON a.JobID = j.JobID WHERE js.City = j.Location;

--Task 13:Find two job seekers who live in the same city but applied to different jobs. 
--➡ Use SELF JOIN and JOIN on Applications and Jobs; make sure job IDs are different.
SELECT s1.FullName AS seeker1_name, s2.FullName AS seeker2_name, s1.City AS shared_city, j1.Title AS seeker1_job, j2.Title AS seeker2_job
FROM JobSeekers s1
JOIN Applications a1 ON s1.SeekerID = a1.SeekerID
JOIN Jobs j1 ON a1.JobID = j1.JobID
JOIN JobSeekers s2 ON s1.City = s2.City AND s1.SeekerID <> s2.SeekerID
JOIN Applications a2 ON s2.SeekerID = a2.SeekerID
JOIN Jobs j2 ON a2.JobID = j2.JobID WHERE j1.JobID <> j2.JobID;

--Task 14 :Find all jobs applied to by seekers not from the same city as the job. 
--➡ JOIN JobSeekers → Applications → Jobs, filter city mismatch.
SELECT js.FullName AS seeker_name, js.City AS seeker_city, j.Title AS job_title, j.Location AS job_city
FROM Applications a
JOIN JobSeekers js ON a.SeekerID = js.SeekerID
JOIN Jobs j ON a.JobID = j.JobID WHERE js.City <> j.Location;