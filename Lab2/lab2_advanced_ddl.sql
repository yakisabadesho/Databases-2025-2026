CREATE DATABASE university_main
WITH OWNER = postgres
ENCODING = 'UTF8'
TEMPLATE = template0;

CREATE DATABASE university_archive
WITH CONNECTION LIMIT = 50
TEMPLATE = template0;

CREATE DATABASE university_test
WITH IS_TEMPLATE = true
CONNECTION LIMIT = 10;

CREATE TABLESPACE student_data LOCATION 'C:\data\students';

CREATE TABLESPACE course_data 
LOCATION 'C:\data\courses';

ALTER TABLESPACE course_data OWNER TO postgres;

CREATE DATABASE university_distributed
WITH ENCODING = 'LATIN9'
TABLESPACE = student_data;

/c university_main

CREATE TABLE students (
student_id SERIAL,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(100),
phone CHAR(15),
date_of_birth DATE,
enrollment_date DATE,
gpa DECIMAL(3,2),
is_active BOOLEAN,
graduation_year SMALLINT,
PRIMARY KEY (student_id)
); 

CREATE TABLE professors (
professor_id SERIAL,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(100),
office_number VARCHAR(20),
hire_date DATE,
salary NUMERIC(16,2),
is_tenured BOOLEAN,
years_experience INT,
PRIMARY KEY (professor_id)
);

CREATE TABLE courses (
course_id SERIAL,
course_code CHAR(8),
course_title VARCHAR(100),
description VARCHAR,
credits SMALLINT,
max_enrollment INT,
course_fee DECIMAL(16,2),
is_online BOOLEAN,
created_at TIMESTAMP,
PRIMARY KEY (course_id)
);

CREATE TABLE class_schedule (
schedule_id SERIAL PRIMARY KEY,
course_id INT,
professor_id INT,
classroom VARCHAR(20),
class_date DATE,
start_time TIME,
end_time TIME,
duration INTERVAL
);

CREATE TABLE student_records (
record_id SERIAL PRIMARY KEY,
student_id INT,
course_id INT,
semester VARCHAR(20),
year INT,
grade CHAR(2),
attendance_percentage DECIMAL(100,1),
submission_timestamp TIMESTAMP WITH TIME ZONE,
last_updated TIMESTAMP WITH TIME ZONE,
FOREIGN KEY (student_id) REFERENCES students(student_id),
FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

ALTER TABLE students
ADD middle_name VARCHAR(30),
ADD student_status VARCHAR(20),
ALTER COLUMN phone TYPE VARCHAR(20),
ALTER COLUMN student_status SET DEFAULT 'ACTIVE',
ALTER COLUMN gpa SET DEFAULT 0.00; 

ALTER TABLE professors
ADD department_code CHAR(5),
ADD research_area VARCHAR,
ALTER COLUMN years_experience TYPE SMALLINT,
ALTER COLUMN is_tenured SET DEFAULT false,
ADD last_promotion_date DATE;

ALTER TABLE courses
ADD prerequisite_course_id INT,
ADD difficulty_level SMALLINT,
ALTER COLUMN course_code TYPE VARCHAR(10),
ALTER COLUMN credits SET DEFAULT 3,
ADD column_lab_required BOOL,
ALTER COLUMN column_lab_required SET DEFAULT false;

ALTER TABLE class_schedule
ADD room_capacity INT,
DROP COLUMN duration,
ADD session_type VARCHAR(15),
ALTER COLUMN classroom TYPE VARCHAR(30),
ADD equipment_needed VARCHAR;

ALTER TABLE student_records
ADD extra_credit_points DECIMAL(100,1),
ALTER COLUMN grade TYPE VARCHAR(5),
ALTER COLUMN extra_credit_points SET DEFAULT 0.00,
ADD final_exam_date DATE,
DROP COLUMN last_updated;

CREATE TABLE departments (
department_id SERIAL PRIMARY KEY,
department_name VARCHAR(100),
department_code CHAR(5),
building VARCHAR(50),
phone VARCHAR(15),
budget NUMERIC(255,2),
established_year INT
);

CREATE TABLE library_books (
book_id SERIAL PRIMARY KEY,
isbn CHAR(13),
title VARCHAR(200),
author VARCHAR(100),
publisher VARCHAR(100),
publication_date DATE,
price DECIMAL(255,2),
is_available BOOLEAN,
acquisition_timestamp TIMESTAMP
);

CREATE TABLE student_book_loans (
loan_id SERIAL PRIMARY KEY,
student_id INT,
book_id INT,
loan_date DATE,
due_date DATE,
return_date DATE,
fine_amount DECIMAL(255,2),
loan_status VARCHAR(20)
);

ALTER TABLE professors
ADD department_id INT;

ALTER TABLE students
ADD advisor_id INT;

ALTER TABLE courses
ADD department_id INT;

CREATE TABLE grade_scale (
grade_id SERIAL PRIMARY KEY,
letter_grade CHAR(2),
min_percentage DECIMAL (100,1),
max_percentage DECIMAL (100,1),
gpa_points DECIMAL (3,2)
);

CREATE TABLE semester_calendar (
semester_id SERIAL PRIMARY KEY,
semester_name VARCHAR(20),
academic_year INT,
start_date DATE,
end_date DATE,
registration_deadline TIMESTAMP WITH TIME ZONE,
is_current BOOLEAN
);

DROP TABLE IF EXISTS student_book_loans;

DROP TABLE IF EXISTS library_books;

DROP TABLE IF EXISTS grade_scale;

CREATE TABLE grade_scale (
grade_id SERIAL PRIMARY KEY,
letter_grade CHAR(2),
min_percentage DECIMAL (100,1),
max_percentage DECIMAL (100,1),
gpa_points DECIMAL (3,2),
description VARCHAR
);


DROP TABLE semester_calendar CASCADE;

CREATE TABLE semester_calendar (
semester_id SERIAL PRIMARY KEY,
semester_name VARCHAR(20),
academic_year INT,
start_date DATE,
end_date DATE,
registration_deadline TIMESTAMP WITH TIME ZONE,
is_current BOOLEAN
);

DROP DATABASE IF EXISTS university_test;

DROP DATABASE IF EXISTS university_distributed;

CREATE DATABASE university_backup
WITH TEMPLATE = university_main;