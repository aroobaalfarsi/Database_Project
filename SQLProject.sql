create database projectDB;
use projectDB;

--Trainee
CREATE TABLE Trainee (
    Train_ID INT PRIMARY KEY,
    email VARCHAR(100),
    gender char(1) check (Gender in ('M','F')),
    name VARCHAR(50),
    back_g VARCHAR(100)
);
--Trainer
CREATE TABLE Trainer (
    TR_ID INT PRIMARY KEY,
    name VARCHAR(50),
    specialty VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100)
);
--Course
CREATE TABLE Course (
    course_ID INT PRIMARY KEY,
    title VARCHAR(100),
    category VARCHAR(50),
    Dhr INT,  -- assuming it's course duration in hours
    level VARCHAR(50)
);
--Schedule
CREATE TABLE Schedule (
    sch_ID INT PRIMARY KEY,
    start_date DATE,
    end_date DATE,
    time_slot VARCHAR(50),
    course_ID INT,
    TR_ID INT,
    FOREIGN KEY (course_ID) REFERENCES Course(course_ID),
    FOREIGN KEY (TR_ID) REFERENCES Trainer(TR_ID)
);
--Enrollment
CREATE TABLE Enrollment (
    enr_ID INT PRIMARY KEY,
    enr_date DATE,
    Train_ID INT,
    course_ID INT,
    FOREIGN KEY (Train_ID) REFERENCES Trainee(Train_ID),
    FOREIGN KEY (course_ID) REFERENCES Course(course_ID)
);

-- Insert Data: Trainee
INSERT INTO Trainee (train_id, name, gender, email, back_g) VALUES
(1, 'Aisha Al-Harthy', 'F', 'aisha@example.com', 'Engineering'),
(2, 'Sultan Al-Farsi', 'M', 'sultan@example.com', 'Business'),
(3, 'Mariam Al-Saadi', 'F', 'mariam@example.com', 'Marketing'),
(4, 'Omar Al-Balushi', 'M', 'omar@example.com', 'Computer Science'),
(5, 'Fatma Al-Hinai', 'F', 'fatma@example.com', 'Data Science');

-- Insert Data: Trainer
INSERT INTO Trainer (TR_ID, name, specialty, phone, email) VALUES
(1, 'Khalid Al-Maawali', 'Databases', 96891234567, 'khalid@example.com'),
(2, 'Noura Al-Kindi', 'Web Development', 96892345678, 'noura@example.com'),
(3, 'Salim Al-Harthy', 'Data Science', 96893456789, 'salim@example.com');

-- Insert Data: Course
INSERT INTO Course (course_id, title, category, Dhr, level) VALUES
(1, 'Database Fundamentals', 'Databases', 20, 'Beginner'),
(2, 'Web Development Basics', 'Web', 30, 'Beginner'),
(3, 'Data Science Introduction', 'Data Science', 25, 'Intermediate'),
(4, 'Advanced SQL Queries', 'Databases', 15, 'Advanced');

-- Insert Data: Schedule
INSERT INTO Schedule (sch_id, course_id, TR_ID, start_date, end_date, time_slot) VALUES
(1, 1, 1, '2025-07-01', '2025-07-10', 'Morning'),
(2, 2, 2, '2025-07-05', '2025-07-20', 'Evening'),
(3, 3, 3, '2025-07-10', '2025-07-25', 'Weekend'),
(4, 4, 1, '2025-07-15', '2025-07-22', 'Morning');

-- Insert Data: Enrollment
INSERT INTO Enrollment (enr_ID, train_id, course_id, enr_date) VALUES
(1, 1, 1, '2025-06-01'),
(2, 2, 1, '2025-06-02'),
(3, 3, 2, '2025-06-03'),
(4, 4, 3, '2025-06-04'),
(5, 5, 3, '2025-06-05'),
(6, 1, 4, '2025-06-06');

SELECT * FROM Trainee;
SELECT * FROM Trainer;
SELECT * FROM Course;
SELECT * FROM Schedule;
SELECT * FROM Enrollment;


                       -----------Trainee Queries--------------


