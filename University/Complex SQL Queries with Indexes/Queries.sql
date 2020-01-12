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

CREATE INDEX CourseNameIndex ON COURSE(name); -- USED
CREATE INDEX CourseStudiesTypeIndex ON COURSE(studiestype); 
CREATE INDEX CourseExamIndex ON Course(Exam); -- USED

CREATE INDEX ConsultationDayIndex ON CONSULTATION_HOURS(day);
CREATE INDEX ConsultationRoomIndex ON CONSULTATION_HOURS(room);
CREATE INDEX DayRoomIndex ON CONSULTATION_HOURS(day,room); -- USED

CREATE INDEX CityDeanIndex ON FACULTY(City,Dean);
CREATE INDEX FacultyCityIndex ON Faculty(City); 

CREATE INDEX PersonSexIndex ON PERSON(Sex); 

DROP INDEX CourseNameIndex ON COURSE; 
DROP INDEX CourseStudiesTypeIndex ON COURSE;
DROP INDEX ConsultationDayIndex ON CONSULTATION_HOURS; 
DROP INDEX ConsultationRoomIndex ON CONSULTATION_HOURS;
DROP INDEX DayRoomIndex ON CONSULTATION_HOURS;
DROP INDEX CityDeanIndex ON FACULTY;
DROP INDEX FacultyCityIndex ON Faculty; 
DROP INDEX CourseExamIndex ON Course; 
DROP INDEX PersonSexIndex ON PERSON;

-- SELECTS:
-- LEFT, RIGHT, OUTER, FULL JOIN 4/4
-- GROUP BY 4/4
-- SUM COUNT 2/2 + HAVING
-- EXIST/IN/NOT IN/ANY 1/1

-- 1 HAVING
-- SURNAMES AND AVERAGE GRADES OF STUDENT 
-- FROM COURSE 'Coursename1' 
-- WHO HAVE AVG > 6.0

select p.surname , avg(m.mark), c.name
from person p 
INNER JOIN student s ON p.id = s.PERSON_id
INNER JOIN attendance a ON s.PERSON_id = a.STUDENT_PERSON_id
INNER JOIN course c ON a.COURSE_id = c.id
INNER JOIN mark m ON a.id = m.attendance_id
WHERE c.name LIKE 'Coursename1'
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
-- MALE TEACHERS ON 'full-time' studies 
-- WITH AT LEAST 1 CONSULTATION_HOURS IN ROOM 200 ON FRIDAYS

select p.surname, COUNT(c.Day) as 'FRIDAY CONSULTATIONS'
from person p 
JOIN TEACHER t ON p.id = t.PERSON_id
JOIN CONSULTATION_HOURS c ON t.PERSON_id = c.TEACHER_PERSON_id
JOIN COURSE cc ON t.PERSON_ID = cc.TEACHER_PERSON_id
WHERE c.Day = 'Friday'
AND c.Room = 200
AND p.sex = 'M'
AND cc.studiestype = 'full-time'
GROUP BY p.id
HAVING COUNT(c.Day) > 0;

-- 4 
-- COURSES WITH EXAM
-- WITH THE HIGHEST ECTS
-- WITH THE ATTENDANCE > 5
-- ON FACULTIES IN Cork
SELECT c.Name, c.ECTS, f.city, f.dean ,COUNT(a.id)
FROM COURSE c
JOIN ATTENDANCE a ON c.id = a.COURSE_id
JOIN FACULTY f ON c.FACULTY_ID = f.id
WHERE f.city = 'Cork'
AND c.exam = 1
AND c.ECTS = (
	SELECT max(cc.ECTS) FROM COURSE cc)
GROUP BY c.id HAVING COUNT(a.id) > 800;

 
