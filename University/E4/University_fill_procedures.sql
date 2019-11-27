USE mydb;

-- person is created when student or teacher is created (trigger)
delimiter //
CREATE PROCEDURE fill_person(
IN num INT)
BEGIN
DECLARE Name VARCHAR(45);
DECLARE Surname VARCHAR(45);
DECLARE Sex enum('M','W');
DECLARE Birthdate datetime;
DECLARE Birthplace varchar(45);

SET @MIN = '1900-01-01 00:00:00';
SET @MAX = '2001-10-30 00:00:00';
START TRANSACTION;
WHILE num > 0 DO
	SET Name = CONCAT('name',num);
    SET Surname = CONCAT('surname',num);
    
    IF num%2 = 0 THEN SET Sex = 'M';
    ELSE SET Sex = 'W';
    END IF;
    
    SET Birthdate  = TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN);
    SET BIRTHPLACE = CONCAT('city',num);
    
    INSERT INTO PERSON (NAME, SURNAME, SEX, BIRTHDATE, BIRTHPLACE)
    VALUES (Name, Surname, Sex, Birthdate, Birthplace);
    SET num = num - 1;
END WHILE;
COMMIT;
END //
delimiter ;

delimiter //
CREATE PROCEDURE fill_faculty(
IN num INT)
BEGIN
DECLARE Name Varchar(45);
DECLARE City Varchar(45);
DECLARE Address1 Varchar(45);
DECLARE Address2 Varchar(45);
DECLARE Dean Varchar(45);

START TRANSACTION;
WHILE num > 0 DO
	SET Name = CONCAT('name',num);
    SET City = CONCAT('city',num);
    SET Address1 = CONCAT('Street',num);
    SET Address2 = num;
    SET Dean = CONCAT('Dean',num);
    
    INSERT INTO FACULTY (name, city, address1, address2, dean)
    VALUES (Name, City, Address1, Address2, Dean);
    SET num = num - 1;
END WHILE;
COMMIT;
END //
delimiter ;

delimiter //
CREATE PROCEDURE fill_student(
IN num INT)
BEGIN
DECLARE DegreeOfStudy VARCHAR(45);
DECLARE StudyYear INT;
DECLARE StudiesType ENUM('full-time','extramural');

START TRANSACTION;
WHILE num > 0 DO
	SET DegreeOfStudy = CONCAT('Degree',num);
    SET StudyYear = FLOOR(1 + (RAND() * 4));
	
    IF num%2 = 0 THEN SET StudiesType = 'full-time';
    ELSE SET StudiesType = 'extramural';
    END IF;
    
    INSERT INTO STUDENT (DegreeOfStudy, StudyYear, StudiesType)
    VALUES (DegreeOfStudy, StudyYear, StudiesType);
    SET num = num - 1;
END WHILE;
COMMIT;
END //
delimiter ;

delimiter //
CREATE PROCEDURE fill_teacher(
IN num INT)
BEGIN
DECLARE Salary DOUBLE;
DECLARE JobTitle VARCHAR(45);
DECLARE EmailAddress VARCHAR(45);
DECLARE Phone VARCHAR(45);
DECLARE ExperienceYears INT;

START TRANSACTION;
WHILE num > 0 DO
	SET Salary = FLOOR(2000 + (RAND() * 2000));
	SET JobTitle = CONCAT('JobTitle',num);
    SET EmailAddress = CONCAT('email',num);
    SET Phone = CONCAT((FLOOR((RAND() * 9))),(FLOOR((RAND() * 9))),
    (FLOOR((RAND() * 9))),(FLOOR((RAND() * 9))),(FLOOR((RAND() * 9))),
    (FLOOR((RAND() * 9))),(FLOOR((RAND() * 9))),(FLOOR((RAND() * 9))),
    (FLOOR((RAND() * 9))),(FLOOR((RAND() * 9))),(FLOOR((RAND() * 9))));
    SET ExperienceYears = FLOOR((RAND() * 20));
    
    INSERT INTO TEACHER(salary, jobtitle, emailaddress, phone, experienceyears)
    VALUES (salary, jobtitle, emailaddress, phone, experienceyears);
    SET num = num - 1;
