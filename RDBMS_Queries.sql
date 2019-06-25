CREATE SCHEMA `NoteSchema`;
use `NoteSchema`;

------------------------------------
User

CREATE TABLE User (
user_id VARCHAR(30) PRIMARY KEY,
user_name VARCHAR(50) NOT NULL, 
user_added_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
user_password VARCHAR(30) NOT NULL,
user_mobile VARCHAR(30) NOT NULL
);
-------------------------------------
Note

CREATE TABLE Note (
note_id INT(30) AUTO_INCREMENT PRIMARY KEY,
note_title VARCHAR(50) NOT NULL UNIQUE,
note_content VARCHAR(200),
note_status VARCHAR(30) NOT NULL,
note_creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
-------------------------------------
Category

CREATE TABLE Category (
category_id INT(30) AUTO_INCREMENT PRIMARY KEY,
category_name VARCHAR(50) NOT NULL UNIQUE,
category_descr VARCHAR(200),
category_creator VARCHAR(50) NOT NULL,
FOREIGN KEY category_creator_fk(category_creator)
REFERENCES User(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
category_creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
-------------------------------------
Reminder

CREATE TABLE Reminder (
reminder_id INT(30) AUTO_INCREMENT PRIMARY KEY,
reminder_name VARCHAR(50) NOT NULL UNIQUE,
reminder_descr VARCHAR(200),
reminder_type VARCHAR(50) NOT NULL,
reminder_creator VARCHAR(50) NOT NULL,
FOREIGN KEY reminder_creator_fk(reminder_creator)
REFERENCES User(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
reminder_creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
-------------------------------------
NoteCategory

CREATE TABLE NoteCategory (
notecategory_id INT(30) AUTO_INCREMENT PRIMARY KEY,
note_id INT(30) NOT NULL, 
FOREIGN KEY note_id_fk(note_id)
REFERENCES Note(note_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
category_id INT(30) NOT NULL,
FOREIGN KEY cat_id_fk(category_id)
REFERENCES Category(category_id)
ON DELETE CASCADE
ON UPDATE CASCADE   
);
-------------------------------------
Notereminder

CREATE TABLE NoteReminder (
notereminder_id INT(30) AUTO_INCREMENT PRIMARY KEY,
note_id INT(30) NOT NULL, 
FOREIGN KEY noterem_id_fk(note_id)
REFERENCES Note(note_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
reminder_id INT(30) NOT NULL,
FOREIGN KEY remind_id_fk(reminder_id)
REFERENCES Reminder(reminder_id)
ON DELETE CASCADE
ON UPDATE CASCADE   
);
---------------------------------------
UserNote

CREATE TABLE UserNote (
usernote_id INT(30) AUTO_INCREMENT PRIMARY KEY,
note_id INT(30) NOT NULL, 
FOREIGN KEY usernote_id_fk(note_id)
REFERENCES Note(note_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
user_id VARCHAR(30) NOT NULL,
FOREIGN KEY user_id_fk(user_id)
REFERENCES User(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE   
);

---------------------------------------------------------------------------------------
Insert the rows into the created tables (Note, Category, Reminder, User, UserNote, NoteReminder and NoteCategory).

1. INSERT INTO User(user_id,user_name,user_password,user_mobile) values ('Asiyath_01','Asiyath Rajila','password','9995451509');
2. INSERT INTO Note(note_title,note_content,note_status) values ('Keep Note','This is sample keep note.','ACTIVE');
3. INSERT INTO Category(category_name,category_descr,category_creator) values ('Official','There is a meeting toay at 01:30pm.','Asiyath_01');
4. INSERT INTO Reminder(reminder_name,reminder_descr,reminder_type,reminder_creator) values('Meeting','Meeting @ 12 AM','Official','Asiyath_01');
5. INSERT INTO UserNote(note_id,user_id) values(1,'Asiyath_01');
6. INSERT INTO NoteCategory(note_id,category_id) values (1,2);
7. INSERT INTO NoteReminder(note_id,reminder_id) values (1,1);
----------------------------------------------------------------------------------------
Fetch the row from User table based on Id and Password.

select * from User where user_id ='Asiyath_01' and user_password = 'password';
-----------------------------------------------------------------------------------------
Fetch all the rows from Note table based on the field note_creation_date.

select * from Note order by note_creation_date asc; 
select * from Note where DATE_FORMAT(note_creation_date,'%Y-%m-%d') = DATE_FORMAT('2018-12-31', '%Y-%m-%d'); 
-----------------------------------------------------------------------------------------
Fetch all the Categories created after the particular Date.

select * from Category where DATE_FORMAT(category_creation_date,'%Y-%m-%d') > DATE_FORMAT('2018-12-30', '%Y-%m-%d');
-----------------------------------------------------------------------------------------
Fetch all the Note ID from UserNote table for a given User.

select a.usernote_id from UserNote a, User b where a.user_id=b.user_id
and b.user_name = 'Asiyath Rajila';
-----------------------------------------------------------------------------------------
Write Update query to modify particular Note for the given note Id.

update Note set note_title = 'updated note', note_content = 'updated note content' where note_id = 100;
------------------------------------------------------------------------------------------
Fetch all the Notes from the Note table by a particular User.

select c.* from UserNote a, User b, Note c where a.user_id=b.user_id
and a.note_id = c.note_id and b.user_name = 'Asiyath Rajila';
------------------------------------------------------------------------------------------
Fetch all the Notes from the Note table for a particular Category.

select b.* from NoteCategory a, Note b, Category c where a.note_id = b.note_id 
and c.category_id = a.category_id and c.category_name = 'Official';
------------------------------------------------------------------------------------------
Fetch all the reminder details for a given note id.

SELECT c.* from Note a,NoteReminder b,Reminder c where a.note_id = b.note_id
and b.reminder_id = c.reminder_id and a.note_id = 1;
------------------------------------------------------------------------------------------
Fetch the reminder details for a given reminder id.

select * from Reminder where reminder_id = 1;
------------------------------------------------------------------------------------------
Write a query to create a new Note from particular User (Use Note and UserNote tables - insert statement).

INSERT INTO Note(note_title,note_content,note_status) values('Meeting invite','Meeting has been scheduled at 11 AM','ACTIVE');
INSERT INTO UserNote (note_id, user_id) SELECT note_id, 'Asiyath_01' FROM Note WHERE note_title = 'Meeting invite';
----------------------------------------------------------------------------------------------------------
Write a query to create a new Note from particular User to particular Category(Use Note and NoteCategory tables - insert statement)

INSERT into Note(note_title,note_content,note_status) 
values('Meeting Schedule','Meeting has been scheduled at 11 AM','ACTIVE');
INSERT INTO UserNote (note_id, user_id) SELECT note_id, 'Asiyath_01' FROM Note WHERE note_title = 'Meeting invite';
INSERT INTO NoteCategory (note_id, category_id) SELECT 1, category_id FROM Category WHERE category_name= 'Official';
------------------------------------------------------------------------------------------
Write a query to set a reminder for a particular note (Use Reminder and NoteReminder tables - insert statement)

INSERT into Note(note_title,note_content,note_status) values('Meeting Tomorrow','Meeting has been scheduled at 11 AM','ACTIVE');
INSERT INTO UserNote (note_id, user_id) SELECT note_id, 'Asiyath_01' FROM Note WHERE note_title = 'Meeting Schedule';
INSERT INTO NoteCategory (note_id, category_id) SELECT  1, category_id FROM Category WHERE category_name= 'Official';
------------------------------------------------------------------------------------------
Write a query to delete particular Note added by a User(Note and UserNote tables - delete statement)

DELETE a FROM Note a INNER JOIN UserNote b ON a.note_id = b.note_id WHERE b.user_id = 'Asiyath_01';
------------------------------------------------------------------------------------------
Write a query to delete particular Note from particular Category(Note and NoteCategory tables - delete statement)

DELETE a FROM Note a INNER JOIN NoteCategory b ON a.note_id = b.note_id WHERE b.category_id = 1;
------------------------------------------------------------------------------------------
Create a trigger to delete all matching records from UserNote, NoteReminder and NoteCategory table when :
1. A particular note is deleted from Note table (all the matching records from UserNote, NoteReminder and NoteCategory should be removed automatically) 
delimiter $$
CREATE TRIGGER note_delete_trigger 
AFTER DELETE on Note 
FOR EACH ROW 
DELETE FROM UserNote WHERE note_id = OLD.note_id;
DELETE from NoteReminder where note_id = OLD.note_id;
DELETE from NoteCategory where note_id = OLD.note_id;
delimiter ;

2. A particular user is deleted from User table (all the matching notes should be removed automatically)

delimiter $$
CREATE TRIGGER user_delete_trigger 
AFTER DELETE on User 
FOR EACH ROW 
DELETE a,b,c,d FROM Note a INNER JOIN UserNote b INNER JOIN NoteReminder c INNER JOIN NoteCategory d
where a.note_id =b.note_id and b.note_id = c.note_id and b.note_id = d.note_id
and  b.user_id = OLD.user_id;
delimiter ;

--------------------------------------------------------------------------------------------