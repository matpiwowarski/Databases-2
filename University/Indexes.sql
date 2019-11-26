-- fill tables

delimiter //
CREATE PROCEDURE fill_100000()
BEGIN

CALL fill_teacher(100000); -- 100 000
CALL fill_consulation_hours(1); -- 100 000

END //
delimiter ;

CALL fill_100000;

delimiter //
CREATE PROCEDURE fill_1000000()
BEGIN

CALL fill_teacher(1000000); -- 1 000 000
CALL fill_consulation_hours(1); -- 1 000 000

END //
delimiter ;

delimiter //
CREATE PROCEDURE fill_10000000()
BEGIN

CALL fill_teacher(100000); -- 10 000 000
CALL fill_consulation_hours(1); -- 10 000 000

END //
delimiter ;

-- SELECTS

-- TEACHER 
SELECT * FROM TEACHER; 				-- 1 * TEACHER

SELECT PERSON_id FROM TEACHER 		-- 2 Salary
	WHERE SALARY > 3000;

-- CONSULTATION_HOURS
SELECT * FROM CONSULTATION_HOURS; 	-- 1 * CONSULTATION_HOURS

SELECT id FROM CONSULTATION_HOURS 	-- 2 Day
	WHERE Day = 'Monday';
    
-- TEACHER & CONSULTATION_HOURS
SELECT t.PERSON_id, c.ID 			-- 1 Salary AND Day
FROM TEACHER t, CONSULTATION_HOURS c
WHERE t.PERSON_id = c.id
AND t.SALARY > 2500 AND c.Day = 'Friday';

SELECT t.PERSON_id, c.ID 			-- 2 Salary OR Day
FROM TEACHER t, CONSULTATION_HOURS c
WHERE t.PERSON_id = c.id
AND t.SALARY > 2500 OR c.Day = 'Friday';