END WHILE;
COMMIT;
END //
delimiter ;

delimiter //
CREATE PROCEDURE fill_consulation_hours(
IN num INT)
BEGIN
DECLARE done INT;
DECLARE Day ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');
DECLARE RandomDay INT;
DECLARE OpenHour INT;
DECLARE OpenMinutes INT;
DECLARE OpenTime TIME;
DECLARE CloseTime TIME;
DECLARE Room INT;
DECLARE TeacherID INT;
DECLARE RememberNum INT;
DECLARE RandomMinutes INT;
DECLARE TeacherCursor CURSOR FOR SELECT PERSON_id FROM teacher ORDER BY PERSON_id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
SET done = false;
OPEN TeacherCursor;

SET RememberNum = num;

Teacher_Loop: LOOP
    FETCH TeacherCursor INTO TeacherID;
    IF done THEN
      LEAVE Teacher_Loop;
    END IF;
    SET num = RememberNum;
    START TRANSACTION;
    WHILE num > 0 DO
	
    SET RandomDay = FLOOR(1 + (RAND() * 6));
    IF RandomDay = 1 THEN SET Day = 'Monday'; END IF;
    IF RandomDay = 2 THEN SET Day = 'Tuesday';END IF;
    IF RandomDay = 3 THEN SET Day = 'Wednesday';END IF;
    IF RandomDay = 4 THEN SET Day = 'Thursday';END IF;
    IF RandomDay = 5 THEN SET Day = 'Friday';END IF;
	IF RandomDay = 6 THEN SET Day = 'Saturday';END IF;
    IF RandomDay = 7 THEN SET Day = 'Sunday';END IF;
    
    SET OpenHour = FLOOR(7 + (RAND() * 12));
    
	SET RandomMinutes = FLOOR(0 + (RAND() * 60));
    IF RandomMinutes%2 = 0 THEN SET OpenMinutes = 30;
    ELSE SET OpenMinutes = 0;
    END IF;
    SET OpenTime = CONCAT(OpenHour,':',OpenMinutes);
    SET CloseTime = CONCAT(OpenHour+2,':',OpenMinutes);
    SET Room = FLOOR(RAND() * 300);
    
    
    INSERT INTO CONSULTATION_HOURS(day, opentime, closetime, room, teacher_person_id)
    VALUES (Day, OpenTime, CloseTime, Room, TeacherID);
    SET num = num - 1;
    
	END WHILE;
    COMMIT;
END LOOP;

CLOSE TeacherCursor;

END //
delimiter ;

delimiter //
CREATE PROCEDURE fill_course( 
IN num INT)
BEGIN
DECLARE CourseNameNumber INT;
DECLARE doneFaculty int;
DECLARE rememberNum INT;
DECLARE Name VARCHAR(45);
DECLARE Code INT;
DECLARE Ects INT;
DECLARE Exam TINYINT;
DECLARE StudiesType ENUM('full-time','extramural');
DECLARE Faculty_id INT;
DECLARE FacultyCursor CURSOR FOR SELECT id FROM faculty ORDER BY id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET doneFaculty = TRUE;
SET doneFaculty = false;
SET rememberNum = num;
SET CourseNameNumber = 0;

OPEN FacultyCursor;

Faculty_Loop: LOOP
    FETCH FacultyCursor INTO Faculty_id;
    IF doneFaculty THEN
      LEAVE Faculty_Loop;
    END IF;
	
     BLOCK2: BEGIN
     DECLARE Teacher_id INT;
     DECLARE doneTeacher INT;
	 DECLARE TeacherCursor CURSOR FOR SELECT PERSON_id FROM teacher ORDER BY PERSON_id;
     DECLARE CONTINUE HANDLER FOR NOT FOUND SET doneTeacher = TRUE;

     OPEN TeacherCursor;
     Teacher_Loop: LOOP
	 	FETCH TeacherCursor INTO Teacher_id;
	 	IF doneTeacher THEN
	 	SET doneFaculty = false;
		CLOSE TeacherCursor;
		LEAVE Teacher_Loop;
		END IF;
        SET num = RememberNum;
        START TRANSACTION;
		WHILE num > 0 DO
    
			SET Name = CONCAT('Coursename',CourseNameNumber);
			SET CourseNameNumber = CourseNameNumber + 1;
			SET Code = CourseNameNumber;
            SET Ects = FLOOR(1 + RAND()*7);
			IF CourseNameNumber%2 = 0 THEN SET Exam = true;
			ELSE SET Exam = false;
			END IF;
			IF CourseNameNumber%2 = 0 THEN SET StudiesType = 'full-time';
			ELSE SET StudiesType = 'extramural';
			END IF;
			INSERT INTO COURSE(Name, Code, ECTS, Exam,FACULTY_id, TEACHER_PERSON_id, StudiesType)
			VALUES (Name, Code, Ects, Exam, Faculty_id, Teacher_id, StudiesType);
			SET num = num - 1;
    
			END WHILE;
            COMMIT;
		END LOOP Teacher_Loop;
        SET doneFaculty = false;
		END BLOCK2;
