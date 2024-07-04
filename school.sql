-- 1. Inner Join:
-- Question: Retrieve the list of students and their enrolled courses.
SELECT
	student_name,
	course_name
FROM
	school.students s
JOIN school.enrollments e ON
	s.student_id = e.student_id
JOIN school.courses c ON
	e.course_id = c.course_id
ORDER BY
	student_name ASC

-- 2. Left Join:
-- Question: List all students and their enrolled courses, including those who haven't enrolled in any course.
SELECT student_name, course_name FROM school.students s 
LEFT JOIN school.enrollments e ON s.student_id = e.student_id
LEFT JOIN school.courses c ON e.course_id = c.course_id
ORDER BY student_name ASC

-- 3. Right Join:
-- Question: Display all courses and the students enrolled in each course, including courses with no enrolled students.
SELECT course_name,student_name FROM school.students s 
RIGHT JOIN school.enrollments e ON s.student_id = e.student_id
RIGHT JOIN school.courses c ON e.course_id = c.course_id
ORDER BY student_name ASC

-- 4. Self Join:
-- Question: Find pairs of students who are enrolled in at least one common course.
SELECT s1.student_name, s2.student_name, e1.course_id
FROM school.students s1
JOIN school.enrollments e1 ON s1.student_id = e1.student_id
JOIN school.enrollments e2 ON e1.course_id = e2.course_id
JOIN school.students s2 ON e2.student_id = s2.student_id
WHERE s1.student_id < s2.student_id;

-- 5. Complex Join:
-- Question: Retrieve students who are enrolled in 'Introduction to CS' but not in 'Data Structures'.
SELECT student_name, course_name FROM school.students s
JOIN school.enrollments e ON s.student_id = e.student_id
JOIN school.courses c ON c.course_id = e.course_id
WHERE c.course_name = 'Introduction to CS'
AND s.student_id NOT IN (
    SELECT s2.student_id
    FROM school.students s2
    JOIN school.enrollments e2 ON s2.student_id = e2.student_id
    JOIN school.courses c2 ON c2.course_id = e2.course_id
    WHERE c2.course_name = 'Data Structures'
);


--WINDOW FUNCTIONS


-- 1. Using ROW_NUMBER():
-- Question: List all students along with a row number based on their enrollment date in ascending order.

SELECT s.student_name, e.enrollment_date,
ROW_NUMBER() OVER(
	ORDER BY e.enrollment_date 
)
FROM school.students s
JOIN school.enrollments e ON e.student_id = s.student_id

-- 2. Using RANK():
-- Question: Rank students based on the number of courses they are enrolled in, handling ties by assigning the same rank.
SELECT s.student_id, s.student_name, COUNT(e.course_id),
RANK() OVER(
	ORDER BY COUNT(e.course_id) DESC
)
FROM school.students s
JOIN school.enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id;

-- 3. Using DENSE_RANK():
-- Question: Determine the dense rank of courses based on their enrollment count across all students
SELECT s.student_id, s.student_name, COUNT(e.course_id) as Enrollment_course,
DENSE_RANK() OVER(
	ORDER BY COUNT(e.course_id) DESC
)
FROM school.students s
JOIN school.enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id;


