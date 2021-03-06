-- MySQL Script generated by MySQL Workbench
-- Thu Nov  7 18:38:05 2019
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`FACULTY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`FACULTY` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `City` VARCHAR(45) NULL,
  `Address1` VARCHAR(45) NULL,
  `Address2` VARCHAR(45) NULL,
  `Dean` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PERSON`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PERSON` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  `Surname` VARCHAR(45) NOT NULL,
  `Sex` ENUM('M', 'W') NULL,
  `Birthdate` DATETIME NULL,
  `Birthplace` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`TEACHER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`TEACHER` (
  `PERSON_id` INT NOT NULL AUTO_INCREMENT,
  `Salary` DOUBLE NOT NULL,
  `JobTitle` VARCHAR(45) NULL,
  `EmailAddress` VARCHAR(45) NULL,
  `Phone` VARCHAR(45) NULL,
  `ExperienceYears` INT NULL,
  PRIMARY KEY (`PERSON_id`),
  INDEX `fk_TEACHER_PERSON1_idx` (`PERSON_id` ASC) VISIBLE,
  UNIQUE INDEX `PERSON_id_UNIQUE` (`PERSON_id` ASC) VISIBLE,
  CONSTRAINT `fk_TEACHER_PERSON1`
    FOREIGN KEY (`PERSON_id`)
    REFERENCES `mydb`.`PERSON` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`COURSE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`COURSE` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Code` INT NOT NULL,
  `ECTS` INT NULL,
  `Exam` TINYINT NULL,
  `FACULTY_id` INT NOT NULL,
  `TEACHER_PERSON_id` INT NOT NULL,
  `StudiesType` ENUM('full-time', 'extramural') NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_COURSE_FACULTY1_idx` (`FACULTY_id` ASC) VISIBLE,
  INDEX `fk_COURSE_TEACHER1_idx` (`TEACHER_PERSON_id` ASC) VISIBLE,
  CONSTRAINT `fk_COURSE_FACULTY1`
    FOREIGN KEY (`FACULTY_id`)
    REFERENCES `mydb`.`FACULTY` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_COURSE_TEACHER1`
    FOREIGN KEY (`TEACHER_PERSON_id`)
    REFERENCES `mydb`.`TEACHER` (`PERSON_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`STUDENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`STUDENT` (
  `PERSON_id` INT NOT NULL AUTO_INCREMENT,
  `DegreeOfStudy` VARCHAR(45) NOT NULL,
  `StudyYear` INT NULL,
  `StudiesType` ENUM('full-time', 'extramural') NULL,
  PRIMARY KEY (`PERSON_id`),
  INDEX `fk_STUDENT_PERSON1_idx` (`PERSON_id` ASC) VISIBLE,
  UNIQUE INDEX `PERSON_id_UNIQUE` (`PERSON_id` ASC) VISIBLE,
  CONSTRAINT `fk_STUDENT_PERSON1`
    FOREIGN KEY (`PERSON_id`)
    REFERENCES `mydb`.`PERSON` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`CONSULATATION HOURS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`CONSULTATION_HOURS` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Day` ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
  `OpenTime` TIME NOT NULL,
  `CloseTime` TIME NULL,
  `Room` INT NOT NULL,
  `TEACHER_PERSON_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_CONSULATATION HOURS_TEACHER1_idx` (`TEACHER_PERSON_id` ASC) VISIBLE,
  CONSTRAINT `fk_CONSULATATION HOURS_TEACHER1`
    FOREIGN KEY (`TEACHER_PERSON_id`)
    REFERENCES `mydb`.`TEACHER` (`PERSON_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ATTENDANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ATTENDANCE` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `STUDENT_PERSON_id` INT NOT NULL,
  `COURSE_id` INT NOT NULL,
  `Date` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_STUDENT_has_COURSE_COURSE1_idx` (`COURSE_id` ASC) VISIBLE,
  INDEX `fk_STUDENT_has_COURSE_STUDENT1_idx` (`STUDENT_PERSON_id` ASC) VISIBLE,
  CONSTRAINT `fk_STUDENT_has_COURSE_STUDENT1`
    FOREIGN KEY (`STUDENT_PERSON_id`)
    REFERENCES `mydb`.`STUDENT` (`PERSON_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_STUDENT_has_COURSE_COURSE1`
    FOREIGN KEY (`COURSE_id`)
    REFERENCES `mydb`.`COURSE` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`MARK`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`MARK` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Mark` INT NOT NULL,
  `Date` DATETIME NULL,
  `ATTENDANCE_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_MARK_ATTENDANCE1_idx` (`ATTENDANCE_id` ASC) VISIBLE,
  CONSTRAINT `fk_MARK_ATTENDANCE1`
    FOREIGN KEY (`ATTENDANCE_id`)
    REFERENCES `mydb`.`ATTENDANCE` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- TRIGGERS INSERT
delimiter //
CREATE TRIGGER checkPersonBirthDate BEFORE INSERT ON PERSON
       FOR EACH ROW
       BEGIN
           IF NEW.BirthDate < '1900-01-01 00:00:00' THEN
               SET NEW.BirthDate = '1900-01-01 00:00:00';
           ELSEIF NEW.BirthDate > '2001-10-30 00:00:00' THEN
               SET NEW.BirthDate = '2001-10-30 00:00:00';
           END IF;
       END;//
delimiter ;

delimiter //
CREATE TRIGGER checkConsultationRoom BEFORE INSERT ON Consultation_Hours
       FOR EACH ROW
       BEGIN
           IF NEW.Room < 0 THEN
               SET NEW.Room = 0;
           ELSEIF NEW.Room > 1000 THEN
               SET NEW.Room = 0;
           END IF;
       END;//
delimiter ;

delimiter //
CREATE TRIGGER checkMark BEFORE INSERT ON Mark
       FOR EACH ROW
       BEGIN
           IF NEW.Mark < 0 THEN
               SET NEW.Mark = 0;
           ELSEIF NEW.Mark > 10 THEN
               SET NEW.Mark = 0;
           END IF;
       END;//
delimiter ;

delimiter //
CREATE TRIGGER checkStudentStudyYear BEFORE INSERT ON Student
       FOR EACH ROW
       BEGIN
           IF NEW.StudyYear < 1 THEN
               SET NEW.StudyYear = 1;
           ELSEIF NEW.StudyYear > 5 THEN
               SET NEW.StudyYear = 5;
           END IF;
       END;//
delimiter ;

delimiter //
CREATE TRIGGER checkTeacherSalary BEFORE INSERT ON Teacher
       FOR EACH ROW
       BEGIN
           IF NEW.Salary < 0 THEN
               SET NEW.Salary = 0;
           END IF;
       END;//
delimiter ;

delimiter //
CREATE TRIGGER checkExperience BEFORE INSERT ON Teacher
       FOR EACH ROW
       BEGIN
           IF NEW.ExperienceYears < 0 THEN
               SET NEW.ExperienceYears = 0;
           END IF;
       END;//
delimiter ;

delimiter // 
CREATE TRIGGER createPersonForStudent BEFORE INSERT ON Student
	FOR EACH ROW
	BEGIN
    DECLARE newId INT;
    DECLARE randomNum INT;
	DECLARE Name VARCHAR(45);
	DECLARE Surname VARCHAR(45);
	DECLARE Sex enum('M','W');
	DECLARE Birthdate datetime;
	DECLARE Birthplace varchar(45);
	DECLARE PersonCursor CURSOR FOR SELECT id FROM PERSON ORDER BY id DESC;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET newId = -1;

Open PersonCursor;
    FETCH PersonCursor INTO newId;
SET randomNum = FLOOR(RAND()*1000000000);

SET @MIN = '1900-01-01 00:00:00';
SET @MAX = '2001-10-30 00:00:00';

	SET Name = CONCAT('name', randomNum);
    SET Surname = CONCAT('surname', randomNum);
    
    IF randomNum%2 = 0 THEN SET Sex = 'M';
    ELSE SET Sex = 'W';
    END IF;
    
    SET Birthdate  = TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN);
    SET BIRTHPLACE = CONCAT('city',RandomNum);
    
    INSERT INTO PERSON (NAME, SURNAME, SEX, BIRTHDATE, BIRTHPLACE)
    VALUES (Name, Surname, Sex, Birthdate, Birthplace);
    SET new.PERSON_id = newId + 1;
    Close PersonCursor;
	END;//
delimiter ;

delimiter // 
CREATE TRIGGER createPersonForTeacher BEFORE INSERT ON Teacher
	FOR EACH ROW
	BEGIN
    DECLARE newId int;
    DECLARE randomNum INT;
	DECLARE Name VARCHAR(45);
	DECLARE Surname VARCHAR(45);
	DECLARE Sex enum('M','W');
	DECLARE Birthdate datetime;
	DECLARE Birthplace varchar(45);
	DECLARE PersonCursor CURSOR FOR SELECT id FROM PERSON ORDER BY id DESC;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET newId = -1;
    
Open PersonCursor;
    FETCH PersonCursor INTO newId;
SET randomNum = FLOOR(RAND()*1000000000);

SET @MIN = '1900-01-01 00:00:00';
SET @MAX = '2001-10-30 00:00:00';

	SET Name = CONCAT('name', randomNum);
    SET Surname = CONCAT('surname', randomNum);
    
    IF randomNum%2 = 0 THEN SET Sex = 'M';
    ELSE SET Sex = 'W';
    END IF;
    
    SET Birthdate  = TIMESTAMPADD(SECOND, FLOOR(RAND() * TIMESTAMPDIFF(SECOND, @MIN, @MAX)), @MIN);
    SET BIRTHPLACE = CONCAT('city',RandomNum);
    
    INSERT INTO PERSON (NAME, SURNAME, SEX, BIRTHDATE, BIRTHPLACE)
    VALUES (Name, Surname, Sex, Birthdate, Birthplace);
    SET new.PERSON_id = newId + 1;
    Close PersonCursor;
	END;//
delimiter ;

-- TRIGGERS FOR UPDATES
delimiter //
CREATE TRIGGER UcheckPersonBirthDate BEFORE UPDATE ON PERSON
       FOR EACH ROW
       BEGIN
           IF NEW.BirthDate < '1900-01-01 00:00:00' THEN
               SET NEW.BirthDate = '1900-01-01 00:00:00';
           ELSEIF NEW.BirthDate > '2001-10-30 00:00:00' THEN
               SET NEW.BirthDate = '2001-10-30 00:00:00';
           END IF;
       END;//
delimiter ;

delimiter //
CREATE TRIGGER UcheckConsultationRoom BEFORE UPDATE ON Consultation_Hours
       FOR EACH ROW
       BEGIN
           IF NEW.Room < 0 THEN
               SET NEW.Room = 0;
           ELSEIF NEW.Room > 1000 THEN
               SET NEW.Room = 0;
           END IF;
       END;//
delimiter ;

delimiter //
CREATE TRIGGER UcheckMark BEFORE UPDATE ON Mark
       FOR EACH ROW
       BEGIN
           IF NEW.Mark < 0 THEN
               SET NEW.Mark = 0;
           ELSEIF NEW.Mark > 10 THEN
               SET NEW.Mark = 0;
           END IF;
       END;//
delimiter ;

delimiter //
CREATE TRIGGER UcheckStudentStudyYear BEFORE UPDATE ON Student
       FOR EACH ROW
       BEGIN
           IF NEW.StudyYear < 1 THEN
               SET NEW.StudyYear = 1;
           ELSEIF NEW.StudyYear > 5 THEN
               SET NEW.StudyYear = 5;
           END IF;
       END;//
delimiter ;

delimiter //
CREATE TRIGGER UcheckTeacherSalary BEFORE UPDATE ON Teacher
       FOR EACH ROW
       BEGIN
           IF NEW.Salary < 0 THEN
               SET NEW.Salary = 0;
           END IF;
       END;//
delimiter ;

delimiter //
CREATE TRIGGER UcheckExperience BEFORE UPDATE ON Teacher
       FOR EACH ROW
       BEGIN
           IF NEW.ExperienceYears < 0 THEN
               SET NEW.ExperienceYears = 0;
           END IF;
       END;//
delimiter ;

-- TRIGGERS DELETE

delimiter //
CREATE TRIGGER deletePersonAfterDeleteStudent BEFORE DELETE ON Student
       FOR EACH ROW
       BEGIN
       DECLARE StudentId INT;
       SET StudentId = old.PERSON_id;
           DELETE FROM Person WHERE Person.id = StudentId;
       END;//
delimiter ;

DROP TRIGGER deletePersonAfterDeleteStudent;

delimiter //
CREATE TRIGGER deletePersonAfterDeleteTeacher BEFORE DELETE ON Teacher
       FOR EACH ROW
       BEGIN
       DECLARE TeacherId INT;
       SET TeacherId = old.PERSON_id;
           DELETE FROM Person WHERE Person.id = TeacherId;
       END;//
delimiter ;

DROP TRIGGER deletePersonAfterDeleteTeacher;

delimiter //
CREATE TRIGGER deleteTeacherStudentAfterDeletePerson BEFORE DELETE ON Person
       FOR EACH ROW
       BEGIN
       DECLARE PersonId INT;
       SET PersonId = old.id;
           DELETE FROM Student WHERE Student.PERSON_id = PersonId;
           DELETE FROM Teacher WHERE Teacher.PERSON_id = PersonId;
       END;//
delimiter ;



