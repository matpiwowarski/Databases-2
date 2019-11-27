-- use mydb;
-- drop database mydb;
-- INSERT DATA
delimiter //
CREATE PROCEDURE fill_database()
BEGIN

CALL fill_faculty(20); -- 20
CALL fill_student(1000); -- 1000
CALL fill_teacher(100); -- 100
CALL fill_consulation_hours(2); -- 200
CALL fill_course(2); -- 4 000
CALL fill_attendance(1); -- 4 000 000
CALL fill_mark(3); -- 12 000 000 
-- 
CALL fill_faculty(100); -- 120
CALL fill_student(1000); -- 2 000
CALL fill_teacher(1000); -- 1100
CALL fill_consulation_hours(2); -- 2400
CALL fill_course(10);  -- 1 320 000
-- 
CALL fill_faculty(100000); 
CALL fill_student(100000); 
CALL fill_teacher(100000); 
CALL fill_consulation_hours(3); 

END //
delimiter ;

SELECT * FROM Faculty;
SELECT * FROM Student;
SELECT * FROM Teacher;
SELECT * FROM PERSON;
SELECT * FROM CONSULTATION_HOURS;
SELECT * FROM COURSE;
SELECT * FROM ATTENDANCE;
SELECT * FROM MARK;

CALL fill_database();

-- INDEXES

CREATE INDEX CourseNameIndex ON COURSE(name);
CREATE INDEX MarkMarkIndex ON MARK(mark);
CREATE INDEX PersonBirthdayIndex ON PERSON(birthdate);
CREATE INDEX PersonSexIndex ON PERSON(Sex);
CREATE INDEX ConsultationDayIndex ON CONSULTATION_HOURS(day);
CREATE INDEX CourseECTSIndex ON COURSE(ECTS);
CREATE INDEX CourseExamIndex ON COURSE(EXAM);
CREATE INDEX CourseEctsExamIndex ON COURSE(ECTS,EXAM);

DROP INDEX CourseNameIndex ON COURSE; 
DROP INDEX MarkMarkIndex ON MARK; 
DROP INDEX PersonBirthdayIndex ON PERSON;
DROP INDEX PersonSexIndex ON PERSON;
DROP INDEX ConsultationDayIndex ON CONSULTATION_HOURS; 
DROP INDEX CourseECTSIndex ON COURSE;
DROP INDEX CourseExamIndex ON COURSE;
DROP INDEX CourseEctsExamIndex ON COURSE;

-- SELECTS:
-- LEFT, RIGHT, OUTER, FULL JOIN 4/4
-- GROUP BY 4/4
-- SUM COUNT 2/2 + HAVING
-- EXIST/IN/NOT IN/ANY 1/1

-- 1 HAVING
-- SURNAMES AND AVERAGE GRADES OF STUDENT 
-- FROM COURSE 'Coursename1%' 
-- WHO HAVE AVG > 6.0

select p.surname , avg(m.mark), c.name
from person p 
INNER JOIN student s ON p.id = s.PERSON_id
INNER JOIN attendance a ON s.PERSON_id = a.STUDENT_PERSON_id
INNER JOIN course c ON a.COURSE_id = c.id
INNER JOIN mark m ON a.id = m.attendance_id
WHERE c.name LIKE 'Coursename1%'
group by p.id, c.name
HAVING avg(m.mark) > 8.5;

-- 2 IN
-- THE OLDEST STUDENTS ON EACH COURSE
select p.Surname, p.Birthdate
from person p
where p.Birthdate IN (
	select min(pp.birthdate) from PERSON pp 
    JOIN student ss on pp.id = ss.PERSON_id
    JOIN attendance aa on ss.PERSON_id = aa.Student_person_id
    JOIN course cc on aa.Course_id = cc.id
    WHERE p.id = pp.id
    GROUP BY pp.id
    );
    
-- 3 COUNT 
-- MALE TEACHERS WITH AT LEAST 3 CONSULTATION_HOURS AT THE WEEKEND
select p.surname, COUNT(c.Day) as 'FRIDAY/SATURDAY CONSULTATIONS'
from person p 
JOIN TEACHER t ON p.id = t.PERSON_id
JOIN CONSULTATION_HOURS c ON t.PERSON_id = c.TEACHER_PERSON_id
WHERE (c.Day = 'Friday' OR c.Day = 'Saturday')
AND p.sex = 'M'
GROUP BY p.id
HAVING COUNT(c.Day) > 2;

-- 4 
-- COURSES WHICH HAS:
-- THE HIGHEST ECTS AND EXAM
-- WITH THE ATTENDANCE COUNT
SELECT c.Name, c.ECTS, COUNT(a.id)
FROM COURSE c
JOIN ATTENDANCE a ON c.id = a.COURSE_id
WHERE c.ECTS = (
	SELECT max(cc.ECTS) FROM COURSE cc)
AND c.exam = 1
GROUP BY c.id;