-- 1. Show all available courses (title, level, category)
SELECT title, level, category
FROM Course;
-- 2. View beginner-level Data Science courses
SELECT title, level, category
FROM Course
WHERE category = 'Data Science' AND level = 'Beginner';
-- 3. Show courses this trainee is enrolled in (trainee ID = 1)
SELECT c.title
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
WHERE e.train_id = 1;
-- 4. View the schedule for the trainee's enrolled courses
SELECT s.start_date, s.time_slot
FROM Enrollment e
JOIN Schedule s ON e.course_id = s.course_id
WHERE e.train_id = 1;
-- 5. Count how many courses the trainee is enrolled in
SELECT COUNT(*) AS course_count
FROM Enrollment
WHERE train_id = 1;
-- 6. Show course titles, trainer names, and time slots the trainee is attending
SELECT c.title, t.name AS trainer_name, s.time_slot
FROM Enrollment e
JOIN Schedule s ON e.course_id = s.course_id
JOIN Course c ON e.course_id = c.course_id
JOIN Trainer t ON s.TR_ID = t.TR_ID
WHERE e.train_id = 1;


          -------------------Trainer Queries-------------


-- 1. List all courses the trainer is assigned to (trainer ID = 1)
SELECT c.title
FROM Schedule s
JOIN Course c ON s.course_id = c.course_id
WHERE s.TR_ID = 1;
-- 2. Show upcoming sessions (with dates and time slots)
SELECT c.title, s.start_date, s.end_date, s.time_slot
FROM Schedule s
JOIN Course c ON s.course_id = c.course_id
WHERE s.TR_ID = 1
ORDER BY s.start_date;
-- 3. See how many trainees are enrolled in each of your courses
SELECT c.title, COUNT(e.train_id) AS trainee_count
FROM Schedule s
JOIN Course c ON s.course_id = c.course_id
LEFT JOIN Enrollment e ON s.course_id = e.course_id
WHERE s.TR_ID = 1
GROUP BY c.title;
-- 4. List names and emails of trainees in each of your courses
SELECT c.title, t.name AS trainee_name, t.email
FROM Schedule s
JOIN Enrollment e ON s.course_id = e.course_id
JOIN Trainee t ON e.train_id = t.train_id
JOIN Course c ON e.course_id = c.course_id
WHERE s.TR_ID = 1
ORDER BY c.title;
-- 5. Show the trainer's contact info and assigned courses
SELECT tr.phone, tr.email, c.title
FROM Trainer tr
JOIN Schedule s ON tr.TR_ID = s.TR_ID
JOIN Course c ON s.course_id = c.course_id
WHERE tr.TR_ID = 1;
-- 6. Count the number of courses the trainer teaches
SELECT COUNT(DISTINCT s.course_id) AS course_count
FROM Schedule s
WHERE s.TR_ID = 1;

                       ------------Admin Queries-----------


-- 1. Add a new course
INSERT INTO Course (course_id, title, category, Dhr, level)
VALUES (5, 'Python for Beginners', 'Programming', 20, 'Beginner');
-- 2. Create a new schedule for a trainer
INSERT INTO Schedule (sch_id, course_id, TR_ID, start_date, end_date, time_slot)
VALUES (5, 5, 2, '2025-07-20', '2025-07-30', 'Evening');
-- 3. View all trainee enrollments with course title and schedule info
SELECT t.name AS trainee_name, c.title AS course_title, s.start_date, s.time_slot
FROM Enrollment e
JOIN Trainee t ON e.train_id = t.train_id
JOIN Course c ON e.course_id = c.course_id
JOIN Schedule s ON e.course_id = s.course_id
ORDER BY s.start_date;
-- 4. Show how many courses each trainer is assigned to
SELECT tr.name, COUNT(DISTINCT s.course_id) AS course_count
FROM Trainer tr
LEFT JOIN Schedule s ON tr.TR_ID = s.TR_ID
GROUP BY tr.name;
-- 5. List all trainees enrolled in "Database Fundamentals"
SELECT t.name, t.email
FROM Enrollment e
JOIN Trainee t ON e.train_id = t.train_id
JOIN Course c ON e.course_id = c.course_id
WHERE c.title = 'Database Fundamentals';
-- 6. Identify the course with the highest number of enrollments
SELECT TOP 1 c.title, COUNT(e.enr_ID) AS enrollment_count
FROM Course c
JOIN Enrollment e ON c.course_id = e.course_id
GROUP BY c.title
ORDER BY enrollment_count DESC;
-- 7. Display all schedules sorted by start date
SELECT *
FROM Schedule
ORDER BY start_date ASC;