END LOOP Faculty_Loop;

CLOSE FacultyCursor;

END //
delimiter ;

delimiter //
CREATE PROCEDURE fill_attendance(
IN num INT)
BEGIN
DECLARE doneStudent int;
DECLARE rememberNum INT;
DECLARE Date DATETIME;
DECLARE STUDENT_PERSON_id INT;
DECLARE StudentCursor CURSOR FOR SELECT PERSON_id FROM student ORDER BY PERSON_id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET doneStudent = TRUE;
SET doneStudent = false;
SET rememberNum = num;

OPEN StudentCursor;

Student_Loop: LOOP
    FETCH StudentCursor INTO STUDENT_PERSON_id;
    IF doneStudent THEN
      LEAVE Student_Loop;
    END IF;
	
     BLOCK2: BEGIN
     DECLARE COURSE_id INT;
     DECLARE doneCourse INT;
	 DECLARE CourseCursor CURSOR FOR SELECT id FROM course ORDER BY id;
     DECLARE CONTINUE HANDLER FOR NOT FOUND SET doneCourse = TRUE;
	 SET @MIN = '2015-01-01 00:00:00';
	 SET @MAX = '2019-10-30 00:00:00';
     OPEN CourseCursor;
     Course_Loop: LOOP
	 	FETCH CourseCursor INTO COURSE_id;
	 	IF doneCourse THEN
	 	SET doneStudent = false;
		CLOSE CourseCursor;
		LEAVE Course_Loop;
		END IF;
        SET num = RememberNum;
        START TRANSACTION;
		WHILE num > 0 DO
            SET Date  = TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN);
    
			INSERT INTO ATTENDANCE(STUDENT_PERSON_id, COURSE_id, Date)
			VALUES (STUDENT_PERSON_id, COURSE_id, Date);
			SET num = num - 1;
    
			END WHILE;
            COMMIT;
		END LOOP Course_Loop;
        SET doneStudent = false;
		END BLOCK2;
END LOOP Student_Loop;

CLOSE StudentCursor;

END //
delimiter ;

delimiter //
CREATE PROCEDURE fill_mark(
IN num INT)
BEGIN
DECLARE done INT;
DECLARE mark INT;
DECLARE date DATETIME;
DECLARE Attendance_id INT;
DECLARE RememberNum INT;
DECLARE AttendanceCursor CURSOR FOR SELECT id FROM attendance ORDER BY Id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
SET done = false;
SET @MIN = '2015-01-01 00:00:00';
SET @MAX = '2019-10-30 00:00:00';

OPEN AttendanceCursor;

SET RememberNum = num;

Attendance_Loop: LOOP
    FETCH AttendanceCursor INTO Attendance_id;
    IF done THEN
      LEAVE Attendance_Loop;
    END IF;
    SET num = RememberNum;
	START TRANSACTION;
	WHILE num > 0 DO
	
	SET mark = FLOOR(RAND()*10);
	SET date  = TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN);
    
	INSERT INTO MARK(Mark, Date, ATTENDANCE_id)
    VALUES (mark, date, Attendance_id);
    
    SET num = num - 1;
    
	END WHILE;
	START TRANSACTION;
END LOOP Attendance_Loop;

CLOSE AttendanceCursor;

END //
delimiter ;
