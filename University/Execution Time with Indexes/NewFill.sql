delimiter //
CREATE PROCEDURE fill_teacher(
IN num INT)
BEGIN
DECLARE Salary DOUBLE;
DECLARE JobTitle VARCHAR(45);
DECLARE EmailAddress VARCHAR(45);
DECLARE Phone VARCHAR(45);
DECLARE ExperienceYears INT;

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
END LOOP;

CLOSE TeacherCursor;

END //
delimiter ;