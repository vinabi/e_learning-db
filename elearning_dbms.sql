/*``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Implementation of "Advanced E-learning System" Database ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Designed by Nayab Irfan ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ XXXXBSCS0402 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

```````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````*/
-- Drop any existing database of same name to ensure a clean slate for data
drop database if exists e_learning;
create database e_learning;
use e_learning;

-- 1. Users Table

create table users
(
	userID int auto_increment primary key, -- for effecient indexing and joining
    userCode varchar(20) unique not null,
    fname varchar(100) not null,
    lname varchar (100) not null,
    email varchar(100) not null unique,
    password varchar(255) not null,
    role enum('Student', 'instructor', 'Admin') not null, -- im using enumeration for different user' roles
    contact varchar (15),
    dob date, 
    address text
);

-- 2. Courses Table

create table courses 
(
	courseID int auto_increment primary key,
	courseCode varchar(20) unique not null,
    courseName varchar(255) not null,
    description text,
    category varchar(100),
    level enum('Beginner', 'intermediate', 'Advanced'),  -- im using enumeration for different course' levels
    instID int,
    duration int, 
    language enum ('English', 'Urdu'),
    foreign key (instID) references users(userID) on delete set null
);

-- 3.  Modules Table

create table modules
(
	moduleID int auto_increment primary key,
	modCode varchar(20) unique not null,
    cID int, 
    moduleName varchar(255) not null,
    content text,
    foreign key (cID) references courses(courseID) on delete cascade
);

-- 4. Lessons Table

create table lessons 
(
	lessonID int auto_increment primary key,
	lessnCode varchar(20) unique not null,
    modID int, 
    ltitle varchar(255) not null,
    contentType enum('Video', 'Text', 'Quiz', 'assignment') not null,  -- im using enumeration for different lesson' types
    contentLink varchar(255), 
    duration int, 
    foreign key (modID) references modules(moduleID) on delete cascade
);

-- 5. Enrollments Table

create table enroll
(
	enID int auto_increment primary key,
	enCode varchar(20) unique not null, 
    cID int, 
    studID int, 
    enDate date not null,
    progress decimal(5, 2),
    status enum('Active', 'Completed', 'Dropped') not null,  -- im using enumeration for different enrollment' statuses
    foreign key (cID) references courses(courseID) on delete cascade,
    foreign key (studID) references users(userID) on delete cascade
);

 -- 6. assessments Table

create table assessment 
(
	asID int auto_increment primary key,
	asCode varchar(20) unique not null,
    lessonID int, 
    type enum('Quiz', 'assignment') not null,   -- im using enumeration for different assessment' types
    tmarks int not null, 
    submission date,
    foreign key (lessonID) references lessons(lessonID) on delete cascade
);

-- 7. Quiz Questions Table

create table quiz
(
	qID int auto_increment primary key,
    qzCode varchar(20) unique not null,
    asID int,
    qtext text not null,
    qtype enum('Code', 'Questions','Numerical Problem', 'MCQ', 'True/False') not null,  -- im using enumeration for different quiz' question type
    correct_ans text not null,
    marks int not null,
    foreign key (asID) references assessment (asID) on delete cascade
);

-- 8. assignments Table

create table assignments 
(
	asgmntID int auto_increment primary key,
    asgmntCode varchar(20) unique not null,
    lessID int, 
    description text not null,
    dueDate date not null,
    maxmarks int not null,
    foreign key (lessID) references lessons(lessonID) on delete cascade
);

-- 9. Submissions Table

create table submissions
(
	subID int auto_increment primary key,
    subCode varchar(20) unique not null,
    asID int,
    sID int,
    subDate date,
    filelink varchar(255),
    grade decimal (5, 2),
    feedback text,
    foreign key (asID) references assessment (asID) on delete cascade,
    foreign key (sID) references users(userID) on delete cascade
);

-- 10. Categories Table

create table category
(
	catID int auto_increment primary key,
    catCode varchar(20) unique not null,
    catName varchar(100) not null,
    description text
);

-- 11. Feedback/Reviews Table

create table reviews 
(
	reviewID int auto_increment primary key, 
    revCode varchar(20) unique not null,
    cID int, 
    sID int, 
    rating decimal(3, 2) not null,
    comments text,
    subDate date not null, 
    foreign key (cID) references courses(courseID) on delete cascade, 
    foreign key (sID) references users(userID) on delete cascade
);

-- 12. Certificates Table

create table certificate
(
	certID int auto_increment primary key,
    certCode varchar(20) unique not null,
    cID int, 
    sID int,
    issueDate date not null,
    certLink varchar(255),
    foreign key (cID) references courses(courseID) on delete cascade, 
    foreign key (sID) references users(userID) on delete cascade
);

-- 13. Payments Table

create table payments
(
	payID int auto_increment primary key,
    payCode varchar(20) unique not null,
    sID int, 
    cID int, 
    payDate date not null,
    amount decimal(10, 2) not null, 
    status enum('Paid', 'Pending', 'Failed') not null,   -- im using enumeration for different payment' statuses
    foreign key (cID) references courses(courseID) on delete cascade, 
    foreign key (sID) references users(userID) on delete cascade
);

-- 14. Discussion Forum Table

create table discussionForum
(
	postID int auto_increment primary key, 
    disCode varchar(20) unique not null,
    cID int, 
    sID int,
    content text,
    postDate date not null,
    foreign key (cID) references courses(courseID) on delete cascade, 
    foreign key (sID) references users(userID) on delete cascade
);

-- 15. notifications Table

create table notifications
(
	notfID int auto_increment primary key,
    notfCode varchar(20) unique not null,
    uID int, 
    message text not null,
    status enum('Read', 'Unread') not null,
    sentDate date not null,
    foreign key (uID) references users(userID) on delete cascade
);

-- 16. Badges Table

create table badges
(
	bdgID int auto_increment primary key,
    bdgCode varchar(20) unique not null,
    badgeName varchar(100) not null,
    description text,
    criteria varchar(255)
);

-- Show all the tables
show tables;

-- 1- SQL Safe mode settings:
SET SQL_SAFE_UPDATES = 0; 																				-- disables the safe update mode, which allows updates and deletes without a where clause.
-- 2. Foreign key constraint settings:
SET FOREIGN_KEY_CHECKS = 0;																				-- disables foreign key checks, allowing you to insert or update data without enforcing referential integrity constraints.

-- data insertion in Users table

insert into users (userCode, fname, lname, email, password, role, contact, dob, address) values
('L1F24FOIT1511', 'Rabia', 'Bashir', 'rabia.bashir@student.ucp.edu.pk', 'password1984', 'Admin', '03061234567', '1984-11-15', '789 Valencia, Lahore'),
('L1F22BSCS0654', 'Nayab', 'Irfan', 'nayab.0402@student.ucp.edu.pk', 'password3681', 'Student', '03001234567', '2004-05-06', '123 Johar Town, Lahore'),
('L1F24BSAI1298', 'Ali', 'Ahmed', 'ali.ahmed@student.ucp.edu.pk', 'password456', 'Student', '03011234567', '2002-05-22', '345 Model Town, Lahore'),
('L1F24BSSE3765', 'Sara', 'Ali', 'sara.ali@instructor.ucp.edu.pk', 'password789', 'instructor', '03021234567', '1985-03-15', '45 DHA, Lahore'),
('L1F24BSDS3432', 'Umar', 'Shah', 'umar.shah@student.ucp.edu.pk', 'passwordabc', 'Student', '03031234567', '2003-07-19', '90 Gulberg, Lahore'),
('L1F24BSCS8476', 'Hina', 'Farooq', 'hina.farooq@instructor.ucp.edu.pk', 'password1234', 'instructor', '03041234567', '1980-02-10', '56 Johar Town, Lahore'),
('L1F24BSAI5509', 'Zeeshan', 'Malik', 'zeeshan.malik@student.ucp.edu.pk', 'passwordxyz', 'Student', '03051234567', '2000-12-30', 'Bahria Town, Lahore'),
('L1F24FOIT0402', 'Iman', 'Fatima', 'iman.fatima0402@admin.ucp.edu.pk', 'password1235', 'Admin', '03061234567', '1990-10-28', 'Iqbal Town, Lahore'),
('L1F24BSDS7765', 'Ahmad', 'Zafar', 'ahmad.zafar@instructor.ucp.edu.pk', 'password1245', 'instructor', '03071234567', '1982-11-12', 'Cantt, Lahore'),
('L1F24BSCS5843', 'Javed', 'Iqbal', 'javed.iqbal@student.ucp.edu.pk', 'password7895', 'Student', '03081234567', '2001-01-14', 'Green Town, Lahore'),
('L1F24BSAI0291', 'Usman', 'Javed', 'usman.javed@student.ucp.edu.pk', 'password545', 'Student', '03091234567', '2004-09-05', 'Wapda Town, Lahore'),
('L1F24BSSE8716', 'Nida', 'Shaikh', 'nida.shaikh@student.ucp.edu.pk', 'password9898', 'Student', '03101234567', '2002-08-21', 'DHA Phase 5, Lahore'),
('L1F24BSDS1091', 'Farhan', 'Butt', 'farhan.butt@student.ucp.edu.pk', 'password1145', 'Student', '03111234567', '2000-05-16', 'askari 11, Lahore'),
('L1F24BSCS1234', 'Bilal', 'Ahmad', 'bilal.ahmad@student.ucp.edu.pk', 'password6535', 'Student', '03121234567', '2003-07-25', 'Cantt, Lahore'),
('L1F24BSAI2398', 'Zara', 'Hussain', 'zara.hussain@student.ucp.edu.pk', 'password8535', 'Student', '03131234567', '2001-12-19', 'Township, Lahore'),
('L1F24BSSE3241', 'Hasan', 'Khalid', 'hasan.khalid@student.ucp.edu.pk', 'password4553', 'Student', '03141234567', '2002-11-09', 'Iqbal Town, Lahore'),
('L1F24BSDS7658', 'Faizan', 'Mirza', 'faizan.mirza@instructor.ucp.edu.pk', 'password9843', 'instructor', '03151234567', '1975-03-14', 'DHA Phase 6, Lahore'),
('L1F24BSCS7352', 'Waseem', 'Khan', 'waseem.khan@student.ucp.edu.pk', 'password0090', 'Student', '03161234567', '1996-04-03', 'Cantt, Lahore'),
('L1F24BSSE1359', 'Saad', 'Riaz', 'saad.riaz@student.ucp.edu.pk', 'password7832', 'Student', '03171234567', '2003-02-27', 'Johar Town, Lahore'),
('L1F24BSSE8624', 'Iman', 'Fatima', 'iman.fatima@student.ucp.edu.pk', 'password8653', 'Student', '03181234567', '2002-01-11', 'Faisal Town, Lahore'),
('L1F24BSAI9637', 'Yasir', 'Ali', 'yasir.ali@student.ucp.edu.pk', 'password4321', 'Student', '03191234567', '2004-06-07', 'DHA Phase 3, Lahore'),
('L1F24BSEE7854', 'Ayesha', 'Khan', 'ayesha.khan@student.ucp.edu.pk', 'passwordaykhan', 'Student', '03062345678', '2001-11-12', '101 Wapda Town, Lahore'),
('L1F24BSIT5432', 'Raza', 'Qureshi', 'raza.qureshi@student.ucp.edu.pk', 'passwordrazaq', 'Student', '03072345678', '2000-08-14', '56 Township, Lahore'),
('L1F24BSEF2312', 'Bilal', 'Ahmed', 'bilal.ahmed@instructor.ucp.edu.pk', 'passwordbilal', 'instructor', '03082345678', '1975-09-05', '92 Cavalry Ground, Lahore'),
('L1F24BSCS3214', 'asma', 'Tariq', 'asma.tariq@student.ucp.edu.pk', 'passwordasma', 'Student', '03092345678', '1998-04-22', '67 GOR Colony, Lahore'),
('L1F24BSCE9821', 'Fahad', 'Butt', 'fahad.butt@instructor.ucp.edu.pk', 'passwordfahad', 'instructor', '03102345678', '1987-11-01', '12 Garden Town, Lahore'),
('L1F24BSIT4378', 'Kashif', 'Raza', 'kashif.raza@student.ucp.edu.pk', 'passwordkashif', 'Student', '03112345678', '2003-10-15', '22 Canal View, Lahore'),
('L1F24FOIT3298', 'Mariam', 'Ali', 'mariam.ali@admin.ucp.edu.pk', 'passwordmariam', 'Admin', '03122345678', '1995-12-25', '20 DHA Phase 5, Lahore'),
('L1F24BSSS8765', 'Zohaib', 'Hassan', 'zohaib.hassan@student.ucp.edu.pk', 'passwordzohaib', 'Student', '03132345678', '1999-06-08', '111 Garden Town, Lahore'),
('L1F24BSME1234', 'Shahid', 'Iqbal', 'shahid.iqbal@instructor.ucp.edu.pk', 'passwordshahid', 'instructor', '03142345678', '1982-09-19', '34 Valencia Town, Lahore'),
('L1F24BSEE6758', 'Iqra', 'Nawaz', 'iqra.nawaz@student.ucp.edu.pk', 'passwordiqra', 'Student', '03152345678', '2001-01-29', '15 askari 10, Lahore'),
('L1F24BSAI4567', 'Faisal', 'Ahmed', 'faisal.ahmed@instructor.ucp.edu.pk', 'password4567', 'instructor', '03071234567', '1975-06-15', '12 Cantt, Lahore'),
('L1F24BSCS1111', 'Ayesha', 'Ali', 'ayesha.ali@student.ucp.edu.pk', 'password1111', 'Student', '03081234567', '2005-02-20', '901 Wapda Town, Lahore'),
('L1F24BSDS2222', 'Bilal', 'Hussain', 'bilal.hussain@student.ucp.edu.pk', 'password2222', 'Student', '03091234567', '1999-11-22', '345 Iqbal Town, Lahore'),
('L1F24BSCS3333', 'Sadia', 'Malik', 'sadia.malik@instructor.ucp.edu.pk', 'password3333', 'instructor', '03101234567', '1982-03-10', '678 DHA, Lahore'),
('L1F24BSAI4444', 'Umair', 'Shah', 'umair.shah@student.ucp.edu.pk', 'password4444', 'Student', '03111234567', '2006-09-01', '890 Johar Town, Lahore'),
('L1F24BSSE5555', 'Hafsa', 'Khan', 'hafsa.khan@student.ucp.edu.pk', 'password5555', 'Student', '03121234567', '2002-04-15', '123 Model Town, Lahore'),
('L1F24BSDS6666', 'Aliya', 'Ahmed', 'aliya.ahmed@student.ucp.edu.pk', 'password6666', 'Student', '03131234567', '2003-06-22', '456 Gulberg, Lahore'),
('L1F24BSCS7777', 'Maha', 'Farooq', 'maha.farooq@instructor.ucp.edu.pk', 'password7777', 'instructor', '03141234567', '1978-09-10', '789 Wapda Town, Lahore'),
('L1F24BSAI8888', 'Rayyan', 'Malik', 'rayyan.malik@student.ucp.edu.pk', 'password8888', 'Student', '03151234567', '2004-01-12', '901 Iqbal Town, Lahore'),
('L1F24BSIT9456', 'Tahira', 'Bashir', 'tahira.bashir@student.ucp.edu.pk', 'password9456', 'Student', '03162345678', '2005-08-15', '456 Valencia Town, Lahore'),
('L1F24BSCS0123', 'Shahzad', 'Khan', 'shahzad.khan@instructor.ucp.edu.pk', 'password0123', 'instructor', '03172345678', '1985-04-22', '789 DHA Phase 6, Lahore'),
('L1F24BSSE4567', 'Laiba', 'Ahmed', 'laiba.ahmed@student.ucp.edu.pk', 'password4567', 'Student', '03182345678', '2002-10-12', '901 Wapda Town, Lahore'),
('L1F24BSDS0901', 'Furqan', 'Ali', 'furqan.ali@student.ucp.edu.pk', 'password8901', 'Student', '03192345678', '2001-05-25', '123 Model Town, Lahore'),
('L1F24BSEE2345', 'Rimsha', 'Hussain', 'rimsha.hussain@student.ucp.edu.pk', 'password2345', 'Student', '03202345678', '2004-03-17', '456 Gulberg, Lahore'),
('L1F24BSAI3456', 'Sana', 'Malik', 'sana.malik@student.ucp.edu.pk', 'password3456', 'Student', '03212345678', '2003-09-20', '789 Johar Town, Lahore'),
('L1F24BSCS4569', 'Mudassar', 'Hussain', 'mudassar.hussain@instructor.ucp.edu.pk', 'password4567', 'instructor', '03222345678', '1980-06-15', '901 DHA Phase 5, Lahore'),
('L1F24BSIT5679', 'Aqsa', 'Khan', 'aqsa.khan@student.ucp.edu.pk', 'password5678', 'Student', '03232345678', '2002-02-28', '123 Cantt, Lahore'),
('L1F24BSSE6780', 'Hamza', 'Shah', 'hamza.shah@student.ucp.edu.pk', 'password6789', 'Student', '03242345678', '2005-11-02', '456 Wapda Town, Lahore'),
('L1F24BSDS0987', 'Amna', 'Ahmed', 'amna.ahmed@student.ucp.edu.pk', 'password7890', 'Student', '03252345678', '2001-08-10', '789 Valencia Town, Lahore'),
('L1F24BSSE8901', 'Haris', 'Khan', 'haris.khan@student.ucp.edu.pk', 'password8901', 'Student', '03262345678', '2004-04-12', '901 Iqbal Town, Lahore'),
('L1F24BSAI9021', 'Sadia', 'Ali', 'sadia.ali@student.ucp.edu.pk', 'password9012', 'Student', '03272345678', '2003-06-25', '123 Model Town, Lahore'),
('L1F24BSCS2345', 'Jawad', 'Ahmed', 'jawad.ahmed@instructor.ucp.edu.pk', 'password2345', 'instructor', '03282345678', '1982-09-10', '456 DHA Phase 6, Lahore'),
('L1F24BSIT3456', 'Rabia', 'Hussain', 'rabia.hussain@student.ucp.edu.pk', 'password3456', 'Student', '03292345678', '2002-10-15', '789 Johar Town, Lahore'),
('L1F24BSCS7654', 'Uzair', 'Malik', 'uzair.malik@student.ucp.edu.pk', 'password4567', 'Student', '03302345678', '2005-05-20', '901 Wapda Town, Lahore'),
('L1F24BSDS5687', 'Hina', 'Khan', 'hina.khan@student.ucp.edu.pk', 'password5678', 'Student', '03312345678', '2001-07-12', '123 Cantt, Lahore'),
('L1F24BSDS5678', 'Hina', 'Mansoor', 'hina.mansoor@student.ucp.edu.pk', 'password5678', 'Student', '03312345678', '2001-07-12', '123 Cantt, Lahore'),
('L1F24BSEE6789', 'Ayesha', 'Bashir', 'ayesha.bashir@student.ucp.edu.pk', 'password6789', 'Student', '03322345678', '2004-02-28', '456 Valencia Town, Lahore'),
('L1F24BSAI7890', 'Faisal', 'Shah', 'faisal.shah@student.ucp.edu.pk', 'password7890', 'Student', '03332345678', '2003-09-01', '789 Model Town, Lahore'),
('L1F24BSCS8901', 'Saima', 'Ahmed', 'saima.ahmed@instructor.ucp.edu.pk', 'password8901', 'instructor', '03342345678', '1985-11-15', '901 DHA Phase 5, Lahore'),
('L1F24BSIT9012', 'Rizwan', 'Khan', 'rizwan.khan@student.ucp.edu.pk', 'password9012', 'Student', '03352345678', '2002-05-25', '123 Wapda Town, Lahore'),
('L1F24BSSE2345', 'Maham', 'Ali', 'maham.ali@student.ucp.edu.pk', 'password2345', 'Student', '03362345678', '2005-10-12', '456 Johar Town, Lahore'),
('L1F24BSDS4365', 'Hamad', 'Khan', 'hamad.khan@student.ucp.edu.pk', 'password3456', 'Student', '03372345678', '2002-06-25', '789 Valencia Town, Lahore'),
('L1F24BSCS0634', 'Nadia', 'Hussain', 'nadia.hussain@instructor.ucp.edu.pk', 'password4567', 'instructor', '03382345678', '1980-03-10', '901 DHA Phase 6, Lahore'),
('L1F24BSIT6578', 'Ahsan', 'Malik', 'ahsan.malik@student.ucp.edu.pk', 'password5678', 'Student', '03392345678', '2004-08-15', '123 Model Town, Lahore'),
('L1F24BSSE6789', 'Saba', 'Ahmed', 'saba.ahmed@student.ucp.edu.pk', 'password6789', 'Student', '03402345678', '2001-11-02', '456 Wapda Town, Lahore'),
('L1F24BSDS7890', 'Ali', 'Raza', 'ali.raza@student.ucp.edu.pk', 'password7890', 'Student', '03412345678', '2003-04-22', '789 Cantt, Lahore'),
('L1F24BSEE8901', 'Rahim', 'Khan', 'rahim.khan@student.ucp.edu.pk', 'password8901', 'Student', '03422345678', '2002-09-10', '901 Iqbal Town, Lahore'),
('L1F24BSAI9014', 'Amir', 'Hussain', 'amir.hussain@student.ucp.edu.pk', 'password9012', 'Student', '03432345678', '2005-05-25', '123 Gulberg, Lahore'),
('L1F24BSCS2134', 'Sadia', 'Bashir', 'sadia.bashir@instructor.ucp.edu.pk', 'password1234', 'instructor', '03442345678', '1982-06-15', '456 DHA Phase 5, Lahore'),
('L1F24BSIT0345', 'Umar', 'Farooq', 'umar.farooq@student.ucp.edu.pk', 'password2345', 'Student', '03452345678', '2004-02-28', '789 Johar Town, Lahore'),
('L1F24BSSE3456', 'Aisha', 'Khan', 'aisha.khan@student.ucp.edu.pk', 'password3456', 'Student', '03462345678', '2001-08-10', '901 Valencia Town, Lahore'),
('L1F24BSDS4567', 'Bilal', 'Ahmed', 'bilal.ahmed4567@student.ucp.edu.pk', 'password4567', 'Student', '03472345678', '2003-11-12', '123 Model Town, Lahore'),
('L1F24BSEE5678', 'Hassan', 'Raza', 'hassan.raza@student.ucp.edu.pk', 'password5678', 'Student', '03482345678', '2002-05-25', '456 Wapda Town, Lahore'),
('L1F24BSAI6789', 'Rashid', 'Malik', 'rashid.malik@student.ucp.edu.pk', 'password6789', 'Student', '03492345678', '2005-09-01', '789 Cantt, Lahore'),
('L1F24BSCS7890', 'Shazia', 'Hussain', 'shazia.hussain@instructor.ucp.edu.pk', 'password7890', 'instructor', '03502345678', '1985-04-22', '901 DHA Phase 6, Lahore'),
('L1F24BSIT8901', 'Waqas', 'Khan', 'waqas.khan@student.ucp.edu.pk', 'password8901', 'Student', '03512345678', '2004-06-15', '123 Iqbal Town, Lahore'),
('L1F24BSSE0914', 'Zainab', 'Ali', 'zainab.ali@student.ucp.edu.pk', 'password9012', 'Student', '03522345678', '2002-10-12', '456 Gulberg, Lahore'),
('L1F24BSDS2345', 'Fahim', 'Ahmed', 'fahim.ahmed@student.ucp.edu.pk', 'password2345', 'Student', '03532345678', '2005-07-25', '789 Valencia Town, Lahore'),
('L1F24BSCS3456', 'Rumaisa', 'Khan', 'rumaisa.khan@instructor.ucp.edu.pk', 'password3456', 'instructor', '03542345678', '1980-09-10', '901 DHA Phase 5, Lahore'),
('L1F24BSIT4567', 'Rayyan', 'Malik', 'rayyan.malik4567@student.ucp.edu.pk', 'password4567', 'Student', '03552345678', '2004-03-17', '123 Model Town, Lahore'),
('L1F24BSSE5678', 'Ayesha', 'Raza', 'ayesha.raza@student.ucp.edu.pk', 'password5678', 'Student', '03562345678', '2002-08-10', '456 Wapda Town, Lahore'),
('L1F24BSDS6789', 'Uzma', 'Hussain', 'uzma.hussain@student.ucp.edu.pk', 'password6789', 'Student', '03572345678', '2005-05-25', '789 Cantt, Lahore'),
('L1F24BSCS7891', 'Kashif', 'Ahmed', 'kashif.ahmed@instructor.ucp.edu.pk', 'password7890', 'instructor', '03582345678', '1982-11-15', '901 DHA Phase 6, Lahore'),
('L1F24BSAI8901', 'Sana', 'Khan', 'sana.khan@student.ucp.edu.pk', 'password8901', 'Student', '03592345678', '2004-09-20', '123 Iqbal Town, Lahore'),
('L1F24BSIT0812', 'Waseem', 'Ali', 'waseem.ali@student.ucp.edu.pk', 'password9012', 'Student', '03602345678', '2002-06-25', '456 Gulberg, Lahore'),
('L1F24BSSE0345', 'Rida', 'Malik', 'rida.malik@student.ucp.edu.pk', 'password2345', 'Student', '03612345678', '2005-02-28', '789 Valencia Town, Lahore'),
('L1F24BSDS3456', 'Hafiz', 'Raza', 'hafiz.raza@student.ucp.edu.pk', 'password3456', 'Student', '03622345678', '2003-10-12', '901 Model Town, Lahore'),
('L1F24BSCS4567', 'Shahida', 'Hussain', 'shahida.hussain@instructor.ucp.edu.pk', 'password4567', 'instructor', '03632345678', '1985-06-15', '456 DHA Phase 5, Lahore'),
('L1F24BSAI5678', 'Adeel', 'Ahmed', 'adeel.ahmed@student.ucp.edu.pk', 'password5678', 'Student', '03642345678', '2004-05-25', '123 Wapda Town, Lahore'),
('L1F24BSIT6789', 'Rabia', 'Khan', 'rabia.khan@student.ucp.edu.pk', 'password6789', 'Student', '03652345678', '2002-11-02', '456 Cantt, Lahore'),
('L1F24BSSE7890', 'Jawad', 'Malik', 'jawad.malik@student.ucp.edu.pk', 'password7890', 'Student', '03662345678', '2005-09-10', '789 Iqbal Town, Lahore'),
('L1F24BSDS8901', 'Sobia', 'Hussain', 'sobia.hussain@student.ucp.edu.pk', 'password8901', 'Student', '03672345678', '2003-07-25', '901 Gulberg, Lahore'),
('L1F24BSCS0196', 'Faisal', 'Raza', 'faisal.raza@instructor.ucp.edu.pk', 'password9012', 'instructor', '03682345678', '1980-04-22', '456 DHA Phase 6, Lahore'),
('L1F24BSAI1234', 'Amna', 'Ali', 'amna.ali@student.ucp.edu.pk', 'password1234', 'Student', '03692345678', '2004-10-12', '123 Valencia Town, Lahore'),
('L1F24BSIT2345', 'Haris', 'Khan', 'haris.khan2345@student.ucp.edu.pk', 'password2345', 'Student', '03702345678', '2002-08-15', '456 Model Town, Lahore'),
('L1F24BSCS5678', 'Amina', 'Khan', 'amina.khan@student.ucp.edu.pk', 'securepass123', 'Student', '03451234567', '2004-08-21', '456 Garden Town, Lahore'),
('L1F24BSAI4321', 'Rashid', 'Ali', 'rashid.ali@student.ucp.edu.pk', 'strongpass456', 'Student', '03461234567', '2003-02-10', '789 Valencia, Lahore'),
('L1F24BSDS6543', 'Fatima', 'Shaikh', 'fatima.shaikh@instructor.ucp.edu.pk', 'instructorpass789', 'instructor', '03471234567', '1980-09-25', '23 DHA Phase 2, Lahore'),
('L1F24BSEE9876', 'Bilal', 'Qureshi', 'bilal.qureshi@student.ucp.edu.pk', 'studentpass101', 'Student', '03481234567', '2005-04-11', '45 Johar Town, Lahore'),
('L1F24FOIT0400', 'Noman', 'Butt', 'noman.butt@admin.ucp.edu.pk', 'adminpass202', 'Admin', '03491234567', '1991-11-07', '12 Cantt, Lahore');

-- data insertion in Courses table

insert into courses (courseCode, courseName, description, category, level, instID, duration, language) values

('ITC101', 'introduction to Computer Science', 'Basic concepts of computer science, including algorithms, data structures, and problem-solving techniques.', 'Computer Science', 'Beginner', 3, 30, 'English'),
('DSA102', 'Data Structures and Algorithms', 'An in-depth course on data structures such as arrays, linked lists, trees, graphs, and algorithm design techniques.', 'Computer Science', 'intermediate', 5, 45, 'English'),
('AI103', 'Artificial intelligence', 'introduction to artificial intelligence, including machine learning, neural networks, and deep learning.', 'Computer Science', 'Advanced', 4, 60, 'English'),
('WD104', 'Web Development', 'Comprehensive guide to front-end and back-end web development technologies like HTML, CSS, Javascript, and databases.', 'Software Engineering', 'Beginner', 6, 40, 'English'),
('DBMS105', 'Database Management Systems', 'Covers database models, SQL, and modern database management practices.', 'information Technology', 'intermediate', 7, 35, 'English'),
('MAD106', 'Mobile App Development', 'Focuses on android and iOS app development using modern frameworks like Flutter.', 'Software Engineering', 'intermediate', 8, 50, 'English'),
('CF107', 'Cybersecurity Fundamentals', 'Essential topics in cybersecurity, including encryption, network security, and ethical hacking.', 'information Technology', 'Beginner', 9, 30, 'English'),
('CC108', 'Cloud Computing', 'Explores cloud computing architectures, deployment models, and services like AWS and Azure.', 'Computer Science', 'Advanced', 10, 55, 'English'),
('BDA109', 'Big Data Analytics', 'Covers the use of tools like Hadoop and Spark to analyze large datasets.', 'Data Science', 'Advanced', 11, 60, 'English'),
('ML110', 'Machine Learning', 'Foundational machine learning algorithms and their real-world applications.', 'Artificial intelligence', 'intermediate', 4, 50, 'English'),
('NLP111', 'Natural Language Processing', 'Advanced techniques for understanding and processing human language using AI.', 'Artificial intelligence', 'Advanced', 5, 55, 'English'),
('DM112', 'Digital Marketing', 'Covers SEO, social media marketing, and analytics for effective digital marketing strategies.', 'Marketing', 'Beginner', 12, 25, 'Urdu'),
('BD113', 'Blockchain Development', 'introduction to blockchain technology, including smart contracts and decentralized applications.', 'information Technology', 'Advanced', 6, 60, 'English'),
('SEP114', 'Software Engineering Practices', 'Principles of software engineering, including Agile, Scrum, and DevOps.', 'Software Engineering', 'intermediate', 7, 40, 'English'),
('OS115', 'Operating Systems', 'Comprehensive course on operating systems, including process management, memory management, and concurrency.', 'Computer Science', 'Advanced', 3, 45, 'English'),
('DSF116', 'Data Science Foundations', 'introductory course on data science, covering Python, R, and basic data analysis techniques.', 'Data Science', 'Beginner', 11, 35, 'English'),
('GD117', 'Game Development', 'Focuses on game design and development using engines like Unity and Unreal.', 'Software Engineering', 'intermediate', 8, 50, 'English'),
('AN118', 'Advanced Networking', 'Covers network design, routing protocols, and advanced networking topics.', 'information Technology', 'Advanced', 9, 60, 'English'),
('IOT119', 'internet of Things (IoT)', 'introduction to IoT architectures, communication protocols, and security concerns.', 'Computer Science', 'intermediate', 10, 45, 'English'),
('HCI120', 'Human-Computer interaction', 'Focuses on the design and evaluation of user interfaces for digital systems.', 'Software Engineering', 'Beginner', 12, 30, 'English'),
('WEB104', 'Web Development Basics', 'introduction to HTML, CSS, and Javascript for building web applications.', 'information Technology', 'Beginner', 5, 40, 'English'),
('DB105', 'Database Systems', 'Learn the fundamentals of relational databases and SQL.', 'Computer Science', 'intermediate', 3, 50, 'English'),
('MLO106', 'Machine Learning Operations', 'An advanced course on deploying and maintaining machine learning systems.', 'Artificial intelligence', 'Advanced', 4, 60, 'English'),
('SE107', 'Software Engineering Principles', 'Principles of software development and design patterns.', 'Software Engineering', 'intermediate', 3, 45, 'English'),
('DEV108', 'DevOps Basics', 'introduction to DevOps, including CI/CD pipelines and automation.', 'information Technology', 'Beginner', 5, 30, 'English'),
('CV109', 'Computer Vision', 'Advanced techniques for image processing and computer vision.', 'Artificial intelligence', 'Advanced', 4, 50, 'English'),
('CS110', 'Cybersecurity Fundamentals', 'Basics of cybersecurity, cryptography, and network security.', 'information Technology', 'Beginner', 5, 40, 'English'),
('PP111', 'Python Programming', 'Learn programming concepts and Python for data analysis and web development.', 'Computer Science', 'Beginner', 3, 30, 'English'),
('CDA112', 'Cloud Data Architecture', 'Design and implement cloud data solutions.', 'information Technology', 'Advanced', 5, 60, 'English'),
('DM113', 'Digital Marketing', 'introduction to SEO, social media marketing, and content creation.', 'Marketing', 'intermediate', 3, 40, 'English'),
('OOP101', 'Object-Oriented Programming', 'introduction to OOP concepts, including classes, objects, inheritance.', 'Computer Science', 'intermediate', 3, 30, 'English'),
('DSA303', 'Advanced Data Structures', 'in-depth study of advanced data structures like graphs, hash tables.', 'Computer Science', 'Advanced', 5, 45, 'English'),
('AI404', 'Machine Learning', 'Hands-on course on machine learning, including supervised and unsupervised learning.', 'Computer Science', 'Advanced', 4, 60, 'English'),
('NET101', 'Computer Networks', 'introduction to computer networks, including protocols, network architecture.', 'Computer Science', 'Beginner', 2, 30, 'English'),
('SEC102', 'Cyber Security', 'introduction to cyber security, including threats, vulnerabilities, security measures.', 'Computer Science', 'Beginner', 1, 30, 'English'),
('DBA103', 'Database Management', 'introduction to database management systems, including SQL, NoSQL.', 'Computer Science', 'intermediate', 6, 45, 'English'),
('AI505', 'Deep Learning', 'Hands-on course on deep learning, including neural networks, convolutional networks.', 'Computer Science', 'Advanced', 4, 60, 'English'),
('ITC606', 'Software Engineering', 'introduction to software engineering, including design patterns, testing.', 'Computer Science', 'intermediate', 3, 45, 'English'),
('NET707', 'Network Security', 'in-depth study of network security, including cryptography, firewalls.', 'Computer Science', 'Advanced', 2, 60, 'English'),
('DBA808', 'Database Administration', 'Hands-on course on database administration, including performance tuning.', 'Computer Science', 'intermediate', 6, 45, 'English'),
('ITC909', 'IT Project Management', 'introduction to IT project management, including Agile methodologies.', 'Computer Science', 'intermediate', 3, 45, 'English'),
('VR101', 'Virtual Reality Development', 'Building immersive VR experiences using Unity and Unreal.', 'Software Engineering', 'Advanced', 7, 50, 'English'),
('EM102', 'Embedded Systems Programming', 'Programming microcontrollers and embedded systems.', 'Computer Science', 'intermediate', 3, 40, 'English'),
('WC103', 'Web Content Creation', 'Designing and developing engaging web content.', 'Digital Media', 'Beginner', 2, 30, 'English'),
('DBS104', 'Database Security', 'Securing databases from threats and vulnerabilities.', 'information Technology', 'Advanced', 6, 45, 'English'),
('MLT105', 'Machine Learning with TensorFlow', 'Building machine learning models using TensorFlow.', 'Artificial intelligence', 'intermediate', 4, 50, 'English'),
('CVI106', 'Computer Vision Fundamentals', 'introduction to computer vision concepts and techniques.', 'Artificial intelligence', 'Beginner', 5, 40, 'English'),
('NW107', 'Network Fundamentals', 'introduction to computer networks and protocols.', 'Computer Science', 'Beginner', 1, 30, 'English'),
('SE108', 'Software Engineering Methodologies', 'Agile, Scrum, and other software development methodologies.', 'Software Engineering', 'intermediate', 3, 45, 'English'),
('DM109', 'Digital Marketing Analytics', 'Measuring and optimizing digital marketing campaigns.', 'Marketing', 'intermediate', 2, 40, 'English'),
('AI110', 'Artificial intelligence Ethics', 'Examining AI ethics and responsible AI development.', 'Artificial intelligence', 'Advanced', 4, 50, 'English'),
('CS111', 'Cybersecurity Threats', 'Identifying and mitigating cybersecurity threats.', 'information Technology', 'Beginner', 5, 30, 'English'),
('GD112', 'Game Design Principles', 'Designing engaging and interactive games.', 'Digital Media', 'intermediate', 6, 45, 'English'),
('DBA113', 'Database Administration', 'Managing and optimizing databases.', 'information Technology', 'intermediate', 3, 40, 'English'),
('IT114', 'IT Project Management', 'Managing IT projects and teams.', 'information Technology', 'intermediate', 2, 45, 'English'),
('ML115', 'Machine Learning with PyTorch', 'Building machine learning models using PyTorch.', 'Artificial intelligence', 'intermediate', 4, 50, 'English'),
('NW116', 'Network Architecture', 'Designing and optimizing network architecture.', 'Computer Science', 'Advanced', 1, 60, 'English'),
('SE117', 'Software Development Life Cycle', 'Understanding the software development life cycle.', 'Software Engineering', 'intermediate', 3, 45, 'English'),
('DM118', 'Digital Marketing Strategies', 'Developing effective digital marketing strategies.', 'Marketing', 'intermediate', 2, 40, 'English'),
('AI119', 'AI for Healthcare', 'Applying AI in healthcare and medical applications.', 'Artificial intelligence', 'Advanced', 4, 50, 'English'),
('CS120', 'Cloud Security', 'Securing cloud computing environments.', 'information Technology', 'Advanced', 5, 60, 'English'),
('GD121', 'Game Development with Unity', 'Building games using Unity.', 'Digital Media', 'intermediate', 6, 45, 'English'),
('DBA122', 'Database Modeling', 'Designing and modeling databases.', 'information Technology', 'intermediate', 3, 40, 'English'),
('IT123', 'IT Service Management', 'Managing IT services and support.', 'information Technology', 'intermediate', 2, 45, 'English'),
('ML124', 'Machine Learning with R', 'Building machine learning models using R.', 'Artificial intelligence', 'intermediate', 4, 50, 'English'),
('NW125', 'Network Protocol Analysis', 'Analyzing network protocols and performance.', 'Computer Science', 'Advanced', 1, 60, 'English'),
('BCA201', 'Blockchain Architecture', 'Designing and implementing blockchain solutions.', 'Computer Science', 'Advanced', 7, 60, 'English'),
('DVA202', 'Data Visualization and Analytics', 'Visualizing and analyzing data for insights.', 'Data Science', 'intermediate', 4, 50, 'English'),
('WDA203', 'Web Development with Angular', 'Building web applications using Angular.', 'Software Engineering', 'intermediate', 3, 45, 'English'),
('ICS204', 'information Security and Compliance', 'Ensuring information security and compliance.', 'information Technology', 'Advanced', 6, 60, 'English'),
('MLO205', 'Machine Learning Operations', 'Deploying and managing machine learning models.', 'Artificial intelligence', 'Advanced', 5, 55, 'English'),
('CVD206', 'Computer Vision and Deep Learning', 'Applying deep learning to computer vision.', 'Artificial intelligence', 'Advanced', 4, 60, 'English'),
('NTA207', 'Network Threat Analysis', 'Identifying and mitigating network threats.', 'Computer Science', 'intermediate', 2, 45, 'English'),
('SDM208', 'Software Development Methodologies', 'Agile, Scrum, and other software development methodologies.', 'Software Engineering', 'intermediate', 3, 45, 'English'),
('DMA209', 'Digital Marketing Automation', 'Automating digital marketing campaigns.', 'Marketing', 'intermediate', 2, 40, 'English'),
('AIE210', 'Artificial intelligence Ethics and Law', 'Examining AI ethics and law.', 'Artificial intelligence', 'Advanced', 4, 55, 'English'),
('CYB211', 'Cybersecurity Fundamentals', 'introduction to cybersecurity concepts.', 'information Technology', 'Beginner', 5, 30, 'English'),
('GDD212', 'Game Development with Unreal Engine', 'Building games using Unreal Engine.', 'Digital Media', 'intermediate', 6, 50, 'English'),
('DBS213', 'Database Security and Compliance', 'Securing databases and ensuring compliance.', 'information Technology', 'Advanced', 6, 60, 'English'),
('ITP214', 'IT Project Planning and Management', 'Planning and managing IT projects.', 'information Technology', 'intermediate', 2, 45, 'English'),
('MLP215', 'Machine Learning with Python', 'Building machine learning models using Python.', 'Artificial intelligence', 'intermediate', 4, 50, 'English'),
('NPA216', 'Network Protocol Analysis and Design', 'Analyzing and designing network protocols.', 'Computer Science', 'Advanced', 1, 60, 'English'),
('SEM217', 'Software Engineering Management', 'Managing software development teams.', 'Software Engineering', 'intermediate', 3, 45, 'English'),
('DMC218', 'Digital Marketing Communications', 'Developing effective digital marketing communications.', 'Marketing', 'intermediate', 2, 40, 'English'),
('AIF219', 'AI for Finance', 'Applying AI in finance and banking.', 'Artificial intelligence', 'Advanced', 4, 55, 'English'),
('CYA220', 'Cybersecurity Awareness and Training', 'Raising cybersecurity awareness and training.', 'information Technology', 'Beginner', 5, 30, 'English'),
('GDA221', 'Game Development with Unity and C#', 'Building games using Unity and C#.', 'Digital Media', 'intermediate', 6, 50, 'English'),
('DBM222', 'Database Modeling and Design', 'Designing and modeling databases.', 'information Technology', 'intermediate', 3, 45, 'English'),
('ITS223', 'IT Service and Support', 'Providing IT service and support.', 'information Technology', 'intermediate', 2, 45, 'English'),
('MLR224', 'Machine Learning with R and Python', 'Building machine learning models using R and Python.', 'Artificial intelligence', 'intermediate', 4, 50, 'English'),
('NPC225', 'Network Planning and Configuration', 'Planning and configuring networks.', 'Computer Science', 'intermediate', 1, 45, 'English'),
('SED226', 'Software Engineering Design Patterns', 'Applying design patterns to software development.', 'Software Engineering', 'intermediate', 3, 45, 'English'),
('DMS227', 'Digital Marketing Strategy and Planning', 'Developing digital marketing strategies.', 'Marketing', 'intermediate', 2, 40, 'English'),
('AIC228', 'AI for Cybersecurity', 'Applying AI in cybersecurity.', 'Artificial intelligence', 'Advanced', 4, 55, 'English'),
('CYI229', 'Cybersecurity incident Response', 'Responding to cybersecurity incidents.', 'information Technology', 'Advanced', 5, 60, 'English'),
('GDE230', 'Game Development with Java', 'Building games using Java.', 'Digital Media', 'intermediate', 6, 50, 'English'),
('DBT231', 'Database Testing and Quality assurance', 'Ensuring database quality and reliability.', 'information Technology', 'intermediate', 3, 45, 'English'),
('ITM232', 'IT Management and Leadership', 'Leading and managing IT teams.', 'information Technology', 'intermediate', 2, 45, 'English'),
('MLN233', 'Machine Learning with Neural Networks', 'Building machine learning models with neural networks.', 'Artificial intelligence', 'Advanced', 4, 60, 'English'),
('NCS234', 'Network Configuration and Security', 'Configuring and securing networks.', 'Computer Science', 'intermediate', 1, 45, 'English'),
('SEF235', 'Software Engineering for Cloud Computing', 'Developing cloud-based software.', 'Software Engineering', 'intermediate', 3, 45, 'English'),
('DMO236', 'Digital Marketing Optimization', 'Optimizing digital marketing campaigns.', 'Marketing', 'intermediate', 2, 40, 'English'),
('AII237', 'AI for Image and Video Processing', 'Applying AI to image and video processing.', 'Artificial intelligence', 'Advanced', 4, 55, 'English'),
('CYF238', 'Cybersecurity Frameworks and Compliance', 'Ensuring cybersecurity compliance.', 'information Technology', 'Advanced', 5, 60, 'English'),
('GDP239', 'Game Development Pipelines', 'Managing game development pipelines.', 'Digital Media', 'intermediate', 6, 50, 'English'),
('DBW240', 'Database Warehousing and Business intelligence', 'Designing database warehouses and business intelligence solutions.', 'information Technology', 'intermediate', 3, 45, 'English'),
('ITE241', 'IT Ethics and Professionalism', 'Understanding IT ethics and professionalism.', 'information Technology', 'Beginner', 2, 30, 'English'),
('MLC242', 'Machine Learning for Cybersecurity', 'Applying machine learning to cybersecurity.', 'Artificial intelligence', 'Advanced', 4, 60, 'English'),
('NSE243', 'Network Security Essentials', 'Understanding network security fundamentals.', 'Computer Science', 'Beginner', 1, 30, 'English');

-- data insertion in Modules table

insert into modules (modCode, cID, moduleName, content) values

('ITA101', 1, 'introduction to Algorithms', 'This module covers the basics of algorithms, including sorting and searching.'),
('DSB102', 1, 'Data Structures Basics', 'Learn about different data structures such as arrays, linked lists, and trees.'),
('ADT103', 2, 'Algorithm Design', 'This module covers advanced algorithm design techniques like greedy algorithms and dynamic programming.'),
('MLB104', 3, 'Machine Learning Basics', 'introduction to machine learning algorithms such as linear regression and classification.'),
('NN105', 3, 'Neural Networks', 'Deep dive into neural networks and their applications.'),
('HC106', 4, 'HTML & CSS', 'Learn how to design web pages using HTML and CSS.'),
('SQF107', 5, 'SQL Fundamentals', 'introduction to SQL commands, queries, and database design.'),
('BMUI108', 6, 'Building Mobile UIs', 'Learn to build user interfaces for mobile apps using Flutter.'),
('IC109', 7, 'introduction to Cryptography', 'Basic concepts of encryption and security algorithms.'),
('AWF110', 8, 'AWS Fundamentals', 'Learn to use AWS services to build scalable applications.'),
('DBA104', 4, 'introduction to Databases', 'This module introduces relational databases and SQL queries.'),
('WEBD105', 1, 'HTML & CSS Basics', 'This module covers the basics of HTML and CSS for building web pages.'),
('DS106', 2, 'Advanced Data Structures', 'This module explores complex data structures like heaps and graphs.'),
('MLO107', 3, 'Deploying ML Models', 'This module focuses on deploying machine learning models in production.'),
('CV108', 6, 'Image Processing Techniques', 'This module covers basic image processing techniques in OpenCV.'),
('SE109', 4, 'Software Development Life Cycle', 'Learn the phases of the software development life cycle.'),
('AI110', 2, 'Neural Networks', 'introduction to neural networks and deep learning architectures.'),
('WEB111', 1, 'Javascript Fundamentals', 'This module introduces Javascript for adding interactivity to web pages.'),
('SEC112', 9, 'Cybersecurity Threats', 'Learn about different types of cyber threats and prevention techniques.'),
('PY113', 5, 'Python Libraries', 'An introduction to key Python libraries like NumPy and Pandas.'),
('ITM101', 4, 'introduction to OOP', 'Basics of object-oriented programming'),
('DSM202', 5, 'Data Structures in Practice', 'Real-world applications of data structures'),
('AIM303', 6, 'Machine Learning Fundamentals', 'introduction to machine learning concepts'),
('NET401', 7, 'Network Fundamentals', 'introduction to computer networks'),
('SEC501', 8, 'Security Threats', 'Common security threats and vulnerabilities'),
('DBM601', 9, 'Database Design', 'Designing efficient databases'),
('Ain702', 10, 'Deep Learning Applications', 'Real-world applications of deep learning'),
('ITM803', 11, 'Software Testing', 'introduction to software testing methodologies'),
('NET904', 12, 'Network Architecture', 'Designing network architecture'),
('DBM1005', 13, 'Database Security', 'Securing databases'),
('CMP101', 14, 'Computer Vision Fundamentals', 'introduction to computer vision concepts'),
('DAT102', 15, 'Data Mining Techniques', 'Exploring data mining algorithms and applications'),
('SEC103', 16, 'Cybersecurity Frameworks', 'Understanding cybersecurity frameworks and standards'),
('NET104', 17, 'Network Protocol Analysis', 'Analyzing network protocols and performance'),
('DBM105', 18, 'Database Administration', 'Managing and optimizing databases'),
('AIM106', 19, 'Artificial intelligence Ethics', 'Examining AI ethics and responsible AI development'),
('WEB107', 20, 'Web Development Frameworks', 'Using popular web development frameworks'),
('ITM108', 21, 'IT Project Management', 'Managing IT projects and teams'),
('MLB109', 22, 'Machine Learning with TensorFlow', 'Building machine learning models with TensorFlow'),
('CVT110', 23, 'Computer Vision Techniques', 'Advanced computer vision techniques and applications'),
('SEC111', 24, 'Secure Coding Practices', 'Writing secure code and avoiding vulnerabilities'),
('NET112', 25, 'Network Security Measures', 'Implementing network security measures and protocols'),
('DBM113', 26, 'Database Modeling', 'Designing and modeling databases'),
('AIM114', 27, 'AI for Healthcare', 'Applying AI in healthcare and medical applications'),
('WEB115', 28, 'Web Scraping and Crawling', 'Extracting data from websites and web pages'),
('ITM116', 29, 'IT Service Management', 'Managing IT services and support'),
('MLB117', 30, 'Machine Learning with PyTorch', 'Building machine learning models with PyTorch'),
('CVT118', 31, 'Computer Vision Applications', 'Real-world applications of computer vision'),
('SEC119', 32, 'Compliance and Risk Management', 'Managing compliance and risk in IT'),
('NET120', 33, 'Network Architecture Design', 'Designing network architecture and infrastructure'),
('DCS301', 34, 'Distributed Computing Systems', 'Designing and implementing distributed systems'),
('EMT302', 35, 'Embedded Systems Programming', 'Programming embedded systems and microcontrollers'),
('GIS303', 36, 'Geographic information Systems', 'Working with GIS data and applications'),
('HPC304', 37, 'High-Performance Computing', 'Optimizing code for high-performance computing'),
('IST305', 38, 'information Security Threats', 'Identifying and mitigating information security threats'),
('MDS306', 39, 'Mobile Device Security', 'Securing mobile devices and data'),
('NLP307', 40, 'Natural Language Processing', 'Processing and analyzing human language'),
('OSC308', 41, 'Operating System Concepts', 'Understanding operating system design and implementation'),
('PCS309', 42, 'Parallel Computing Systems', 'Designing and optimizing parallel computing systems'),
('RDT310', 43, 'Relational Database Theory', 'Understanding relational database design and optimization'),
('SDE311', 44, 'Software Development Engineering', 'Applying engineering principles to software development'),
('TWC312', 45, 'Telecommunications and Wireless Networks', 'Designing and optimizing telecommunications networks'),
('VCS313', 46, 'Version Control Systems', 'Using version control systems for collaborative development'),
('WDS314', 47, 'Web Development Security', 'Securing web applications and data'),
('XSS315', 48, 'Cross-Site Scripting Prevention', 'Preventing XSS attacks and vulnerabilities'),
('YUB316', 49, 'User Experience Design', 'Designing user-centered interfaces and experiences'),
('ZEN317', 50, 'Zen Coding Practices', 'Applying Zen principles to coding and software development'),
('ACS318', 51, 'Algorithmic Complexity Analysis', 'Analyzing algorithmic complexity and optimization'),
('BCS319', 52, 'Blockchain and Cryptocurrency', 'Understanding blockchain technology and cryptocurrency'),
('CCS320', 53, 'Cloud Computing Security', 'Securing cloud computing environments'),
('DCS321', 54, 'Data Center Design and Operations', 'Designing and managing data centers'),
('ECS322', 55, 'Embedded Cybersecurity Systems', 'Securing embedded systems and devices'),
('FSE323', 56, 'Formal Software Engineering', 'Applying formal methods to software development'),
('GDS324', 57, 'Game Development and Simulation', 'Creating games and simulations using programming languages'),
('HIS325', 58, 'History of Computing', 'Exploring the history and evolution of computing'),
('ICS326', 59, 'information and Communication Systems', 'Designing and optimizing information and communication systems'),
('JSS327', 60, 'Javascript and Web Development', 'Building web applications using Javascript'),
('KDT401', 61, 'Knowledge Discovery in Text', 'Extracting insights from text data'),
('LCA402', 62, 'Life Cycle assessment', 'Evaluating environmental impacts of products'),
('MCS403', 63, 'Mobile Cloud Services', 'Designing cloud-based mobile services'),
('NAN404', 64, 'Nanotechnology and Computing', 'Exploring nanotechnology applications in computing'),
('OOP405', 65, 'Object-Oriented Programming', 'Designing and implementing object-oriented systems'),
('PDS406', 66, 'Parallel and Distributed Systems', 'Designing scalable parallel and distributed systems'),
('QCC407', 67, 'Quality Control and Testing', 'Ensuring software quality through testing'),
('RDS408', 68, 'Relational Database Systems', 'Designing and optimizing relational databases'),
('SEC409', 69, 'Secure Software Development', 'Writing secure software and avoiding vulnerabilities'),
('TBS410', 70, 'Testing and Bug Fixing', 'Identifying and resolving software bugs'),
('UCD411', 71, 'User-Centered Design', 'Designing interfaces and experiences'),
('VME412', 72, 'Virtual Machine Environments', 'Configuring and optimizing virtual machines'),
('WAN413', 73, 'Wide Area Networks', 'Designing and optimizing wide area networks'),
('XSS414', 74, 'Cross-Site Scripting Defense', 'Preventing XSS attacks and vulnerabilities'),
('YML415', 75, 'YAML and Markup Languages', 'Working with YAML and markup languages'),
('ZFS416', 76, 'ZFS File System', 'Configuring and managing ZFS file systems'),
('ACS417', 77, 'Algorithmic Complexity', 'Analyzing algorithmic complexity and optimization'),
('BDA418', 78, 'Big Data Analytics', 'Analyzing and processing large datasets'),
('CCP419', 79, 'Cloud Computing Platforms', 'Deploying applications on cloud platforms'),
('DMS420', 80, 'Data Management Systems', 'Designing and optimizing data management systems'),
('ACS421', 81, 'Advanced Computer Vision', 'Deep learning techniques for image processing'),
('BDA422', 82, 'Big Data Visualization', 'Data visualization tools for large datasets'),
('CCP423', 83, 'Cloud Computing Security Measures', 'Securing cloud-based applications'),
('DMS424', 84, 'Database Management Systems', 'Designing and optimizing database systems'),
('ECS425', 85, 'Embedded Cybersecurity Systems', 'Securing IoT devices'),
('FSE426', 86, 'Formal Software Engineering Methods', 'Applying formal methods to software development'),
('GDS427', 87, 'Game Development with AI', 'integrating AI in game development'),
('HIS428', 88, 'History of Artificial intelligence', 'Exploring AI"s evolution'),
('ICS429', 89, 'information and Communication Systems Security', 'Securing communication networks'),
('JSS430', 90, 'Javascript Frameworks', 'Building web applications with Javascript frameworks'),
('KDT431', 91, 'Knowledge Discovery in Databases', 'Data mining techniques'),
('LCA432', 92, 'Life Cycle assessment and Sustainability', 'Evaluating environmental impacts'),
('MCS433', 93, 'Mobile Cloud Computing', 'Designing cloud-based mobile services'),
('NAN434', 94, 'Nanotechnology and Computing Applications', 'Exploring nanotechnology in computing'),
('OOP435', 95, 'Object-Oriented Programming Principles', 'Designing object-oriented systems'),
('PDS436', 96, 'Parallel and Distributed Computing', 'Designing scalable systems'),
('QCC437', 97, 'Quality Control and assurance', 'Ensuring software quality'),
('RDS438', 98, 'Relational Database Design', 'Optimizing relational databases'),
('SEC439', 99, 'Secure Coding Practices', 'Writing secure software'),
('TBS440', 100, 'Testing and Bug Fixing Strategies', 'Identifying and resolving software bugs');

-- data insertion in Lessons table

insert into lessons (lessnCode, modID, ltitle, contentType, contentLink, duration) values
('L001', 1, 'Bubble Sort and insertion Sort', 'Video', 'https://example.com/bubble-sort', 20),
('L002', 1, 'Searching Algorithms', 'Video', 'https://example.com/searching-algorithms', 25),
('L003', 2, 'Linked List Operations', 'Text', 'https://example.com/linked-list', 15),
('L004', 2, 'Binary Trees', 'Text', 'https://example.com/binary-trees', 30),
('L005', 3, 'Dynamic Programming', 'Video', 'https://example.com/dynamic-programming', 40),
('L006', 4, 'Linear Regression', 'Video', 'https://example.com/linear-regression', 35),
('L007', 5, 'Convolutional Neural Networks', 'Video', 'https://example.com/cnn', 50),
('L008', 6, 'HTML Basics', 'assignment', 'https://example.com/html-assignment', 10),
('L009', 7, 'introduction to SQL', 'Text', 'https://example.com/sql-intro', 20),
('L0010', 8, 'Building Forms in Flutter', 'Quiz', 'https://example.com/flutter-forms', 25),
('LSN101', 1, 'Algorithm Basics', 'Video', 'www.example.com/algorithms-basics', 20),
('LSN102', 2, 'Data Structures in Action', 'Video', 'www.example.com/data-structures', 25),
('LSN103', 3, 'Greedy Algorithms', 'Text', 'www.example.com/greedy-algorithms', 15),
('LSN104', 4, 'HTML Tags & Structure', 'Text', 'www.example.com/html-tags', 10),
('LSN105', 5, 'Deploying ML Models', 'Video', 'www.example.com/ml-deployment', 30),
('LSN106', 6, 'Computer Vision Applications', 'Text', 'www.example.com/cv-applications', 20),
('LSN107', 7, 'SDLC Phases', 'PDF', 'www.example.com/sdlc-phases', 15),
('LSN108', 8, 'Neural Network Basics', 'Video', 'www.example.com/neural-network', 25),
('LSN109', 9, 'Javascript Event Handling', 'Video', 'www.example.com/js-event-handling', 18),
('LSN110', 10, 'Cybersecurity Best Practices', 'PDF', 'www.example.com/cybersecurity-best-practices', 20),
('ITL101', 1, 'OOP Basics', 'Video', '(link unavailable)', 30),
('DSL202', 2, 'Data Structures Tutorial', 'Text', '(link unavailable)', 45),
('AIL303', 3, 'Machine Learning Demo', 'interactive', '(link unavailable)', 60),
('NET401', 4, 'Network Fundamentals', 'Video', '(link unavailable)', 30),
('SEC501', 5, 'Security Threats', 'Text', '(link unavailable)', 45),
('DBM601', 6, 'Database Design', 'interactive', '(link unavailable)', 60),
('Ain702', 7, 'Deep Learning Applications', 'Video', '(link unavailable)', 30),
('ITM803', 8, 'Software Testing', 'Text', '(link unavailable)', 45),
('NET904', 9, 'Network Architecture', 'interactive', '(link unavailable)', 60),
('DBM1005', 10, 'Database Security', 'Video', '(link unavailable)', 30),
('L011', 1, 'Merge Sort and Quick Sort', 'Video', '(link unavailable)', 25),
('L012', 2, 'Stacks and Queues', 'Text', '(link unavailable)', 20),
('NET905', 9, 'Network Protocols', 'interactive', '(link unavailable)', 60),
('DBM1006', 10, 'Database Modeling', 'Video', '(link unavailable)', 35),
('L013', 3, 'Graph Algorithms', 'Video', '(link unavailable)', 30),
('L014', 4, 'Linear Algebra', 'Text', '(link unavailable)', 25),
('SEC502', 5, 'Cryptography', 'Video', '(link unavailable)', 40),
('ITM804', 8, 'Software Development Life Cycle', 'Text', '(link unavailable)', 30),
('L015', 1, 'Dynamic Memory Allocation', 'Video', '(link unavailable)', 20),
('L016', 2, 'File input/Output', 'Text', '(link unavailable)', 25),
('NET906', 9, 'Network Security Measures', 'interactive', '(link unavailable)', 60),
('DBM1007', 10, 'Database Optimization', 'Video', '(link unavailable)', 35),
('L017', 3, 'Object-Oriented Programming', 'Video', '(link unavailable)', 30),
('L018', 4, 'Data Visualization', 'Text', '(link unavailable)', 25),
('SEC503', 5, 'Web Application Security', 'Video', '(link unavailable)', 40),
('ITM805', 8, 'Testing Frameworks', 'Text', '(link unavailable)', 30),
('L019', 1, 'Concurrency and Multithreading', 'Video', '(link unavailable)', 20),
('L020', 2, 'Web Development Basics', 'Text', '(link unavailable)', 25),
('NET907', 9, 'Network Scalability', 'interactive', '(link unavailable)', 60),
('L033', 1, 'introduction to Blockchain', 'Video', '(link unavailable)', 20),
('L034', 2, 'Advanced Java Programming', 'Text', '(link unavailable)', 25),
('SEC507', 5, 'Secure Data Storage', 'Video', '(link unavailable)', 40),
('ITM809', 8, 'Software Quality assurance', 'Text', '(link unavailable)', 30),
('L035', 3, 'Web Application Development', 'Video', '(link unavailable)', 30),
('L036', 4, 'Machine Learning with Python', 'Text', '(link unavailable)', 25),
('NET911', 9, 'Network Virtualization', 'interactive', '(link unavailable)', 60),
('DBM1011', 10, 'Database Backup and Recovery', 'Video', '(link unavailable)', 35),
('L037', 1, 'Cybersecurity Threats', 'Video', '(link unavailable)', 20),
('L038', 2, 'Data Structures and Algorithms', 'Text', '(link unavailable)', 25),
('SEC508', 5, 'incident Response', 'Video', '(link unavailable)', 40),
('ITM810', 8, 'IT Service Management', 'Text', '(link unavailable)', 30),
('L039', 3, 'Cloud Migration', 'Video', '(link unavailable)', 30),
('L040', 4, 'Natural Language Processing', 'Text', '(link unavailable)', 25),
('NET912', 9, 'Network Automation', 'interactive', '(link unavailable)', 60),
('DBM1012', 10, 'Database Performance Tuning', 'Video', '(link unavailable)', 35),
('L041', 1, 'Artificial intelligence Fundamentals', 'Video', '(link unavailable)', 20),
('L042', 2, 'Web Scraping', 'Text', '(link unavailable)', 25),
('SEC509', 5, 'Compliance and Risk assessment', 'Video', '(link unavailable)', 40),
('L043', 3, 'Data Analytics with R', 'Video', '(link unavailable)', 30),
('L044', 4, 'Cloud Native Applications', 'Text', '(link unavailable)', 25),
('SEC510', 6, 'Network Security Best Practices', 'Video', '(link unavailable)', 35);

-- data insertion in Enrollment table

insert into enroll (enCode, cID, studID, enDate, progress, status) values
('REG101', 1, '8', '2024-06-15', 85.50, 'Completed'),
('REG102', 2, '5', '2024-07-10', 60.25, 'Active'),
('REG103', 3, '4', '2024-08-01', 45.00, 'Active'),
('REG104', 4, '1', '2024-09-05', 90.00, 'Completed'),
('REG105', 5, '2', '2024-09-20', 35.75, 'Active'),
('REG106', 6, '3', '2024-05-30', 65.00, 'Dropped'),
('REG107', 7, '2', '2024-07-22', 75.80, 'Active'),
('REG108', 8, '6', '2024-08-14', 50.00, 'Completed'),
('REG109', 9, '9', '2024-09-01', 20.00, 'Dropped'),
('REG110', 10, '2', '2024-07-18', 95.00, 'Completed'),
('REG111', 1, '10', '2024-09-25', 80.00, 'Active'),
('REG112', 2, '8', '2024-08-20', 70.50, 'Active'),
('REG113', 3, '1', '2024-06-01', 90.00, 'Completed'),
('REG114', 4, '5', '2024-09-10', 60.00, 'Active'),
('REG115', 6, '9', '2024-07-15', 40.00, 'Dropped'),
('REG116', 7, '4', '2024-08-25', 85.00, 'Active'),
('REG117', 8, '2', '2024-09-05', 75.00, 'Active'),
('REG118', 9, '6', '2024-06-20', 95.00, 'Completed'),
('REG119', 10, '3', '2024-07-30', 65.00, 'Active'),
('REG120', 1, '7', '2024-09-01', 50.00, 'Active'),
('REG121', 2, '10', '2024-08-01', 80.00, 'Active'),
('REG122', 3, '9', '2024-06-15', 70.00, 'Dropped'),
('REG123', 4, '1', '2024-09-20', 90.00, 'Completed'),
('REG124', 5, '8', '2024-07-22', 60.00, 'Active'),
('REG125', 6, '5', '2024-08-14', 45.00, 'Dropped'),
('REG126', 7, '2', '2024-09-10', 85.00, 'Active'),
('REG127', 8, '6', '2024-06-25', 95.00, 'Completed'),
('REG128', 9, '4', '2024-07-18', 70.00, 'Active'),
('REG129', 10, '3', '2024-08-30', 65.00, 'Active'),
('REG130', 1, '9', '2024-09-05', 50.00, 'Active'),
('REG131', 2, '7', '2024-08-05', 80.00, 'Active'),
('REG132', 3, '10', '2024-06-10', 70.00, 'Dropped'),
('REG133', 4, '2', '2024-09-25', 90.00, 'Completed'),
('REG134', 5, '1', '2024-07-20', 60.00, 'Active'),
('REG135', 6, '8', '2024-08-12', 45.00, 'Dropped'),
('REG136', 7, '6', '2024-09-15', 85.00, 'Active'),
('REG137', 8, '5', '2024-06-22', 95.00, 'Completed'),
('REG138', 9, '3', '2024-07-25', 70.00, 'Active'),
('REG139', 10, '4', '2024-08-30', 65.00, 'Active'),
('REG140', 1, '6', '2024-09-10', 50.00, 'Active'),
('REG141', 2, '9', '2024-08-08', 80.00, 'Active'),
('REG142', 3, '7', '2024-06-18', 70.00, 'Dropped'),
('REG143', 4, '10', '2024-09-28', 90.00, 'Completed'),
('REG144', 5, '2', '2024-07-25', 60.00, 'Active'),
('REG145', 6, '1', '2024-08-15', 45.00, 'Dropped'),
('REG146', 7, '8', '2024-09-20', 85.00, 'Active'),
('REG147', 8, '6', '2024-06-29', 95.00, 'Completed'),
('REG148', 9, '5', '2024-07-30', 70.00, 'Active'),
('REG149', 10, '3', '2024-08-38', 65.00, 'Active'),
('REG150', 1, '4', '2024-09-12', 50.00, 'Active'),
('REG151', 2, '6', '2024-08-10', 80.00, 'Active'),
('REG152', 3, '9', '2024-06-22', 70.00, 'Dropped'),
('REG153', 4, '7', '2024-09-30', 90.00, 'Completed'),
('REG154', 5, '10', '2024-07-28', 60.00, 'Active'),
('REG155', 6, '2', '2024-08-18', 45.00, 'Dropped'),
('REG156', 7, '1', '2024-09-25', 85.00, 'Active'),
('REG157', 8, '8', '2024-07-01', 95.00, 'Completed'),
('REG158', 9, '6', '2024-08-02', 70.00, 'Active'),
('REG159', 10, '5', '2024-09-01', 65.00, 'Active'),
('REG160', 1, '3', '2024-09-15', 50.00, 'Active'),
('REG161', 11, '2', '2024-10-01', 70.00, 'Active'),
('REG162', 12, '9', '2024-10-15', 80.00, 'Completed'),
('REG163', 13, '1', '2024-11-01', 60.50, 'Active'),
('REG164', 14, '6', '2024-11-15', 75.25, 'Completed'),
('REG165', 15, '8', '2024-12-01', 90.00, 'Completed'),
('REG166', 16, '4', '2024-12-15', 55.00, 'Active'),
('REG167', 17, '7', '2025-01-01', 65.50, 'Active'),
('REG168', 18, '3', '2025-01-15', 70.25, 'Completed'),
('REG169', 19, '2', '2025-02-01', 85.00, 'Completed'),
('REG170', 20, '5', '2025-02-15', 60.00, 'Active'),
('REG171', 21, '9', '2025-03-01', 75.50, 'Completed'),
('REG172', 22, '1', '2025-03-15', 65.25, 'Active'),
('REG173', 23, '6', '2025-04-01', 80.00, 'Completed'),
('REG174', 24, '8', '2025-04-15', 95.00, 'Completed'),
('REG175', 25, '4', '2025-05-01', 50.50, 'Active'),
('REG176', 26, '7', '2025-05-15', 70.00, 'Active'),
('REG177', 27, '3', '2025-06-01', 75.25, 'Completed'),
('REG178', 28, '2', '2025-06-15', 85.50, 'Completed'),
('REG179', 29, '5', '2025-07-01', 60.00, 'Active'),
('REG180', 30, '9', '2025-07-15', 70.50, 'Active'),
('REG181', 31, '1', '2025-08-01', 65.25, 'Active'),
('REG182', 32, '6', '2025-08-15', 80.00, 'Completed'),
('REG183', 33, '8', '2025-09-01', 90.00, 'Completed'),
('REG184', 34, '4', '2025-09-15', 55.00, 'Active'),
('REG185', 35, '7', '2025-10-01', 70.50, 'Active'),
('REG186', 36, '3', '2025-10-15', 75.25, 'Completed'),
('REG187', 37, '2', '2025-11-01', 85.50, 'Completed'),
('REG188', 38, '5', '2025-11-15', 60.00, 'Active'),
('REG189', 39, '9', '2025-12-01', 70.00, 'Active'),
('REG190', 40, '1', '2025-12-15', 65.25, 'Active'),
('REG191', 41, '6', '2026-01-01', 80.50, 'Completed'),
('REG192', 42, '8', '2026-01-15', 95.00, 'Completed'),
('REG193', 43, '4', '2026-02-01', 55.25, 'Active'),
('REG194', 44, '7', '2026-02-15', 75.00, 'Active'),
('REG195', 45, '3', '2026-03-01', 80.25, 'Completed'),
('REG196', 46, '2', '2026-03-15', 85.50, 'Completed'),
('REG197', 47, '5', '2026-04-01', 65.00, 'Active'),
('REG198', 48, '9', '2026-04-15', 70.50, 'Active'),
('REG199', 49, '1', '2026-05-01', 60.25, 'Active'),
('REG200', 50, '6', '2026-05-15', 90.00, 'Completed');

-- data insertion in assessment table

insert into assessment (asCode, lessonID, type, tmarks, submission) values
('as001', 1, 'Quiz', 20, '2024-06-20'),
('as002', 2, 'assignment', 30, '2024-07-05'),
('as003', 3, 'Quiz', 25, '2024-08-10'),
('as004', 4, 'assignment', 40, '2024-09-15'),
('as005', 5, 'Quiz', 20, '2024-07-25'),
('as006', 6, 'assignment', 35, '2024-06-30'),
('as007', 7, 'Quiz', 30, '2024-08-20'),
('as008', 8, 'assignment', 45, '2024-09-10'),
('as009', 9, 'Quiz', 25, '2024-07-15'),
('as010', 10, 'assignment', 50, '2024-06-25'),
('as011', 11, 'Quiz', 20, '2024-10-01'),
('as012', 12, 'assignment', 40, '2024-10-15'),
('as013', 13, 'Quiz', 25, '2024-11-05'),
('as014', 14, 'assignment', 45, '2024-11-20'),
('as015', 15, 'Quiz', 20, '2024-12-01'),
('as016', 16, 'assignment', 50, '2024-12-15'),
('as017', 17, 'Quiz', 30, '2025-01-05'),
('as018', 18, 'assignment', 40, '2025-01-20'),
('as019', 19, 'Quiz', 25, '2025-02-01'),
('as020', 20, 'assignment', 45, '2025-02-15'),
('as021', 21, 'Quiz', 20, '2025-03-01'),
('as022', 22, 'assignment', 50, '2025-03-15'),
('as023', 23, 'Quiz', 30, '2025-04-01'),
('as024', 24, 'assignment', 40, '2025-04-15'),
('as025', 25, 'Quiz', 25, '2025-05-01'),
('as026', 26, 'assignment', 45, '2025-05-15'),
('as027', 27, 'Quiz', 20, '2025-06-01'),
('as028', 28, 'assignment', 50, '2025-06-15'),
('as029', 29, 'Quiz', 30, '2025-07-01'),
('as030', 30, 'assignment', 40, '2025-07-15'),
('as031', 31, 'Quiz', 25, '2025-08-01'),
('as032', 32, 'assignment', 45, '2025-08-15'),
('as033', 33, 'Quiz', 20, '2025-09-01'),
('as034', 34, 'assignment', 50, '2025-09-15'),
('as035', 35, 'Quiz', 30, '2025-10-01'),
('as036', 36, 'assignment', 40, '2025-10-15'),
('as037', 37, 'Quiz', 25, '2025-11-01'),
('as038', 38, 'assignment', 45, '2025-11-15'),
('as039', 39, 'Quiz', 20, '2025-12-01'),
('as040', 40, 'assignment', 50, '2025-12-15'),
('as041', 41, 'Quiz', 30, '2026-01-05'),
('as042', 42, 'assignment', 40, '2026-01-20'),
('as043', 43, 'Quiz', 25, '2026-02-01'),
('as044', 44, 'assignment', 45, '2026-02-15'),
('as045', 45, 'Quiz', 20, '2026-03-01'),
('as046', 46, 'assignment', 50, '2026-03-15'),
('as047', 47, 'Quiz', 30, '2026-04-01'),
('as048', 48, 'assignment', 40, '2026-04-15'),
('as049', 49, 'Quiz', 25, '2026-05-01'),
('as050', 50, 'assignment', 45, '2026-05-15'),
('as051', 51, 'Quiz', 20, '2026-06-01'),
('as052', 52, 'assignment', 50, '2026-06-15'),
('as053', 53, 'Quiz', 30, '2026-07-01'),
('as054', 54, 'assignment', 40, '2026-07-15'),
('as055', 55, 'Quiz', 25, '2026-08-01'),
('as056', 56, 'assignment', 45, '2026-08-15'),
('as057', 57, 'Quiz', 20, '2026-09-01'),
('as058', 58, 'assignment', 50, '2026-09-15'),
('as059', 59, 'Quiz', 30, '2026-10-01'),
('as060', 60, 'assignment', 40, '2026-10-15'),
('as061', 61, 'Quiz', 25, '2026-11-01'),
('as062', 62, 'assignment', 45, '2026-11-15'),
('as063', 63, 'Quiz', 20, '2026-12-01'),
('as064', 64, 'assignment', 50, '2026-12-15'),
('as065', 65, 'Quiz', 30, '2027-01-05'),
('as066', 66, 'assignment', 40, '2027-01-20'),
('as067', 67, 'Quiz', 25, '2027-02-01'),
('as068', 68, 'assignment', 45, '2027-02-15'),
('as069', 69, 'Quiz', 20, '2027-03-01'),
('as070', 70, 'assignment', 50, '2027-03-15'),
('as071', 71, 'Quiz', 30, '2027-04-01'),
('as072', 72, 'assignment', 40, '2027-04-15'),
('as073', 73, 'Quiz', 25, '2027-05-01'),
('as074', 74, 'assignment', 45, '2027-05-15'),
('as075', 75, 'Quiz', 20, '2027-06-01'),
('as076', 76, 'assignment', 50, '2027-06-15'),
('as077', 77, 'Quiz', 30, '2027-07-01'),
('as078', 78, 'assignment', 40, '2027-07-15'),
('as079', 79, 'Quiz', 25, '2027-08-01'),
('as080', 80, 'assignment', 45, '2027-08-15'),
('as081', 81, 'Quiz', 20, '2027-09-01'),
('as082', 82, 'assignment', 50, '2027-09-15'),
('as083', 83, 'Quiz', 30, '2027-10-01'),
('as084', 84, 'assignment', 40, '2027-10-15'),
('as085', 85, 'Quiz', 25, '2027-11-01'),
('as086', 86, 'assignment', 45, '2027-11-15'),
('as087', 87, 'Quiz', 20, '2027-12-01'),
('as088', 88, 'assignment', 50, '2027-12-15'),
('as089', 89, 'Quiz', 30, '2028-01-05'),
('as090', 90, 'assignment', 40, '2028-01-20'),
('as091', 91, 'Quiz', 25, '2028-02-01'),
('as092', 92, 'assignment', 45, '2028-02-15'),
('as093', 93, 'Quiz', 20, '2028-03-01'),
('as094', 94, 'assignment', 50, '2028-03-15'),
('as095', 95, 'Quiz', 30, '2028-04-01'),
('as096', 96, 'assignment', 40, '2028-04-15'),
('as097', 97, 'Quiz', 25, '2028-05-01'),
('as098', 98, 'assignment', 45, '2028-05-15'),
('as099', 99, 'Quiz', 20, '2028-06-01'),
('as100', 100, 'assignment', 50, '2028-06-15'),
('as101', 101, 'Quiz', 30, '2028-07-01'),
('as102', 102, 'assignment', 40, '2028-07-15'),
('as103', 103, 'Quiz', 25, '2028-08-01'),
('as104', 104, 'assignment', 45, '2028-08-15'),
('as105', 105, 'Quiz', 20, '2028-09-01');

-- data insertion in Quiz table

insert into quiz (qzCode, asID, qtext, qtype, correct_ans, marks) values
('QZ001', 1, 'What is the time complexity of bubble sort?', 'MCQ', 'O(n^2)', 2),
('QZ002', 2, 'Write a Python function to implement a neural network', 'Code', 'def neural_network(X, y): ...', 5),
('QZ003', 3, 'What is the difference between supervised and unsupervised learning?', 'Questions', 'Supervised learning uses labeled data, while unsupervised learning uses unlabeled data', 3),
('QZ004', 4, 'What is the purpose of data normalization in machine learning?', 'MCQ', 'To scale features to a common range', 2),
('QZ005', 5, 'Write a Java function to implement a binary search tree', 'Code', 'public class BinarySearchTree { ... }', 5),
('QZ006', 6, 'What is the difference between a hash table and a binary search tree?', 'Questions', 'A hash table uses a hash function to index data, while a binary search tree uses a tree structure', 3),
('QZ007', 7, 'What is the purpose of regularization in machine learning?', 'MCQ', 'To prevent overfitting', 2),
('QZ008', 8, 'Write a Python function to implement a decision tree', 'Code', 'def decision_tree(X, y): ...', 5),
('QZ009', 9, 'What is the difference between a convolutional neural network and a recurrent neural network?', 'Questions', 'A convolutional neural network is used for image data, while a recurrent neural network is used for sequential data', 3),
('QZ010', 10, 'What is the purpose of feature engineering in machine learning?', 'MCQ', 'To select and transform features for better model performance', 2),
('QZ011', 1, 'What is the time complexity of merge sort?', 'MCQ', 'O(n log n)', 2),
('QZ012', 2, 'Write a C++ function to implement a graph', 'Code', 'class Graph { ... }', 5),
('QZ013', 3, 'What is the difference between greedy and dynamic programming?', 'Questions', 'Greedy algorithms make local choices, while dynamic programming considers global optimal solutions', 3),
('QZ014', 4, 'What is the purpose of data denormalization in database design?', 'MCQ', 'To improve query performance', 2),
('QZ015', 5, 'Write a Javascript function to implement a hash table', 'Code', 'function HashTable() { ... }', 5),
('QZ016', 6, 'What is the difference between inner and outer joins in SQL?', 'Questions', 'inner joins return matching rows, while outer joins return all rows from one table', 3),
('QZ017', 7, 'What is the purpose of ensemble methods in machine learning?', 'MCQ', 'To combine multiple models for better performance', 2),
('QZ018', 8, 'Write a Python function to implement a support vector machine', 'Code', 'def svm(X, y): ...', 5),
('QZ019', 9, 'What is the difference between precision and recall in evaluation metrics?', 'Questions', 'Precision measures true positives, while recall measures true positives and false negatives', 3),
('QZ020', 10, 'What is the purpose of clustering in data mining?', 'MCQ', 'To group similar data points', 2),
('QZ021', 1, 'What is the time complexity of quicksort?', 'MCQ', 'O(n log n)', 2),
('QZ022', 2, 'Write a Java function to implement a stack', 'Code', 'public class Stack { ... }', 5),
('QZ023', 3, 'What is the difference between breadth-first search and depth-first search?', 'Questions', 'Breadth-first search explores all nodes at a level, while depth-first search explores as far as possible along each branch', 3),
('QZ024', 4, 'What is the purpose of indexing in database design?', 'MCQ', 'To improve query performance', 2),
('QZ025', 5, 'Write a C++ function to implement a queue', 'Code', 'class Queue { ... }', 5),
('QZ026', 6, 'What is the difference between a linked list and an array?', 'Questions', 'A linked list uses pointers to connect elements, while an array stores elements contiguously', 3),
('QZ027', 7, 'What is the purpose of principal component analysis in data reduction?', 'MCQ', 'To reduce dimensions while retaining variance', 2),
('QZ028', 8, 'Write a Python function to implement a random forest', 'Code', 'def random_forest(X, y): ...', 5),
('QZ029', 9, 'What is the difference between supervised and semi-supervised learning?', 'Questions', 'Supervised learning uses labeled data, while semi-supervised learning uses both labeled and unlabeled data', 3),
('QZ030', 10, 'What is the purpose of feature selection in machine learning?', 'MCQ', 'To select relevant features for better model performance', 2),
('QZ031', 1, 'What is the time complexity of heap sort?', 'MCQ', 'O(n log n)', 2),
('QZ032', 2, 'Write a Javascript function to implement a trie', 'Code', 'function Trie() { ... }', 5),
('QZ033', 3, 'What is the difference between a hash function and a cryptographic hash function?', 'Questions', 'A hash function maps data to an index, while a cryptographic hash function is secure against collisions', 3),
('QZ034', 4, 'What is the purpose of database normalization?', 'MCQ', 'To reduce data redundancy', 2),
('QZ035', 5, 'Write a Python function to implement a gradient boosting machine', 'Code', 'def gradient_boosting(X, y): ...', 5),
('QZ036', 6, 'What is the difference between a decision tree and a random forest?', 'Questions', 'A decision tree is a single tree, while a random forest is an ensemble of trees', 3),
('QZ037', 7, 'Write a Java function to implement a binary search', 'Code', 'public class BinarySearch { ... }', 5),
('QZ038', 8, 'What is the purpose of regularization in neural networks?', 'MCQ', 'To prevent overfitting', 2),
('QZ039', 9, 'What is the difference between a convolutional neural network and a recurrent neural network?', 'Questions', 'A convolutional neural network is used for image data, while a recurrent neural network is used for sequential data', 3),
('QZ040', 10, 'What is the purpose of feature engineering in machine learning?', 'MCQ', 'To select and transform features for better model performance', 2),
('QZ041', 1, 'What is the time complexity of depth-first search?', 'MCQ', 'O(V + E)', 2),
('QZ042', 2, 'Write a Python function to implement a hash table', 'Code', 'def hash_table(X, y): ...', 5),
('QZ043', 3, 'What is the difference between supervised and unsupervised learning?', 'Questions', 'Supervised learning uses labeled data, while unsupervised learning uses unlabeled data', 3),
('QZ044', 4, 'What is the purpose of data normalization in machine learning?', 'MCQ', 'To scale features to a common range', 2),
('QZ045', 5, 'Write a C++ function to implement a graph', 'Code', 'class Graph { ... }', 5),
('QZ046', 6, 'What is the difference between a linked list and a doubly linked list?', 'Questions', 'A linked list has single pointers, while a doubly linked list has double pointers', 3),
('QZ047', 7, 'What is the purpose of ensemble methods in machine learning?', 'MCQ', 'To combine multiple models for better performance', 2),
('QZ048', 8, 'Write a Javascript function to implement a stack', 'Code', 'function Stack() { ... }', 5),
('QZ049', 9, 'What is the difference between precision and recall in evaluation metrics?', 'Questions', 'Precision measures true positives, while recall measures true positives and false negatives', 3),
('QZ050', 10, 'What is the purpose of clustering in data mining?', 'MCQ', 'To group similar data points', 2),
('QZ051', 1, 'What is the time complexity of merge sort?', 'MCQ', 'O(n log n)', 2),
('QZ052', 2, 'Write a Python function to implement a queue', 'Code', 'def queue(X, y): ...', 5),
('QZ053', 3, 'What is the difference between breadth-first search and depth-first search?', 'Questions', 'Breadth-first search explores all nodes at a level, while depth-first search explores as far as possible along each branch', 3),
('QZ054', 4, 'What is the purpose of indexing in database design?', 'MCQ', 'To improve query performance', 2),
('QZ055', 5, 'Write a Java function to implement a tree', 'Code', 'public class Tree { ... }', 5),
('QZ056', 6, 'What is the difference between monolithic and microservices architecture?', 'Questions', 'Monolithic architecture is a single unit, while microservices architecture is a collection of small services', 3),
('QZ057', 7, 'Write a Python script to scrape data from a website', 'Code', 'import requests; import BeautifulSoup; ...', 5),
('QZ058', 8, 'What is the purpose of normalization in database design?', 'MCQ', 'To reduce data redundancy', 2),
('QZ059', 9, 'Design a simple neural network using TensorFlow', 'Code', 'import tensorflow; ...', 5),
('QZ060', 10, 'What is the difference between HTTP and HTTPS?', 'Questions', 'HTTP is unsecured, while HTTPS is secured', 3),
('QZ061', 11, 'Write a Java program to implement a stack', 'Code', 'public class Stack { ... }', 5),
('QZ062', 12, 'What is the purpose of caching in web development?', 'MCQ', 'To improve performance', 2),
('QZ063', 13, 'Design a simple database schema for a e-commerce application', 'Code', 'CREATE TABLE customers ...', 5),
('QZ064', 14, 'What is the difference between CSS and CSS3?', 'Questions', 'CSS3 has additional features and improvements', 3),
('QZ065', 15, 'Write a Python script to send an email using SMTP', 'Code', 'import smtplib; ...', 5),
('QZ066', 16, 'What is the purpose of load balancing in network design?', 'MCQ', 'To distribute traffic evenly', 2),
('QZ067', 17, 'Design a simple web application using React', 'Code', 'import React; ...', 5),
('QZ068', 18, 'What is the difference between Javascript and jQuery?', 'Questions', 'Javascript is a programming language, while jQuery is a library', 3),
('QZ069', 19, 'Write a Java program to implement a queue', 'Code', 'public class Queue { ... }', 5),
('QZ070', 20, 'What is the purpose of authentication in web development?', 'MCQ', 'To verify user identity', 2),
('QZ071', 21, 'Design a simple data visualization dashboard using Tableau', 'Code', 'import tableau; ...', 5),
('QZ072', 22, 'What is the difference between XML and JSon?', 'Questions', 'XML uses tags, while JSon uses key-value pairs', 3),
('QZ073', 23, 'Write a Python script to connect to a MySQL database', 'Code', 'import mysql.connector; ...', 5),
('QZ074', 24, 'What is the purpose of firewall in network security?', 'MCQ', 'To block unauthorized access', 2),
('QZ075', 25, 'Design a simple machine learning model using scikit-learn', 'Code', 'from sklearn import ...', 5),
('QZ076', 26, 'What is the difference between Agile and Waterfall methodologies?', 'Questions', 'Agile is iterative, while Waterfall is sequential', 3),
('QZ077', 27, 'Write a Java program to implement a graph', 'Code', 'public class Graph { ... }', 5),
('QZ078', 28, 'What is the purpose of SSL/TLS in web development?', 'MCQ', 'To secure data transmission', 2),
('QZ079', 29, 'Design a simple web service using RESTful API', 'Code', 'import rest; ...', 5),
('QZ080', 30, 'What is the difference between NoSQL and relational databases?', 'Questions', 'NoSQL databases are schema-less', 3),
('QZ081', 31, 'Write a Python script to implement a decision tree', 'Code', 'from sklearn import tree; ...', 5),
('QZ082', 32, 'What is the purpose of load testing in software development?', 'MCQ', 'To measure performance under load', 2),
('QZ083', 33, 'Design a simple data analytics report using Excel', 'Code', 'import excel; ...', 5),
('QZ084', 34, 'What is the difference between clustering and classification?', 'Questions', 'Clustering groups similar data, while classification predicts a label', 3),
('QZ085', 35, 'Write a Java program to implement a hash table', 'Code', 'public class HashTable { ... }', 5),
('QZ086', 36, 'What is the purpose of database indexing?', 'MCQ', 'To improve query performance', 2),
('QZ087', 37, 'Design a simple neural network using Keras', 'Code', 'from keras import ...', 5),
('QZ088', 38, 'What is the difference between breadth-first search and depth-first search?', 'Questions', 'Breadth-first search explores all nodes at a level, while depth-first search explores as far as possible', 3),
('QZ089', 39, 'Write a Python script to implement a binary search', 'Code', 'def binary_search(arr, target): ...', 5),
('QZ090', 40, 'What is the purpose of exception handling in programming?', 'MCQ', 'To handle runtime errors', 2),
('QZ091', 41, 'Design a simple data visualization dashboard using Matplotlib', 'Code', 'import matplotlib; ...', 5),
('QZ092', 42, 'What is the difference between supervised and semi-supervised learning?', 'Questions', 'Supervised learning uses labeled data, while semi-supervised learning uses both labeled and unlabeled data', 3),
('QZ093', 43, 'Write a Java program to implement a linked list', 'Code', 'public class LinkedList { ... }', 5),
('QZ094', 44, 'What is the purpose of data normalization?', 'MCQ', 'To scale data between 0 and 1', 2),
('QZ095', 45, 'Design a simple machine learning model using PyTorch', 'Code', 'import torch; ...', 5),
('QZ096', 46, 'What is the difference between convolutional neural networks and recurrent neural networks?', 'Questions', 'Convolutional neural networks are used for image processing, while recurrent neural networks are used for sequential data', 3),
('QZ097', 47, 'Write a Python script to implement a greedy algorithm', 'Code', 'def greedy_algorithm(arr): ...', 5),
('QZ098', 48, 'What is the purpose of database denormalization?', 'MCQ', 'To improve query performance by reducing joins', 2),
('QZ099', 49, 'Design a simple natural language processing task using NLTK', 'Code', 'import nltk; ...', 5),
('QZ100', 50, 'What is the difference between hash tables and binary search trees?', 'Questions', 'Hash tables use key-value pairs, while binary search trees use node-based search', 3);

-- data insertion in assignment table

insert into assignments (asgmntCode, lessID, description, dueDate, maxmarks) values
('asGMNT001', 1, 'Implement a simple neural network using Python and TensorFlow', '2024-06-25', 20),
('asGMNT002', 2, 'Design a database schema for a e-learning application using MySQL', '2024-07-10', 30),
('asGMNT003', 3, 'Create a simple chatbot using Javascript and Node.js', '2024-08-15', 40),
('asGMNT004', 4, 'Implement a binary search algorithm using Python', '2024-09-01', 25),
('asGMNT005', 5, 'Design a simple web application using Flask and Python', '2024-07-20', 35),
('asGMNT006', 6, 'Implement a decision tree algorithm using Python and scikit-learn', '2024-08-25', 45),
('asGMNT007', 7, 'Create a simple game using Python and Pygame', '2024-09-15', 30),
('asGMNT008', 8, 'Implement a clustering algorithm using Java and Weka', '2024-07-25', 40),
('asGMNT009', 9, 'Design a simple recommender system using Python and TensorFlow', '2024-08-30', 35),
('asGMNT010', 10, 'Implement a natural language processing task using Python and NLTK', '2024-09-20', 45),
('asGMNT011', 1, 'Implement a simple regression model using Python and scikit-learn', '2024-10-01', 25),
('asGMNT012', 2, 'Design a database schema for a healthcare application using PostgreSQL', '2024-10-15', 30),
('asGMNT013', 3, 'Create a simple web scraper using Python and BeautifulSoup', '2024-11-01', 20),
('asGMNT014', 4, 'Implement a sorting algorithm using Java', '2024-11-10', 25),
('asGMNT015', 5, 'Design a simple mobile application using Flutter and Dart', '2024-11-20', 40),
('asGMNT016', 6, 'Implement a neural network using Python and Keras', '2024-12-01', 45),
('asGMNT017', 7, 'Create a simple game using Java and LibGDX', '2024-12-10', 35),
('asGMNT018', 8, 'Implement a recommendation system using Python and Surprise', '2024-12-15', 40),
('asGMNT019', 9, 'Design a simple data warehousing system using Amazon Redshift', '2025-01-01', 45),
('asGMNT020', 10, 'Implement a natural language processing task using Python and spaCy', '2025-01-10', 40),
('asGMNT021', 1, 'Implement a simple classification model using Python and TensorFlow', '2025-01-15', 30),
('asGMNT022', 2, 'Design a database schema for a social media application using MongoDB', '2025-01-25', 35),
('asGMNT023', 3, 'Create a simple chatbot using Python and Dialogflow', '2025-02-01', 25),
('asGMNT024', 4, 'Implement a graph algorithm using Java', '2025-02-10', 30),
('asGMNT025', 5, 'Design a simple web application using Django and Python', '2025-02-15', 40),
('asGMNT026', 6, 'Implement a clustering algorithm using Python and scikit-learn', '2025-02-20', 45),
('asGMNT027', 7, 'Create a simple game using C++ and SFML', '2025-02-25', 35),
('asGMNT028', 8, 'Implement a decision tree algorithm using Java and Weka', '2025-03-01', 40),
('asGMNT029', 9, 'Design a simple data visualization dashboard using Tableau', '2025-03-10', 45),
('asGMNT030', 10, 'Implement a neural network using Python and PyTorch', '2025-03-15', 45),
('asGMNT031', 1, 'Implement a simple regression model using R and caret', '2025-03-20', 30),
('asGMNT032', 2, 'Design a database schema for a financial application using Oracle', '2025-03-25', 35),
('asGMNT033', 3, 'Create a simple web scraper using Java and Jsoup', '2025-04-01', 25),
('asGMNT034', 4, 'Implement a sorting algorithm using Python', '2025-04-10', 25),
('asGMNT035', 5, 'Design a simple mobile application using React Native and Javascript', '2025-04-15', 40),
('asGMNT036', 6, 'Implement a recommendation system using Python and TensorFlow', '2025-04-20', 45),
('asGMNT037', 7, 'Create a simple game using Python and Pygame', '2025-04-25', 35),
('asGMNT038', 8, 'Implement a clustering algorithm using Java and Apache Mahout', '2025-05-01', 40),
('asGMNT039', 9, 'Design a simple data warehousing system using Google BigQuery', '2025-05-10', 45),
('asGMNT040', 10, 'Implement a natural language processing task using Python and gensim', '2025-05-15', 40),
('asGMNT041', 1, 'Implement a simple classification model using Python and scikit-learn', '2025-05-20', 30),
('asGMNT042', 2, 'Design a relational schema for advanced e_learning platform', '2025-03-04',30),
('asGMNT043', 3, 'Create a simple chatbot using Javascript and Botpress', '2025-05-25', 25),
('asGMNT044', 4, 'Implement a graph algorithm using Python', '2025-06-01', 30),
('asGMNT045', 5, 'Design a simple web application using Ruby on Rails', '2025-06-10', 40),
('asGMNT046', 6, 'Implement a neural network using Java and Deeplearning4j', '2025-06-15', 45),
('asGMNT047', 7, 'Create a simple game using C# and Unity', '2025-06-20', 35),
('asGMNT048', 8, 'Implement a decision tree algorithm using Python and LightGBM', '2025-06-25', 40),
('asGMNT049', 9, 'Design a simple data visualization dashboard using Power BI', '2025-07-01', 45),
('asGMNT050', 10, 'Implement a natural language processing task using Python and Transformers', '2025-07-10', 45),
('asGMNT051', 11, 'Develop a web scraper using Python and BeautifulSoup', '2025-07-15', 40),
('asGMNT052', 12, 'Create a mobile application using React Native', '2025-07-20', 50),
('asGMNT053', 13, 'Design a secure password authentication system', '2025-07-25', 35),
('asGMNT054', 14, 'Implement a recommendation system using collaborative filtering', '2025-08-01', 40),
('asGMNT055', 15, 'Develop a chatbot using Python and NLTK', '2025-08-10', 45),
('asGMNT056', 16, 'Create a data warehouse using Amazon Redshift', '2025-08-15', 50),
('asGMNT057', 17, 'Design a cloud-based file sharing system', '2025-08-20', 40),
('asGMNT058', 18, 'Implement a machine learning model using scikit-learn', '2025-08-25', 45),
('asGMNT059', 19, 'Develop a web application using Django', '2025-09-01', 50),
('asGMNT060', 20, 'Create a network topology using Cisco Packet Tracer', '2025-09-10', 40),
('asGMNT061', 21, 'Design a database backup and recovery plan', '2025-09-15', 35),
('asGMNT062', 22, 'Implement a cybersecurity threat detection system', '2025-09-20', 45),
('asGMNT063', 23, 'Develop a software development life cycle plan', '2025-09-25', 40),
('asGMNT064', 24, 'Create a data visualization dashboard using Tableau', '2025-10-01', 45),
('asGMNT065', 25, 'Design a computer network using IPv6', '2025-10-10', 40),
('asGMNT066', 26, 'Implement a natural language processing task using spaCy', '2025-10-15', 45),
('asGMNT067', 27, 'Develop a mobile game using Unity', '2025-10-20', 50),
('asGMNT068', 28, 'Create a cloud-based database using MongoDB', '2025-10-25', 40),
('asGMNT069', 29, 'Design a web application security plan', '2025-11-01', 45),
('asGMNT070', 30, 'Implement a machine learning model using TensorFlow', '2025-11-10', 50),
('asGMNT071', 31, 'Develop a software testing plan', '2025-11-15', 40),
('asGMNT072', 32, 'Create a network security plan', '2025-11-20', 45),
('asGMNT073', 33, 'Design a data center architecture', '2025-11-25', 50),
('asGMNT074', 34, 'Implement a cybersecurity incident response plan', '2025-12-01', 45),
('asGMNT075', 35, 'Develop a web service using RESTful API', '2025-12-10', 40),
('asGMNT076', 36, 'Create a data analytics report using Excel', '2025-12-15', 35),
('asGMNT077', 37, 'Design a software development methodology', '2025-12-20', 40),
('asGMNT078', 38, 'Implement a cloud-based storage system', '2025-12-25', 45),
('asGMNT079', 39, 'Develop a network monitoring system', '2026-01-01', 50),
('asGMNT080', 40, 'Create a cybersecurity awareness program', '2026-01-10', 40),
('asGMNT081', 41, 'Design a database security plan', '2026-01-15', 45),
('asGMNT082', 42, 'Implement a machine learning model using PyTorch', '2026-01-20', 50),
('asGMNT083', 43, 'Develop a software project management plan', '2026-01-25', 40),
('asGMNT084', 44, 'Create a data visualization dashboard using D3.js', '2026-02-01', 45),
('asGMNT085', 45, 'Design a network architecture for a small business', '2026-02-10', 40),
('asGMNT086', 46, 'Implement a natural language processing task using Stanford CoreNLP', '2026-02-15', 45),
('asGMNT087', 47, 'Develop a web application using Flask', '2026-02-20', 50),
('asGMNT088', 48, 'Create a data warehouse using Google BigQuery', '2026-02-25', 40),
('asGMNT089', 49, 'Design a cybersecurity threat intelligence system', '2026-03-01', 45),
('asGMNT090', 50, 'Implement a machine learning model using Keras', '2026-03-10', 50),
('asGMNT091', 51, 'Develop a software testing framework using JUnit', '2026-03-15', 40),
('asGMNT092', 52, 'Create a network security plan for a large enterprise', '2026-03-20', 45),
('asGMNT093', 53, 'Design a data analytics report using Power BI', '2026-03-25', 40),
('asGMNT094', 54, 'Implement a cloud-based database using PostgreSQL', '2026-04-01', 45),
('asGMNT095', 55, 'Develop a web service using SOAP', '2026-04-10', 40),
('asGMNT096', 56, 'Create a cybersecurity incident response plan for a small business', '2026-04-15', 45),
('asGMNT097', 57, 'Design a software development life cycle plan for an agile team', '2026-04-20', 40),
('asGMNT098', 58, 'Implement a machine learning model using Microsoft Azure', '2026-04-25', 50),
('asGMNT099', 59, 'Develop a network monitoring system using Nagios', '2026-05-01', 45),
('asGMNT100', 60, 'Create a data visualization dashboard using Google Data Studio', '2026-05-10', 40);

-- data insertion in Submission table

insert into submissions (subCode, asID, sID, subDate, filelink, grade, feedback) values
('SUB001', 1, 1, '2024-06-20', 'NeuralNetwork.pdf', 85.00, 'Good job!'),
('SUB002', 2, 2, '2024-07-05', 'DataAnalysis.docx', 90.00, 'Excellent work!'),
('SUB003', 3, 3, '2024-08-10', 'WebDev.zip', 78.00, 'Well done!'),
('SUB004', 4, 4, '2024-09-15', 'MachineLearning.mp4', 92.00, 'Outstanding!'),
('SUB005', 5, 5, '2024-07-25', 'DatabaseDesign.jpg', 88.00, 'Great effort!'),
('SUB006', 6, 6, '2024-06-30', 'Programmingassignment.pptx', 95.00, 'Fantastic!'),
('SUB007', 7, 7, '2024-08-20', 'DataVisualization.xlsx', 80.00, 'Good work!'),
('SUB008', 8, 8, '2024-09-10', 'NetworkingReport.txt', 89.00, 'Excellent!'),
('SUB009', 9, 9, '2024-07-15', 'SEaudio.mp3', 86.00, 'Well done!'),
('SUB010', 10, 10, '2024-06-25', 'CVproject.pdf', 91.00, 'Outstanding!'),
('SUB011', 1, 2, '2024-10-01', 'AIReport.docx', 87.00, 'Good job!'),
('SUB012', 2, 3, '2024-10-15', 'WebDesign.zip', 94.00, 'Excellent work!'),
('SUB013', 3, 1, '2024-11-01', 'MachineLearning.pdf', 89.00, 'Well done!'),
('SUB014', 4, 4, '2024-11-10', 'DataAnalysis.pptx', 96.00, 'Outstanding!'),
('SUB015', 5, 5, '2024-11-20', 'DatabaseDesign.xlsx', 90.00, 'Great effort!'),
('SUB016', 6, 6, '2024-12-01', 'Programmingassignment.mp4', 98.00, 'Fantastic!'),
('SUB017', 7, 7, '2024-12-10', 'DataVisualization.txt', 91.00, 'Good work!'),
('SUB018', 8, 8, '2025-01-01', 'NetworkingReport.docx', 95.00, 'Excellent!'),
('SUB019', 9, 9, '2025-01-10', 'SEaudio.wav', 92.00, 'Well done!'),
('SUB020', 10, 10, '2025-01-15', 'CVproject.mp4', 99.00, 'Outstanding!'),
('SUB021', 1, 1, '2025-01-20', 'AIReport.pptx', 88.00, 'Good job!'),
('SUB022', 2, 2, '2025-01-25', 'WebDesign.mp4', 97.00, 'Excellent work!'),
('SUB023', 3, 3, '2025-02-01', 'MachineLearning.xlsx', 93.00, 'Well done!'),
('SUB024', 4, 4, '2025-02-10', 'DataAnalysis.docx', 99.00, 'Outstanding!'),
('SUB025', 5, 5, '2025-02-15', 'DatabaseDesign.txt', 94.00, 'Great effort!'),
('SUB026', 6, 6, '2025-02-20', 'Programmingassignment.zip', 100.00, 'Fantastic!'),
('SUB027', 7, 7, '2025-02-25', 'DataVisualization.mp4', 96.00, 'Good work!'),
('SUB028', 8, 8, '2025-03-01', 'NetworkingReport.pptx', 98.00, 'Excellent!'),
('SUB029', 9, 9, '2025-03-10', 'SEaudio.mp3', 95.00, 'Well done!'),
('SUB030', 10, 10, '2025-03-15', 'CVproject.docx', 101.00, 'Outstanding!'),
('SUB031', 1, 1, '2025-03-20', 'AIReport.xlsx', 90.00, 'Good job!'),
('SUB032', 2, 2, '2025-03-25', 'WebDesign.txt', 99.00, 'Excellent work!'),
('SUB033', 3, 3, '2025-04-01', 'MachineLearning.pptx', 97.00, 'Well done!'),
('SUB034', 4, 4, '2025-04-10', 'DataAnalysis.zip', 102.00, 'Outstanding!'),
('SUB035', 5, 5, '2025-04-15', 'DatabaseDesign.mp4', 100.00, 'Great effort!'),
('SUB036', 6, 6, '2025-04-20', 'Programmingassignment.docx', 105.00, 'Fantastic!'),
('SUB037', 7, 7, '2025-04-25', 'DataVisualization.xlsx', 103.00, 'Good work!'),
('SUB038', 8, 8, '2025-05-01', 'NetworkingReport.mp3', 104.00, 'Excellent!'),
('SUB039', 9, 9, '2025-05-10', 'SEaudio.wav', 106.00, 'Well done!'),
('SUB040', 10, 10, '2025-05-15', 'CVproject.pdf', 108.00, 'Outstanding!'),
('SUB041', 1, 1, '2025-05-20', 'AIReport.docx', 90.00, 'Good job!'),
('SUB042', 2, 2, '2025-05-25', 'WebDesign.zip', 100.00, 'Excellent work!'),
('SUB043', 3, 3, '2025-06-01', 'MachineLearning.pptx', 98.00, 'Well done!'),
('SUB044', 4, 4, '2025-06-10', 'DataAnalysis.xlsx', 105.00, 'Outstanding!'),
('SUB045', 5, 5, '2025-06-15', 'DatabaseDesign.mp4', 102.00, 'Great effort!'),
('SUB046', 6, 6, '2025-06-20', 'Programmingassignment.txt', 110.00, 'Fantastic!'),
('SUB047', 7, 7, '2025-06-25', 'DataVisualization.docx', 107.00, 'Good work!'),
('SUB048', 8, 8, '2025-07-01', 'NetworkingReport.wav', 109.00, 'Excellent!'),
('SUB049', 9, 9, '2025-07-10', 'SEaudio.mp3', 111.00, 'Well done!'),
('SUB050', 10, 10, '2025-07-15', 'CVproject.zip', 115.00, 'Outstanding!'),
('SUB051', 11, 11, '2025-07-20', 'MachineLearning.pptx', 108.00, 'Great effort!'),
('SUB052', 12, 12, '2025-07-25', 'WebDesign.zip', 102.00, 'Excellent work!'),
('SUB053', 13, 13, '2025-08-01', 'DatabaseDesign.mp4', 110.00, 'Well done!'),
('SUB054', 14, 14, '2025-08-10', 'Programmingassignment.txt', 105.00, 'Good job!'),
('SUB055', 15, 15, '2025-08-15', 'DataVisualization.docx', 107.00, 'Outstanding!'),
('SUB056', 16, 16, '2025-08-20', 'NetworkingReport.wav', 109.00, 'Excellent work!'),
('SUB057', 17, 17, '2025-08-25', 'SoftwareEngineering.pdf', 111.00, 'Well done!'),
('SUB058', 18, 18, '2025-09-01', 'Artificialintelligence.pptx', 115.00, 'Outstanding!'),
('SUB059', 19, 19, '2025-09-10', 'CyberSecurity.docx', 108.00, 'Great effort!'),
('SUB060', 20, 20, '2025-09-15', 'Datascience.zip', 102.00, 'Excellent work!'),
('SUB061', 21, 21, '2025-09-20', 'WebDevelopment.mp4', 110.00, 'Well done!'),
('SUB062', 22, 22, '2025-09-25', 'DatabaseManagement.txt', 105.00, 'Good job!'),
('SUB063', 23, 23, '2025-10-01', 'Networking.wav', 107.00, 'Outstanding!'),
('SUB064', 24, 24, '2025-10-10', 'SoftwareDesign.pdf', 109.00, 'Excellent work!'),
('SUB065', 25, 25, '2025-10-15', 'ArtificialReality.pptx', 111.00, 'Well done!'),
('SUB066', 26, 26, '2025-10-20', 'Businessintelligence.docx', 115.00, 'Outstanding!'),
('SUB067', 27, 27, '2025-10-25', 'CloudComputing.zip', 108.00, 'Great effort!'),
('SUB068', 28, 28, '2025-11-01', 'CybersecurityAwareness.mp4', 102.00, 'Excellent work!'),
('SUB069', 29, 29, '2025-11-10', 'DataAnalytics.txt', 110.00, 'Well done!'),
('SUB070', 30, 30, '2025-11-15', 'DatabaseAdministration.wav', 105.00, 'Good job!'),
('SUB071', 31, 31, '2025-11-20', 'DigitalMarketing.pdf', 107.00, 'Outstanding!'),
('SUB072', 32, 32, '2025-11-25', 'EnterpriseSoftware.pptx', 109.00, 'Excellent work!'),
('SUB073', 33, 33, '2025-12-01', 'GameDevelopment.zip', 111.00, 'Well done!'),
('SUB074', 34, 34, '2025-12-10', 'GraphicDesign.docx', 115.00, 'Outstanding!'),
('SUB075', 35, 35, '2025-12-15', 'Healthinformatics.mp4', 108.00, 'Great effort!'),
('SUB076', 36, 36, '2025-12-20', 'informationSystems.txt', 102.00, 'Excellent work!'),
('SUB077', 37, 37, '2025-12-25', 'ITProjectManagement.wav', 110.00, 'Well done!'),
('SUB078', 38, 38, '2026-01-01', 'MachineLearning.pdf', 105.00, 'Good job!'),
('SUB079', 39, 39, '2026-01-10', 'MultimediaDevelopment.pptx', 107.00, 'Outstanding!'),
('SUB080', 40, 40, '2026-01-15', 'NetworkAdministration.zip', 109.00, 'Excellent work!'),
('SUB081', 41, 41, '2026-01-20', 'OperatingSystemDevelopment.docx', 111.00, 'Well done!'),
('SUB082', 42, 42, '2026-01-25', 'SoftwareEngineering.mp4', 115.00, 'Outstanding!'),
('SUB083', 43, 43, '2026-02-01', 'SystemsAnalysis.txt', 108.00, 'Great effort!'),
('SUB084', 44, 44, '2026-02-10', 'Telehealth.wav', 102.00, 'Excellent work!'),
('SUB085', 45, 45, '2026-02-15', 'UserExperienceDesign.pdf', 110.00, 'Well done!'),
('SUB086', 46, 46, '2026-02-20', 'VideoGameDesign.zip', 105.00, 'Good job!'),
('SUB087', 47, 47, '2026-02-25', 'WebDesign.docx', 107.00, 'Outstanding!'),
('SUB088', 48, 48, '2026-03-01', 'WirelessCommunication.mp4', 109.00, 'Excellent work!'),
('SUB089', 49, 49, '2026-03-10', 'ArtificialReality.txt', 111.00, 'Well done!'),
('SUB090', 50, 50, '2026-03-15', 'Businessintelligence.wav', 115.00, 'Outstanding!'),
('SUB091', 51, 51, '2026-03-20', 'CloudComputing.pdf', 108.00, 'Great effort!'),
('SUB092', 52, 52, '2026-03-25', 'CybersecurityAwareness.zip', 102.00, 'Excellent work!'),
('SUB093', 53, 53, '2026-04-01', 'DataAnalytics.docx', 110.00, 'Well done!'),
('SUB094', 54, 54, '2026-04-10', 'DatabaseAdministration.mp4', 105.00, 'Good job!'),
('SUB095', 55, 55, '2026-04-15', 'DigitalMarketing.txt', 107.00, 'Outstanding!'),
('SUB096', 56, 56, '2026-04-20', 'EnterpriseSoftware.wav', 109.00, 'Excellent work!'),
('SUB097', 57, 57, '2026-04-25', 'GameDevelopment.pdf', 111.00, 'Well done!'),
('SUB098', 58, 58, '2026-05-01', 'GraphicDesign.zip', 115.00, 'Outstanding!'),
('SUB099', 59, 59, '2026-05-10', 'Healthinformatics.docx', 108.00, 'Great effort!'),
('SUB100', 60, 60, '2026-05-15', 'informationSystems.mp4', 102.00, 'Excellent work!');

-- data insertion in Catogeries table

insert into category (catCode, catName, description) values
('CAT001', 'Artificial intelligence', 'AI and machine learning'),
('CAT002', 'Data Science', 'Data analysis and visualization'),
('CAT003', 'Web Development', 'Web design and development'),
('CAT004', 'Programming', 'Programming languages and concepts'),
('CAT005', 'Database Management', 'Database design and management'),
('CAT006', 'Networking', 'Computer networking and security'),
('CAT007', 'Operating Systems', 'OS concepts and management'),
('CAT008', 'Software Engineering', 'Software design and development'),
('CAT009', 'Computer Vision', 'Image and video processing'),
('CAT010', 'Natural Language Processing', 'Text processing and analysis'),
('CAT011', 'Cloud Computing', 'Cloud infrastructure and services'),
('CAT012', 'Cyber Security', 'Network and system security'),
('CAT013', 'Data Mining', 'Data extraction and analysis'),
('CAT014', 'Game Development', 'Game design and development'),
('CAT015', 'Human-Computer interaction', 'User interface design'),
('CAT016', 'information Systems', 'information system management'),
('CAT017', 'internet of Things', 'IoT devices and applications'),
('CAT018', 'Machine Learning', 'Supervised and unsupervised learning'),
('CAT019', 'Mobile App Development', 'Mobile app design and development'),
('CAT020', 'Network Administration', 'Network management and maintenance'),
('CAT021', 'Object-Oriented Programming', 'OOP concepts and principles'),
('CAT022', 'Parallel Computing', 'Distributed computing and processing'),
('CAT023', 'Robotics', 'Robot design and development'),
('CAT024', 'Speech Recognition', 'Speech processing and analysis'),
('CAT025', 'Statistics', 'Statistical analysis and modeling'),
('CAT026', 'Text Analytics', 'Text processing and analysis'),
('CAT027', 'User Experience Design', 'User experience and usability'),
('CAT028', 'Virtual Reality', 'VR and AR development'),
('CAT029', 'Web Analytics', 'Web traffic analysis and optimization'),
('CAT030', 'Wireless Communication', 'Wireless networking and communication'),
('CAT031', 'Algorithm Design', 'Algorithm development and analysis'),
('CAT032', 'Computer Graphics', 'Computer graphics and visualization'),
('CAT033', 'Database Security', 'Database security and access control'),
('CAT034', 'Digital Signal Processing', 'Signal processing and analysis'),
('CAT035', 'E-commerce Development', 'E-commerce platform development'),
('CAT036', 'Embedded Systems', 'Embedded system design and development'),
('CAT037', 'Geographic information Systems', 'GIS and spatial analysis'),
('CAT038', 'Health informatics', 'Healthcare information systems'),
('CAT039', 'information Retrieval', 'information search and retrieval'),
('CAT040', 'Knowledge Management', 'Knowledge sharing and management'),
('CAT041', 'Multimedia Systems', 'Multimedia processing and analysis'),
('CAT042', 'Network Programming', 'Network programming and development'),
('CAT043', 'Operating System Security', 'OS security and access control'),
('CAT044', 'Parallel Processing', 'Parallel computing and processing'),
('CAT045', 'Quality assurance', 'Software testing and quality assurance'),
('CAT046', 'Relational Databases', 'Relational database design and management'),
('CAT047', 'Software Architecture', 'Software design and architecture'),
('CAT048', 'Systems Analysis', 'System analysis and design'),
('CAT049', 'Telecommunications', 'Telecommunication systems and networks'),
('CAT050', 'Usability Engineering', 'User experience and usability engineering'),
('CAT051', 'Digital Forensics', 'Computer forensic analysis and investigation'),
('CAT052', 'E-Learning Development', 'online course creation and delivery'),
('CAT053', 'Embedded Software', 'Software development for embedded systems'),
('CAT054', 'Geospatial Technology', 'GIS and spatial analysis'),
('CAT055', 'Human-Computer interaction Design', 'User-centered design principles'),
('CAT056', 'information Architecture', 'information system design and organization'),
('CAT057', 'internet of Things Security', 'IoT device security and vulnerability'),
('CAT058', 'Machine Vision', 'Computer vision and image processing'),
('CAT059', 'Mobile Security', 'Mobile device security and vulnerability'),
('CAT060', 'Network Architecture', 'Network design and architecture'),
('CAT061', 'Open Source Software', 'Open source software development and management'),
('CAT062', 'Parallel Computing', 'Distributed computing and processing'),
('CAT063', 'Quality assurance Testing', 'Software testing and quality assurance'),
('CAT064', 'Robotics Engineering', 'Robot design and development'),
('CAT065', 'Secure Coding', 'Secure programming practices'),
('CAT066', 'Software Project Management', 'Software project planning and management'),
('CAT067', 'Speech Processing', 'Speech recognition and synthesis'),
('CAT068', 'Systems integration', 'System integration and interoperability'),
('CAT069', 'Text Mining', 'Text analysis and information extraction'),
('CAT070', 'User Experience Design', 'User-centered design principles'),
('CAT071', 'Virtualization', 'Virtual machine and cloud computing'),
('CAT072', 'Web Application Security', 'Web application security and vulnerability'),
('CAT073', 'Wireless Networks', 'Wireless networking and communication'),
('CAT074', 'Cloud Architecture', 'Cloud computing architecture and design'),
('CAT075', 'Cybersecurity Awareness', 'Cybersecurity best practices and awareness'),
('CAT076', 'Data Analytics', 'Data analysis and visualization'),
('CAT077', 'Database Administration', 'Database management and administration'),
('CAT078', 'Digital Marketing', 'Digital marketing strategies and techniques'),
('CAT079', 'Enterprise Software', 'Enterprise software development and management'),
('CAT080', 'Game Development', 'Game design and development'),
('CAT081', 'Graphic Design', 'Visual design and communication'),
('CAT082', 'Health informatics', 'Healthcare information systems'),
('CAT083', 'information Systems Management', 'information system management'),
('CAT084', 'IT Project Management', 'IT project planning and management'),
('CAT085', 'Machine Learning', 'Machine learning algorithms and applications'),
('CAT086', 'Multimedia Development', 'Multimedia design and development'),
('CAT087', 'Network Administration', 'Network management and maintenance'),
('CAT088', 'Operating System Development', 'Operating system design and development'),
('CAT089', 'Software Engineering', 'Software design and development'),
('CAT090', 'Systems Analysis', 'System analysis and design'),
('CAT091', 'Telehealth', 'Telemedicine and healthcare technology'),
('CAT092', 'User interface Design', 'User interface design principles'),
('CAT093', 'Video Game Design', 'Game design and development'),
('CAT094', 'Web Design', 'Web design and development'),
('CAT095', 'Wireless Communication', 'Wireless networking and communication'),
('CAT096', 'Artificial Reality', 'AR and VR development'),
('CAT097', 'Business intelligence', 'Business intelligence and data analysis'),
('CAT098', 'Cloud Computing', 'Cloud computing architecture and design'),
('CAT099', 'Cybersecurity', 'Cybersecurity best practices and awareness'),
('CAT100', 'Data Science', 'Data analysis and visualization');

-- data insertion in Reviews table

insert into reviews (revCode, cID, sID, rating, comments, subDate) values
('REV001', 1, 1, 4.50, 'Excellent course!', '2024-06-20'),
('REV002', 2, 2, 4.80, 'Very informative!', '2024-07-05'),
('REV003', 3, 3, 4.20, 'Good course!', '2024-08-10'),
('REV004', 4, 4, 4.90, 'Outstanding!', '2024-09-15'),
('REV005', 5, 5, 4.60, 'Well structured!', '2024-07-25'),
('REV006', 6, 6, 4.40, 'interesting topics!', '2024-06-30'),
('REV007', 7, 7, 4.70, 'Engaging instructor!', '2024-08-20'),
('REV008', 8, 8, 4.30, 'Good pace!', '2024-09-10'),
('REV009', 9, 9, 4.80, 'Excellent resources!', '2024-07-15'),
('REV010', 10, 10, 4.90, 'Exceptional course!', '2024-06-25'),
('REV011', 1, 2, 4.50, 'informative and engaging!', '2024-10-01'),
('REV012', 2, 3, 4.80, 'Excellent instructor!', '2024-10-15'),
('REV013', 3, 1, 4.20, 'Good course material!', '2024-11-01'),
('REV014', 4, 4, 4.90, 'Outstanding learning experience!', '2024-11-10'),
('REV015', 5, 5, 4.60, 'Well organized!', '2024-11-20'),
('REV016', 6, 6, 4.40, 'interesting and challenging!', '2024-12-01'),
('REV017', 7, 7, 4.70, 'Engaging and interactive!', '2024-12-10'),
('REV018', 8, 8, 4.30, 'Good pace and coverage!', '2025-01-01'),
('REV019', 9, 9, 4.80, 'Excellent resources and support!', '2025-01-10'),
('REV020', 10, 10, 4.90, 'Exceptional teaching!', '2025-01-15'),
('REV202', 41, 41, 4.70, 'Engaging instructor and course materials!', '2025-08-20'),
('REV203', 42, 42, 4.30, 'Good pace and coverage of topics!', '2025-08-25'),
('REV204', 43, 43, 4.90, 'Outstanding learning experience!', '2025-09-01'),
('REV205', 44, 44, 4.60, 'Well organized and structured course!', '2025-09-10'),
('REV206', 45, 45, 4.40, 'interesting and challenging assignments!', '2025-09-15'),
('REV207', 46, 46, 4.80, 'Excellent resources and support!', '2025-09-20'),
('REV208', 47, 47, 4.50, 'informative and engaging lectures!', '2025-09-25'),
('REV209', 48, 48, 4.20, 'Good course material and instructor!', '2025-10-01'),
('REV210', 49, 49, 4.90, 'Exceptional teaching and mentoring!', '2025-10-10'),
('REV211', 50, 50, 4.70, 'Engaging and interactive course!', '2025-10-15'),
('REV212', 51, 51, 4.30, 'Good pace and coverage!', '2025-10-20'),
('REV213', 52, 52, 4.80, 'Excellent instructor and resources!', '2025-10-25'),
('REV214', 53, 53, 4.60, 'Well organized and structured!', '2025-11-01'),
('REV215', 54, 54, 4.40, 'interesting and challenging topics!', '2025-11-10'),
('REV216', 55, 55, 4.90, 'Outstanding learning experience!', '2025-11-15'),
('REV217', 56, 56, 4.50, 'informative and engaging course!', '2025-11-20'),
('REV218', 57, 57, 4.20, 'Good course material and pace!', '2025-11-25'),
('REV219', 58, 58, 4.80, 'Excellent resources and support!', '2025-12-01'),
('REV220', 59, 59, 4.70, 'Engaging and interactive instructor!', '2025-12-10'),
('REV221', 60, 60, 4.90, 'Exceptional teaching and mentoring!', '2025-12-15'),
('REV060', 61, 61, 4.80, 'Excellent instructor and resources!', '2025-12-20'),
('REV061', 62, 62, 4.50, 'informative and engaging lectures!', '2025-12-25'),
('REV062', 63, 63, 4.90, 'Outstanding learning experience!', '2026-01-01'),
('REV063', 64, 64, 4.60, 'Well organized and structured course!', '2026-01-10'),
('REV064', 65, 65, 4.40, 'interesting and challenging assignments!', '2026-01-15'),
('REV065', 66, 66, 4.70, 'Engaging and interactive instructor!', '2026-01-20'),
('REV066', 67, 67, 4.30, 'Good pace and coverage!', '2026-01-25'),
('REV067', 68, 68, 4.80, 'Excellent resources and support!', '2026-02-01'),
('REV068', 69, 69, 4.90, 'Exceptional teaching and mentoring!', '2026-02-10'),
('REV069', 70, 70, 4.50, 'informative and engaging course!', '2026-02-15'),
('REV070', 71, 71, 4.60, 'Well organized and structured!', '2026-02-20'),
('REV071', 72, 72, 4.40, 'interesting and challenging topics!', '2026-02-25'),
('REV072', 73, 73, 4.80, 'Excellent instructor and resources!', '2026-03-01'),
('REV073', 74, 74, 4.70, 'Engaging and interactive course!', '2026-03-10'),
('REV074', 75, 75, 4.30, 'Good pace and coverage!', '2026-03-15'),
('REV075', 76, 76, 4.90, 'Outstanding learning experience!', '2026-03-20'),
('REV076', 77, 77, 4.50, 'informative and engaging lectures!', '2026-03-25'),
('REV077', 78, 78, 4.60, 'Well organized and structured course!', '2026-04-01'),
('REV078', 79, 79, 4.40, 'interesting and challenging assignments!', '2026-04-10'),
('REV079', 80, 80, 4.80, 'Excellent resources and support!', '2026-04-15'),
('REV080', 81, 81, 4.90, 'Exceptional teaching and mentoring!', '2026-04-20'),
('REV081', 82, 82, 4.70, 'Engaging and interactive instructor!', '2026-04-25'),
('REV082', 83, 83, 4.50, 'informative and engaging course!', '2026-05-01'),
('REV083', 84, 84, 4.60, 'Well organized and structured!', '2026-05-10'),
('REV084', 85, 85, 4.40, 'interesting and challenging topics!', '2026-05-15'),
('REV085', 86, 86, 4.80, 'Excellent instructor and resources!', '2026-05-20'),
('REV086', 87, 87, 4.90, 'Outstanding learning experience!', '2026-05-25'),
('REV087', 88, 88, 4.70, 'Engaging and interactive course!', '2026-06-01'),
('REV088', 89, 89, 4.50, 'informative and engaging lectures!', '2026-06-10'),
('REV089', 90, 90, 4.60, 'Well organized and structured course!', '2026-06-15'),
('REV090', 30, 30, 4.50, 'informative and engaging course!', '2025-06-15'),
('REV091', 31, 31, 4.80, 'Excellent instructor and resources!', '2025-06-20'),
('REV092', 32, 32, 4.20, 'Good course material and pace!', '2025-06-25'),
('REV093', 33, 33, 4.90, 'Outstanding learning experience!', '2025-07-01'),
('REV094', 34, 34, 4.60, 'Well organized and structured!', '2025-07-10'),
('REV095', 35, 35, 4.40, 'interesting and challenging topics!', '2025-07-15'),
('REV096', 36, 36, 4.70, 'Engaging and interactive instructor!', '2025-07-20'),
('REV097', 37, 37, 4.30, 'Good pace and coverage!', '2025-07-25'),
('REV098', 38, 38, 4.80, 'Excellent resources and support!', '2025-08-01'),
('REV099', 39, 39, 4.90, 'Exceptional teaching and mentoring!', '2025-08-10'),
('REV100', 40, 40, 4.50, 'informative and engaging course!', '2025-08-15');

-- data insertion in Certificates table

insert into certificate (certCode, cID, sID, issueDate, certLink) values
('CERT001', 1, 1, '2024-06-20', 'https://www.coursera.org/account/accomplishments/certificate/TMQKP3QHGKB5'),
('CERT002', 2, 2, '2024-07-05', 'https://www.coursera.org/account/accomplishments/certificate/LFBDYCFZQ3Y5'),
('CERT003', 3, 3, '2024-08-10', 'https://www.coursera.org/account/accomplishments/certificate/6P6XTT8NX8PR'),
('CERT004', 4, 4, '2024-09-11', 'https://www.coursera.org/account/accomplishments/certificate/GQLM5EXD2KMP'),
('CERT005', 5, 5, '2024-07-25', 'https://www.coursera.org/account/accomplishments/certificate/GTWYZHCUQZNX'),
('CERT006', 6, 6, '2024-06-30', 'https://www.coursera.org/account/accomplishments/certificate/3LWTFBWM2H63'),
('CERT007', 7, 7, '2024-08-20', 'https://www.coursera.org/account/accomplishments/certificate/6GTS7FUQB84Q'),
('CERT008', 8, 8, '2024-09-10', 'https://www.coursera.org/account/accomplishments/certificate/KJV7XLLRLG4U'),
('CERT009', 9, 9, '2024-07-15', 'https://github.com/vinabi/text-to-image-generator'),
('CERT010', 10, 10, '2024-09-15', 'https://www.linkedin.com/in/vinabi/'),
('CERT011', 11, 11, '2024-08-25', '(link unavailable)'),
('CERT012', 12, 12, '2024-07-10', '(link unavailable)'),
('CERT013', 13, 13, '2024-09-05', '(link unavailable)'),
('CERT014', 14, 14, '2024-06-22', '(link unavailable)'),
('CERT015', 15, 15, '2024-08-01', '(link unavailable)'),
('CERT016', 16, 16, '2024-09-20', '(link unavailable)'),
('CERT017', 17, 17, '2024-07-28', '(link unavailable)'),
('CERT018', 18, 18, '2024-08-15', '(link unavailable)'),
('CERT019', 19, 19, '2024-09-12', '(link unavailable)'),
('CERT020', 20, 20, '2024-06-28', '(link unavailable)'),
('CERT021', 21, 21, '2024-08-05', '(link unavailable)'),
('CERT022', 22, 22, '2024-07-18', '(link unavailable)'),
('CERT023', 23, 23, '2024-09-08', '(link unavailable)'),
('CERT024', 24, 24, '2024-08-22', '(link unavailable)'),
('CERT025', 25, 25, '2024-06-25', '(link unavailable)'),
('CERT026', 26, 26, '2024-09-01', '(link unavailable)'),
('CERT027', 27, 27, '2024-07-12', '(link unavailable)'),
('CERT028', 28, 28, '2024-08-29', '(link unavailable)'),
('CERT029', 29, 29, '2024-09-18', '(link unavailable)'),
('CERT030', 30, 30, '2024-06-30', '(link unavailable)'),
('CERT031', 31, 31, '2024-08-08', '(link unavailable)'),
('CERT032', 32, 32, '2024-07-22', '(link unavailable)'),
('CERT033', 33, 33, '2024-09-06', '(link unavailable)'),
('CERT034', 34, 34, '2024-08-18', '(link unavailable)'),
('CERT035', 35, 35, '2024-06-27', '(link unavailable)'),
('CERT036', 36, 36, '2024-08-04', '(link unavailable)'),
('CERT037', 37, 37, '2024-07-15', '(link unavailable)'),
('CERT038', 38, 38, '2024-09-09', '(link unavailable)'),
('CERT039', 39, 39, '2024-08-12', '(link unavailable)'),
('CERT040', 40, 40, '2024-07-20', '(link unavailable) certificate/1234567890'),
('CERT041', 41, 41, '2024-10-01', 'https://coursera.org/account/accomplishments/certificate/AB123456'),
('CERT042', 42, 42, '2024-09-25', 'https://edx.org/certificate/XY123456'),
('CERT043', 43, 43, '2024-10-10', 'https://linkedin.com/in/username/certificate/123456'),
('CERT044', 44, 44, '2024-09-28', 'https://github.com/username/certificate/123456'),
('CERT045', 45, 45, '2024-10-05', 'https://coursera.org/account/accomplishments/certificate/CD123456'),
('CERT046', 46, 46, '2024-10-02', 'https://edx.org/certificate/EFG123456'),
('CERT047', 47, 47, '2024-09-22', 'https://linkedin.com/in/username/certificate/789012'),
('CERT048', 48, 48, '2024-10-08', 'https://github.com/username/certificate/456789'),
('CERT049', 49, 49, '2024-09-29', 'https://coursera.org/account/accomplishments/certificate/GH123456'),
('CERT050', 50, 50, '2024-10-12', 'https://edx.org/certificate/IK123456'),
('CERT051', 51, 51, '2024-10-033', 'https://linkedin.com/in/username/certificate/901234'),
('CERT052', 52, 52, '2024-09-24', '(link unavailable)'),
('CERT053', 53, 53, '2024-10-06', '(link unavailable)'),
('CERT054', 54, 54, '2024-10-09', '(link unavailable)'),
('CERT055', 55, 55, '2024-09-26', '(link unavailable)'),
('CERT056', 56, 56, '2024-10-04', '(link unavailable)'),
('CERT057', 57, 57, '2024-10-11', '(link unavailable)'),
('CERT058', 58, 58, '2024-09-27', '(link unavailable)'),
('CERT059', 59, 59, '2024-10-07', '(link unavailable)'),
('CERT060', 60, 60, '2024-09-30', '(link unavailable)'),
('CERT061', 61, 61, '2024-10-05', '(link unavailable)'),
('CERT062', 62, 62, '2024-10-10', '(link unavailable)'),
('CERT063', 63, 63, '2024-09-23', '(link unavailable)'),
('CERT064', 64, 64, '2024-10-08', '(link unavailable)'),
('CERT065', 65, 65, '2024-09-29', '(link unavailable)'),
('CERT066', 66, 66, '2024-10-02', '(link unavailable)'),
('CERT067', 67, 67, '2024-09-25', '(link unavailable)'),
('CERT068', 68, 68, '2024-10-09', '(link unavailable)'),
('CERT069', 69, 69, '2024-09-26', '(link unavailable)'),
('CERT070', 70, 70, '2024-10-06', '(link unavailable)'),
('CERT071', 71, 71, '2024-10-03', '(link unavailable)'),
('CERT072', 72, 72, '2024-09-28', '(link unavailable)'),
('CERT073', 73, 73, '2024-10-11', '(link unavailable)'),
('CERT074', 74, 74, '2024-09-30', '(link unavailable)'),
('CERT075', 75, 75, '2024-10-04', '(link unavailable)'),
('CERT076', 76, 76, '2024-09-29', '(link unavailable)'),
('CERT077', 77, 77, '2024-10-07', '(link unavailable)'),
('CERT078', 78, 78, '2024-10-01', '(link unavailable)'),
('CERT079', 79, 79, '2024-09-27', '(link unavailable)'),
('CERT080', 80, 80, '2024-10-10', '(link unavailable)'),
('CERT081', 81, 81, '2024-10-12', 'https://coursera.org/account/accomplishments/certificate/ABC123'),
('CERT082', 82, 82, '2024-10-15', 'https://edx.org/certificate/DEF456'),
('CERT083', 83, 83, '2024-10-18', 'https://linkedin.com/in/ghi789/certificate'),
('CERT084', 84, 84, '2024-10-20', 'https://github.com/jkl012/certificate'),
('CERT085', 85, 85, '2024-10-22', 'https://coursera.org/account/accomplishments/certificate/MNO345'),
('CERT086', 86, 86, '2024-10-25', 'https://edx.org/certificate/PQR678'),
('CERT087', 87, 87, '2024-10-28', 'https://linkedin.com/in/stu901/certificate'),
('CERT088', 88, 88, '2024-11-01', 'https://github.com/vwx234/certificate'),
('CERT089', 89, 89, '2024-11-04', 'https://coursera.org/account/accomplishments/certificate/YZA012'),
('CERT090', 90, 90, '2024-11-07', 'https://edx.org/certificate/BCD345'),
('CERT091', 91, 91, '2024-11-10', 'https://linkedin.com/in/efg678/certificate'),
('CERT092', 92, 92, '2024-11-12', 'https://github.com/hij901/certificate'),
('CERT093', 93, 93, '2024-11-15', 'https://coursera.org/account/accomplishments/certificate/KLM456'),
('CERT094', 94, 94, '2024-11-18', ' https://edx.org/certificate/NOP789'),
('CERT095', 95, 95, '2024-11-20', '(link unavailable)'),
('CERT096', 96, 96, '2024-11-22', '(link unavailable)'),
('CERT097', 97, 97, '2024-11-25', '(link unavailable)'),
('CERT098', 98, 98, '2024-11-28', '(link unavailable)'),
('CERT099', 99, 99, '2024-12-01', '(link unavailable)'),
('CERT100', 100, 100, '2024-12-04', '(link unavailable)');

-- data insertion in Payment table

insert into payments (payCode, sID, cID, payDate, amount, status) values
('PAY001', 1, 1, '2024-06-20', 100000.00, 'Paid'),
('PAY002', 2, 2, '2024-07-05', 200000.00, 'Paid'),
('PAY003', 3, 3, '2024-08-10', 500000.00, 'Pending'),
('PAY004', 4, 4, '2024-09-15', 150000.00, 'Paid'),
('PAY005', 5, 5, '2024-07-25', 250000.00, 'Failed'),
('PAY006', 6, 6, '2024-06-30', 300000.00, 'Paid'),
('PAY007', 7, 7, '2024-08-20', 750000.00, 'Pending'),
('PAY008', 8, 8, '2024-09-10', 225000.00, 'Paid'),
('PAY009', 9, 9, '2024-07-15', 100000.00, 'Failed'),
('PAY010', 10, 10, '2024-06-25', 400000.00, 'Paid'),
('PAY011', 11, 11, '2024-10-01', 180000.00, 'Paid'),
('PAY012', 12, 12, '2024-10-08', 120000.00, 'Pending'),
('PAY013', 13, 13, '2024-09-22', 280000.00, 'Paid'),
('PAY014', 14, 14, '2024-10-15', 220000.00, 'Failed'),
('PAY015', 15, 15, '2024-09-28', 380000.00, 'Paid'),
('PAY016', 16, 16, '2024-10-05', 150000.00, 'Pending'),
('PAY017', 17, 17, '2024-09-18', 200000.00, 'Paid'),
('PAY018', 18, 18, '2024-10-12', 320000.00, 'Failed'),
('PAY019', 19, 19, '2024-09-25', 450000.00, 'Paid'),
('PAY020', 20, 20, '2024-10-02', 100000.00, 'Pending'),
('PAY021', 21, 21, '2024-09-29', 250000.00, 'Paid'),
('PAY022', 22, 22, '2024-10-09', 180000.00, 'Failed'),
('PAY023', 23, 23, '2024-09-20', 300000.00, 'Paid'),
('PAY024', 24, 24, '2024-10-16', 420000.00, 'Pending'),
('PAY025', 25, 25, '2024-09-26', 200000.00, 'Paid'),
('PAY026', 26, 26, '2024-10-04', 280000.00, 'Failed'),
('PAY027', 27, 27, '2024-09-24', 380000.00, 'Paid'),
('PAY028', 28, 28, '2024-10-11', 220000.00, 'Pending'),
('PAY029', 29, 29, '2024-09-27', 150000.00, 'Paid'),
('PAY030', 30, 30, '2024-10-06', 320000.00, 'Failed'),
('PAY031', 31, 31, '2024-09-30', 450000.00, 'Paid'),
('PAY032', 32, 32, '2024-10-10', 100000.00, 'Pending'),
('PAY033', 33, 33, '2024-09-23', 250000.00, 'Paid'),
('PAY034', 34, 34, '2024-10-14', 420000.00, 'Failed'),
('PAY035', 35, 35, '2024-09-25', 300000.00, 'Paid'),
('PAY036', 36, 36, '2024-10-03', 200000.00, 'Pending'),
('PAY037', 37, 37, '2024-09-28', 380000.00, 'Paid'),
('PAY038', 38, 38, '2024-10-08', 280000.00, 'Failed'),
('PAY039', 39, 39, '2024-09-29', 150000.00, 'Paid'),
('PAY040', 40, 40, '2024-10-12', 320000.00, 'Pending'),
('PAY041', 41, 41, '2024-10-01', 220000.00, 'Paid'),
('PAY042', 42, 42, '2024-10-09', 450000.00, 'Failed'),
('PAY043', 43, 43, '2024-09-22', 200000.00, 'Paid'),
('PAY044', 44, 44, '2024-10-16', 100000.00, 'Pending'),
('PAY045', 45, 45, '2024-09-26', 300000.00, 'Paid'),
('PAY046', 46, 46, '2024-10-04', 420000.00, 'Failed'),
('PAY048', 48, 48, '2024-10-11', 380000.00, 'Paid'),
('PAY049', 49, 49, '2024-09-27', 280000.00, 'Pending'),
('PAY050', 50, 50, '2024-10-06', 200000.00, 'Failed'),
('PAY051', 51, 51, '2024-09-30', 450000.00, 'Paid'),
('PAY052', 52, 52, '2024-10-10', 150000.00, 'Pending'),
('PAY053', 53, 53, '2024-09-29', 320000.00, 'Paid'),
('PAY054', 54, 54, '2024-10-12', 220000.00, 'Failed'),
('PAY055', 55, 55, '2024-10-15', 400000.00, 'Paid'),
('PAY056', 56, 56, '2024-10-18', 120000.00, 'Pending'),
('PAY057', 57, 57, '2024-09-25', 350000.00, 'Paid'),
('PAY058', 58, 58, '2024-10-22', 280000.00, 'Failed'),
('PAY059', 59, 59, '2024-09-28', 450000.00, 'Paid'),
('PAY060', 60, 60, '2024-10-05', 200000.00, 'Pending'),
('PAY061', 61, 61, '2024-09-30', 380000.00, 'Paid'),
('PAY062', 62, 62, '2024-10-12', 320000.00, 'Failed'),
('PAY063', 63, 63, '2024-09-24', 250000.00, 'Paid'),
('PAY064', 64, 64, '2024-10-10', 150000.00, 'Pending'),
('PAY065', 65, 65, '2024-09-27', 420000.00, 'Paid'),
('PAY066', 66, 66, '2024-10-08', 300000.00, 'Failed'),
('PAY067', 67, 67, '2024-09-29', 200000.00, 'Paid'),
('PAY068', 68, 68, '2024-10-15', 380000.00, 'Pending'),
('PAY069', 69, 69, '2024-09-26', 450000.00, 'Paid'),
('PAY070', 70, 70, '2024-10-04', 220000.00, 'Failed'),
('PAY071', 71, 71, '2024-09-25', 350000.00, 'Paid'),
('PAY072', 72, 72, '2024-10-11', 280000.00, 'Pending'),
('PAY073', 73, 73, '2024-09-28', 400000.00, 'Paid'),
('PAY074', 74, 74, '2024-10-18', 200000.00, 'Failed'),
('PAY075', 75, 75, '2024-09-30', 320000.00, 'Paid'),
('PAY076', 76, 76, '2024-10-06', 150000.00, 'Pending'),
('PAY077', 77, 77, '2024-09-27', 420000.00, 'Paid'),
('PAY078', 78, 78, '2024-10-13', 300000.00, 'Failed'),
('PAY079', 79, 79, '2024-09-29', 250000.00, 'Paid'),
('PAY080', 80, 80, '2024-10-10', 380000.00, 'Pending'),
('PAY081', 81, 81, '2024-09-26', 450000.00, 'Paid'),
('PAY082', 82, 82, '2024-10-08', 220000.00, 'Failed'),
('PAY083', 83, 83, '2024-09-25', 350000.00, 'Paid'),
('PAY084', 84, 84, '2024-10-15', 280000.00, 'Pending'),
('PAY085', 85, 85, '2024-09-28', 400000.00, 'Paid'),
('PAY086', 86, 86, '2024-10-04', 200000.00, 'Failed'),
('PAY087', 87, 87, '2024-09-30', 320000.00, 'Paid'),
('PAY088', 88, 88, '2024-10-11', 150000.00, 'Pending'),
('PAY089', 89, 89, '2024-09-27', 420000.00, 'Paid'),
('PAY090', 90, 90, '2024-10-13', 300000.00, 'Failed'),
('PAY092', 92, 92, '2024-10-10', 450000.00, 'Paid'),
('PAY093', 93, 93, '2024-09-26', 380000.00, 'Pending'),
('PAY094', 94, 94, '2024-10-08', 200000.00, 'Failed'),
('PAY095', 95, 95, '2024-09-28', 350000.00, 'Paid'),
('PAY096', 96, 96, '2024-10-12', 280000.00, 'Pending'),
('PAY097', 97, 97, '2024-09-30', 420000.00, 'Paid'),
('PAY098', 98, 98, '2024-10-15', 320000.00, 'Failed'),
('PAY099', 99, 99, '2024-09-29', 250000.00, 'Paid'),
('PAY100', 100, 100, '2024-10-18', 450000.00, 'Pending');

-- data insertion in Discussion Forums' table

insert into discussionForum (disCode, cID, sID, content, postDate) values
('DIS001', 1, 1, 'Welcome to the course!', '2024-06-20'),
('DIS002', 2, 2, 'How do I access the course materials?', '2024-07-05'),
('DIS003', 3, 3, 'What is the deadline for the assignment?', '2024-08-10'),
('DIS004', 4, 4, 'Can someone help me with the project?', '2024-09-15'),
('DIS005', 5, 5, 'I am having trouble with the quiz.', '2024-07-25'),
('DIS006', 6, 6, 'How do I contact the instructor?', '2024-06-30'),
('DIS007', 7, 7, 'What are the office hours for the instructor?', '2024-08-20'),
('DIS008', 8, 8, 'Can someone explain the concept of machine learning?', '2024-09-10'),
('DIS009', 9, 9, 'How do I submit my assignment?', '2024-07-15'),
('DIS010', 10, 10, 'What is the grading criteria for the course?', '2024-06-25'),
('DIS011', 11, 11, 'I need help understanding the course syllabus.', '2024-10-01'),
('DIS012', 12, 12, 'Can someone share their notes from the last lecture?', '2024-10-08'),
('DIS013', 13, 13, 'What is the best way to study for the exam?', '2024-09-22'),
('DIS014', 14, 14, 'How do I form a study group?', '2024-10-15'),
('DIS015', 15, 15, 'I am having trouble with the programming assignment.', '2024-09-28'),
('DIS016', 16, 16, 'Can someone explain the concept of data structures?', '2024-10-05'),
('DIS017', 17, 17, 'How do I access the online resources?', '2024-09-18'),
('DIS018', 18, 18, 'What is the policy on late submissions?', '2024-10-12'),
('DIS019', 19, 19, 'Can someone help me with the group project?', '2024-09-25'),
('DIS020', 20, 20, 'How do I contact my teaching assistant?', '2024-10-02'),
('DIS021', 21, 21, 'What are the requirements for the final project?', '2024-09-29'),
('DIS022', 22, 22, 'Can someone share their experience with the course?', '2024-10-09'),
('DIS023', 23, 23, 'How do I get feedback on my assignments?', '2024-09-20'),
('DIS024', 24, 24, 'What is the deadline for the research paper?', '2024-10-16'),
('DIS025', 25, 25, 'Can someone explain the concept of algorithms?', '2024-09-26'),
('DIS026', 26, 26, 'How do I participate in the online discussions?', '2024-10-04'),
('DIS027', 27, 27, 'What are the expectations for the class participation?', '2024-09-19'),
('DIS028', 28, 28, 'Can someone help me with the statistical analysis?', '2024-10-11'),
('DIS029', 29, 29, 'How do I submit a request for accommodations?', '2024-09-24'),
('DIS030', 30, 30, 'What is the policy on academic integrity?', '2024-10-03'),
('DIS031', 31, 31, 'Can someone explain the concept of probability?', '2024-09-27'),
('DIS032', 32, 32, 'How do I access the course recordings?', '2024-10-10'),
('DIS033', 33, 33, 'What are the requirements for the midterm exam?', '2024-09-30'),
('DIS034', 34, 34, 'Can someone help me with the data visualization?', '2024-10-14'),
('DIS035', 35, 35, 'How do I get a course extension?', '2024-09-23'),
('DIS036', 36, 36, 'What is the policy on missed classes?', '2024-10-06'),
('DIS037', 37, 37, 'Can someone explain the concept of machine learning models?', '2024-09-25'),
('DIS038', 38, 38, 'How do I access the online library resources?', '2024-10-13'),
('DIS039', 39, 39, 'What are the expectations for the final presentation?', '2024-09-28'),
('DIS040', 40, 40, 'Can someone help me with the literature review?', '2024-10-01'),
('DIS041', 41, 41, 'How do I participate in the peer review process?', '2024-09-29'),
('DIS042', 42, 42, 'What is the deadline for the case study?', '2024-10-08'),
('DIS043', 43, 43, 'Can someone explain the concept of data mining?', '2024-09-22'),
('DIS044', 44, 44, 'How do I access the course simulation tools?', '2024-10-15'),
('DIS045', 45, 45, 'What are the requirements for the research proposal?', '2024-09-26'),
('DIS047', 47, 47, 'How do I cite sources in APA format?', '2024-10-12'),
('DIS048', 48, 48, 'Can someone explain the concept of cloud computing?', '2024-09-28'),
('DIS049', 49, 49, 'What are the benefits of using Linux?', '2024-10-05'),
('DIS050', 50, 50, 'How do I resolve a merge conflict in Git?', '2024-09-20'),
('DIS051', 51, 51, 'Can someone help me with the network security assignment?', '2024-10-10'),
('DIS052', 52, 52, 'What is the difference between SQL and NoSQL?', '2024-09-25'),
('DIS053', 53, 53, 'How do I optimize my database queries?', '2024-10-08'),
('DIS054', 54, 54, 'Can someone explain the concept of artificial intelligence?', '2024-09-22'),
('DIS055', 55, 55, 'What are the best practices for coding in Python?', '2024-10-15'),
('DIS056', 56, 56, 'How do I implement authentication in a web application?', '2024-09-29'),
('DIS057', 57, 57, 'Can someone help me with the data science project?', '2024-10-12'),
('DIS058', 58, 58, 'What is the difference between machine learning and deep learning?', '2024-09-26'),
('DIS059', 59, 59, 'How do I visualize data using Tableau?', '2024-10-05'),
('DIS060', 60, 60, 'Can someone explain the concept of cybersecurity?', '2024-09-20'),
('DIS061', 61, 61, 'What are the benefits of using Agile methodology?', '2024-10-11'),
('DIS062', 62, 62, 'How do I create a RESTful API?', '2024-09-24'),
('DIS063', 63, 63, 'Can someone help me with the software engineering assignment?', '2024-10-09'),
('DIS064', 64, 64, 'What is the difference between monolithic and microservices architecture?', '2024-09-27'),
('DIS065', 65, 65, 'How do I deploy a web application on AWS?', '2024-10-14'),
('DIS066', 66, 66, 'Can someone explain the concept of DevOps?', '2024-09-23'),
('DIS067', 67, 67, 'What are the best practices for testing and debugging?', '2024-10-07'),
('DIS068', 68, 68, 'How do I use Docker containers?', '2024-09-30'),
('DIS069', 69, 69, 'Can someone help me with the computer vision project?', '2024-10-13'),
('DIS070', 70, 70, 'What is the difference between natural language processing and machine learning?', '2024-09-29'),
('DIS071', 71, 71, 'How do I create a chatbot using Python?', '2024-10-06'),
('DIS072', 72, 72, 'Can someone explain the concept of blockchain?', '2024-09-25'),
('DIS073', 73, 73, 'What are the benefits of using Kubernetes?', '2024-10-12'),
('DIS074', 74, 74, 'How do I secure a web application using SSL/TLS?', '2024-09-22'),
('DIS075', 75, 75, 'Can someone help me with the data analytics assignment?', '2024-10-10'),
('DIS076', 76, 76, 'What is the difference between Apache Spark and Hadoop?', '2024-09-28'),
('DIS077', 77, 77, 'How do I use TensorFlow for machine learning?', '2024-10-08'),
('DIS078', 78, 78, 'Can someone explain the concept of computer networks?', '2024-09-24'),
('DIS079', 79, 79, 'What are the best practices for database design?', '2024-10-15'),
('DIS080', 80, 80, 'How do I create a mobile application using React Native?', '2024-09-30'),
('DIS082', 82, 82, 'What is the difference between Vue.js and React.js?', '2024-10-14'),
('DIS083', 83, 83, 'How do I use GraphQL for API development?', '2024-09-27'),
('DIS084', 84, 84, 'Can someone explain the concept of web scraping?', '2024-10-11'),
('DIS085', 85, 85, 'What are the benefits of using MongoDB?', '2024-09-25'),
('DIS086', 86, 86, 'How do I create a progressive web app?', '2024-10-09'),
('DIS087', 87, 87, 'Can someone help me with the data visualization project?', '2024-10-07'),
('DIS088', 88, 88, 'What is the difference between Java and Python?', '2024-09-23'),
('DIS089', 89, 89, 'How do I use Jenkins for continuous integration?', '2024-10-13'),
('DIS090', 90, 90, 'Can someone explain the concept of test-driven development?', '2024-09-29'),
('DIS091', 91, 91, 'What are the best practices for code review?', '2024-10-06'),
('DIS092', 92, 92, 'How do I create a RESTful API using Node.js?', '2024-09-26'),
('DIS093', 93, 93, 'Can someone help me with the machine learning assignment?', '2024-10-12'),
('DIS094', 94, 94, 'What is the difference between Angular and React?', '2024-09-24'),
('DIS095', 95, 95, 'How do I use AWS Lambda for serverless computing?', '2024-10-10'),
('DIS096', 96, 96, 'Can someone explain the concept of containerization?', '2024-09-28'),
('DIS097', 97, 97, 'What are the benefits of using TypeScript?', '2024-10-09'),
('DIS098', 98, 98, 'How do I create a single-page application?', '2024-09-27'),
('DIS099', 99, 99, 'Can someone help me with the web development project?', '2024-10-08'),
('DIS100', 100, 100, 'What is the difference between NoSQL and relational databases?', '2024-09-25');

-- data insertion in notifications table

insert into notifications (notfCode, uID, message, status, sentDate) values
('notF001', 1, 'Welcome to the platform!', 'Unread', '2024-06-20'),
('notF002', 2, 'You have a new message!', 'Unread', '2024-07-05'),
('notF003', 3, 'Your course is starting soon!', 'Read', '2024-08-10'),
('notF004', 4, 'You have earned a badge!', 'Unread', '2024-09-15'),
('notF005', 5, 'Your assignment is due soon!', 'Read', '2024-07-25'),
('notF006', 6, 'You have a new notification!', 'Unread', '2024-06-30'),
('notF007', 7, 'Your course has been updated!', 'Read', '2024-08-20'),
('notF008', 8, 'You have been mentioned in a post!', 'Unread', '2024-09-10'),
('notF009', 9, 'Your badge has been revoked!', 'Read', '2024-07-15'),
('notF010', 10, 'You have a new course available!', 'Unread', '2024-06-25'),
('notF011', 11, 'You have a new follower!', 'Unread', '2024-10-01'),
('notF012', 12, 'Your profile has been updated!', 'Read', '2024-10-08'),
('notF013', 13, 'You have earned a new achievement!', 'Unread', '2024-09-22'),
('notF014', 14, 'You have been invited to a group!', 'Read', '2024-10-15'),
('notF015', 15, 'Your account has been verified!', 'Unread', '2024-09-28'),
('notF016', 16, 'You have a new private message!', 'Read', '2024-10-05'),
('notF017', 17, 'Your course enrollment is confirmed!', 'Unread', '2024-09-18'),
('notF018', 18, 'You have been assigned a new task!', 'Read', '2024-10-12'),
('notF019', 19, 'Your password has been reset!', 'Unread', '2024-09-25'),
('notF020', 20, 'You have a new announcement!', 'Read', '2024-10-02'),
('notF021', 21, 'Your subscription has been renewed!', 'Unread', '2024-09-29'),
('notF022', 22, 'You have been mentioned in a comment!', 'Read', '2024-10-09'),
('notF023', 23, 'Your payment has been processed!', 'Unread', '2024-09-20'),
('notF024', 24, 'You have a new system update!', 'Read', '2024-10-16'),
('notF025', 25, 'Your account has been suspended!', 'Unread', '2024-09-26'),
('notF026', 26, 'You have a new support ticket!', 'Read', '2024-10-04'),
('notF027', 27, 'Your course materials are available!', 'Unread', '2024-09-19'),
('notF028', 28, 'You have been added to a team!', 'Read', '2024-10-11'),
('notF029', 29, 'Your profile picture has been updated!', 'Unread', '2024-09-24'),
('notF030', 30, 'You have a new notification filter!', 'Read', '2024-10-03'),
('notF031', 31, 'Your account has been merged!', 'Unread', '2024-09-27'),
('notF032', 32, 'You have a new security alert!', 'Read', '2024-10-10'),
('notF033', 33, 'Your payment method has been updated!', 'Unread', '2024-09-30'),
('notF034', 34, 'You have a new course recommendation!', 'Read', '2024-10-08'),
('notF035', 35, 'Your subscription is about to expire!', 'Unread', '2024-09-22'),
('notF036', 36, 'You have a new private chat!', 'Read', '2024-10-15'),
('notF037', 37, 'Your account has been verified by admin!', 'Unread', '2024-09-28'),
('notF038', 38, 'You have a new system announcement!', 'Read', '2024-10-05'),
('notF039', 39, 'Your course enrollment is pending!', 'Unread', '2024-09-18'),
('notF040', 40, 'You have a new security update!', 'Read', '2024-10-12'),
('notF041', 41, 'Your profile completeness is 100%!', 'Unread', '2024-09-25'),
('notF042', 42, 'You have a new badge request!', 'Read', '2024-10-09'),
('notF043', 43, 'Your account has been flagged!', 'Unread', '2024-09-20'),
('notF044', 44, 'You have a new course review!', 'Read', '2024-10-16'),
('notF045', 45, 'Your subscription has been canceled!', 'Unread', '2024-09-26'),
('notF046', 46, 'You have a new support response!', 'Read', '2024-10-04'),
('notF047', 47, 'You don"t share the same classes in 5th semester', 'Read', '2024-10-04'),
('notF048', 48, 'You have a new invitation to collaborate!', 'Unread', '2024-10-14'),
('notF049', 49, 'Your account has been upgraded!', 'Read', '2024-09-27'),
('notF050', 50, 'You have earned a new reward!', 'Unread', '2024-10-11'),
('notF051', 51, 'Your course materials have been updated!', 'Read', '2024-09-29'),
('notF052', 52, 'You have a new message from the admin!', 'Unread', '2024-10-08'),
('notF053', 53, 'Your subscription is now active!', 'Read', '2024-09-22'),
('notF054', 54, 'You have been assigned a new mentor!', 'Unread', '2024-10-15'),
('notF055', 55, 'Your account has been verified by phone!', 'Read', '2024-09-28'),
('notF056', 56, 'You have a new course available in your dashboard!', 'Unread', '2024-10-05'),
('notF057', 57, 'Your payment has been declined!', 'Read', '2024-09-19'),
('notF058', 58, 'You have earned a new certification!', 'Unread', '2024-10-12'),
('notF059', 59, 'Your account has been locked!', 'Read', '2024-09-25'),
('notF060', 60, 'You have a new announcement from the instructor!', 'Unread', '2024-10-09'),
('notF061', 61, 'Your course enrollment has been approved!', 'Read', '2024-09-20'),
('notF062', 62, 'You have a new private message from a colleague!', 'Unread', '2024-10-16'),
('notF063', 63, 'Your account has been merged with another account!', 'Read', '2024-09-26'),
('notF064', 64, 'You have earned a new badge!', 'Unread', '2024-10-04'),
('notF065', 65, 'Your subscription has been downgraded!', 'Read', '2024-09-18'),
('notF066', 66, 'You have a new course review request!', 'Unread', '2024-10-11'),
('notF067', 67, 'Your account has been verified by email!', 'Read', '2024-09-29'),
('notF068', 68, 'You have a new security alert!', 'Unread', '2024-10-08'),
('notF069', 69, 'Your course materials are ready for download!', 'Read', '2024-09-22'),
('notF070', 70, 'You have been invited to a webinar!', 'Unread', '2024-10-15'),
('notF071', 71, 'Your account has been suspended temporarily!', 'Read', '2024-09-28'),
('notF072', 72, 'You have earned a new reward!', 'Unread', '2024-10-05'),
('notF073', 73, 'Your course enrollment is pending approval!', 'Read', '2024-09-19'),
('notF074', 74, 'You have a new private chat invitation!', 'Unread', '2024-10-12'),
('notF075', 75, 'Your account has been verified by admin!', 'Read', '2024-09-25'),
('notF076', 76, 'You have a new course available in your catalog!', 'Unread', '2024-10-09'),
('notF077', 77, 'Your subscription has been canceled!', 'Read', '2024-09-20'),
('notF078', 78, 'You have earned a new achievement!', 'Unread', '2024-10-16'),
('notF079', 79, 'Your account has been locked due to inactivity!', 'Read', '2024-09-26'),
('notF080', 80, 'You have a new announcement from the team!', 'Unread', '2024-10-04'),
('notF081', 81, 'Your course materials have been updated!', 'Read', '2024-09-18'),
('notF082', 82, 'You have been assigned a new task!', 'Unread', '2024-10-11'),
('notF083', 83, 'Your account has been verified by phone!', 'Read', '2024-09-29'),
('notF084', 84, 'You have earned a new badge!', 'Unread', '2024-10-08'),
('notF085', 85, 'Your subscription has been downgraded!', 'Read', '2024-09-22'),
('notF086', 86, 'You have a new course review request!', 'Unread', '2024-10-15'),
('notF087', 87, 'Your account has been merged with another account!', 'Read', '2024-09-28'),
('notF088', 88, 'You have a new security alert!', 'Unread', '2024-10-05'),
('notF089', 89, 'Your course materials are ready for download!', 'Read', '2024-09-19'),
('notF090', 90, 'You have been invited to a webinar!', 'Unread', '2024-10-12'),
('notF091', 91, 'Your account has been suspended temporarily!', 'Read', '2024-09-25'),
('notF092', 92, 'You have earned a new reward!', 'Unread', '2024-10-09'),
('notF093', 93, 'Your course enrollment is pending approval!', 'Read', '2024-09-20'),
('notF094', 94, 'You have a new private chat invitation!', 'Unread', '2024-10-16'),
('notF095', 95, 'Your account has been verified by admin!', 'Read', '2024-09-26'),
('notF096', 96, 'You have a new course available in your catalog!', 'Unread', '2024-10-04'),
('notF097', 97, 'Your subscription has been canceled!', 'Read', '2024-09-18'),
('notF098', 98, 'You have earned a new achievement!', 'Unread', '2024-10-11'),
('notF099', 99, 'Your account has been locked due to inactivity!', 'Read', '2024-09-29'),
('notF100', 100, 'You have a new announcement from the team!', 'Unread', '2024-10-08');

-- data insertion in Courses table

insert into badges (bdgCode, badgeName, description, criteria) values
('BDG001', 'Newbie', 'Welcome to the platform!', 'Sign up for an account'),
('BDG002', 'Student', 'Enroll in a course!', 'Enroll in a course'),
('BDG003', 'Learner', 'Complete a course!', 'Complete a course'),
('BDG004', 'Achiever', 'Earn 5 badges!', 'Earn 5 badges'),
('BDG005', 'Explorer', 'Explore 10 courses!', 'Explore 10 courses'),
('BDG006', 'Contributor', 'Make 5 posts!', 'Make 5 posts'),
('BDG007', 'Leader', 'Earn 10 badges!', 'Earn 10 badges'),
('BDG008', 'Mentor', 'Mentor 5 students!', 'Mentor 5 students'),
('BDG009', 'Expert', 'Complete 5 courses!', 'Complete 5 courses'),
('BDG010', 'Master', 'Earn 20 badges!', 'Earn 20 badges'),
('BDG011', 'Scholar', 'Complete 10 courses!', 'Complete 10 courses'),
('BDG012', 'Researcher', 'Explore 20 courses!', 'Explore 20 courses'),
('BDG013', 'innovator', 'Create 5 new topics!', 'Create 5 new topics'),
('BDG014', 'Collaborator', 'Participate in 10 discussions!', 'Participate in 10 discussions'),
('BDG015', 'Visionary', 'Earn 30 badges!', 'Earn 30 badges'),
('BDG016', 'Pioneer', 'Be one of the first 100 users!', 'Be one of the first 100 users'),
('BDG017', 'Ambassador', 'invite 10 friends!', 'invite 10 friends'),
('BDG018', 'Champion', 'Complete 20 courses!', 'Complete 20 courses'),
('BDG019', 'Thought Leader', 'Create 10 new topics!', 'Create 10 new topics'),
('BDG020', 'Community Builder', 'Participate in 20 discussions!', 'Participate in 20 discussions'),
('BDG021', 'Expertise', 'Earn 40 badges!', 'Earn 40 badges'),
('BDG022', 'Trailblazer', 'Be one of the first 500 users!', 'Be one of the first 500 users'),
('BDG023', 'Socialite', 'Make 20 posts!', 'Make 20 posts'),
('BDG024', 'Maverick', 'Complete 30 courses!', 'Complete 30 courses'),
('BDG025', 'Luminary', 'Create 20 new topics!', 'Create 20 new topics'),
('BDG026', 'Catalyst', 'Participate in 30 discussions!', 'Participate in 30 discussions'),
('BDG027', 'Pacesetter', 'Earn 50 badges!', 'Earn 50 badges'),
('BDG028', 'Trendsetter', 'Be one of the first 1000 users!', 'Be one of the first 1000 users'),
('BDG029', 'Vanguard', 'Make 30 posts!', 'Make 30 posts'),
('BDG030', 'Paragon', 'Complete 40 courses!', 'Complete 40 courses'),
('BDG031', 'Icon', 'Create 30 new topics!', 'Create 30 new topics'),
('BDG032', 'Pioneer Spirit', 'Participate in 40 discussions!', 'Participate in 40 discussions'),
('BDG033', 'Excellence', 'Earn 60 badges!', 'Earn 60 badges'),
('BDG034', 'Vintage', 'Timeless wisdom and dedication!', 'Earn 500+ badges'),
('BDG035', 'influencer', 'Make 40 posts!', 'Make 40 posts'),
('BDG036', 'Hero', 'Complete 50 courses!', 'Complete 50 courses'),
('BDG037', 'Legend', 'Create 40 new topics!', 'Create 40 new topics'),
('BDG038', 'Champion of Discussion', 'Participate in 50 discussions!', 'Participate in 50 discussions'),
('BDG039', 'Supreme', 'Earn 80 badges!', 'Earn 80 badges'),
('BDG040', 'Legacy', 'Be one of the first 5000 users!', 'Be one of the first 5000 users'),
('BDG041', 'Visionary Leader', 'Make 50 posts!', 'Make 50 posts'),
('BDG042', 'Mastermind', 'Complete 60 courses!', 'Complete 60 courses'),
('BDG043', 'Trailblazer Icon', 'Create 50 new topics!', 'Create 50 new topics'),
('BDG044', 'Discussion Guru', 'Participate in 60 discussions!', 'Participate in 60 discussions'),
('BDG045', 'Elite', 'Earn 100 badges!', 'Earn 100 badges'),
('BDG046', 'Pinnacle', 'Be one of the first 10000 users!', 'Be one of the first 10000 users'),
('BDG047', 'Thought Leader Legend', 'Make 60 posts!', 'Make 60 posts'),
('BDG048', 'Course Completionist', 'Complete 70 courses!', 'Complete 70 courses'),
('BDG049', 'Content Creator', 'Create 60 new topics!', 'Create 60 new topics'),
('BDG050', 'Discussion Master', 'Participate in 70 discussions!', 'Participate in 70 discussions'),
('BDG051', 'Vanguard', 'Complete 80 courses!', 'Complete 80 courses'),
('BDG052', 'Illuminator', 'Create 70 new topics!', 'Create 70 new topics'),
('BDG053', 'Conversation Starter', 'Participate in 80 discussions!', 'Participate in 80 discussions'),
('BDG054', 'Virtuoso', 'Earn 120 badges!', 'Earn 120 badges'),
('BDG055', 'Legendary Status', 'Be one of the first 20000 users!', 'Be one of the first 20000 users'),
('BDG056', 'Mastermind Mentor', 'Mentor 20 students!', 'Mentor 20 students'),
('BDG057', 'Content Connoisseur', 'Explore 50 courses!', 'Explore 50 courses'),
('BDG058', 'Discussion Dynamo', 'Make 80 posts!', 'Make 80 posts'),
('BDG059', 'Course Crusader', 'Complete 90 courses!', 'Complete 90 courses'),
('BDG060', 'Visionary Voice', 'Create 80 new topics!', 'Create 80 new topics'),
('BDG061', 'Community Champion', 'Participate in 90 discussions!', 'Participate in 90 discussions'),
('BDG062', 'Excellence Emblem', 'Earn 150 badges!', 'Earn 150 badges'),
('BDG063', 'Pioneer Spirit Award', 'Be one of the first 50000 users!', 'Be one of the first 50000 users'),
('BDG064', 'Thought Leadership', 'Make 100 posts!', 'Make 100 posts'),
('BDG065', 'Course Completion Mastery', 'Complete 100 courses!', 'Complete 100 courses'),
('BDG066', 'Content Creator Legend', 'Create 100 new topics!', 'Create 100 new topics'),
('BDG067', 'Discussion Maestro', 'Participate in 100 discussions!', 'Participate in 100 discussions'),
('BDG068', 'Supreme Achievement', 'Earn 180 badges!', 'Earn 180 badges'),
('BDG069', 'Legacy Leader', 'Be one of the first 100000 users!', 'Be one of the first 100000 users'),
('BDG070', 'Visionary Icon', 'Make 120 posts!', 'Make 120 posts'),
('BDG071', 'Course Mastery', 'Complete 110 courses!', 'Complete 110 courses'),
('BDG072', 'Content Conqueror', 'Create 120 new topics!', 'Create 120 new topics'),
('BDG073', 'Discussion Guru', 'Participate in 110 discussions!', 'Participate in 110 discussions'),
('BDG074', 'Excellence Award', 'Earn 210 badges!', 'Earn 210 badges'),
('BDG075', 'Pinnacle of Success', 'Be one of the first 200000 users!', 'Be one of the first 200000 users'),
('BDG076', 'Thought Leadership Mastery', 'Make 150 posts!', 'Make 150 posts'),
('BDG077', 'Course Completion Expert', 'Complete 120 courses!', 'Complete 120 courses'),
('BDG078', 'Content Creation Legend', 'Create 150 new topics!', 'Create 150 new topics'),
('BDG079', 'Discussion Mastery', 'Participate in 120 discussions!', 'Participate in 120 discussions'),
('BDG080', 'Supreme Legacy', 'Earn 250 badges!', 'Earn 250 badges'),
('BDG081', 'Legendary Pioneer', 'Be one of the first 500000 users!', 'Be one of the first 500000 users'),
('BDG082', 'Visionary Leader', 'Make 180 posts!', 'Make 180 posts'),
('BDG083', 'Course Mastery Expert', 'Complete 130 courses!', 'Complete 130 courses'),
('BDG084', 'Content Creation Icon', 'Create 180 new topics!', 'Create 180 new topics'),
('BDG085', 'Discussion Expert', 'Participate in 130 discussions!', 'Participate in 130 discussions'),
('BDG086', 'Excellence Emblem', 'Earn 300 badges!', 'Earn 300 badges'),
('BDG087', 'Pioneer Spirit Legend', 'Be one of the first 1000000 users!', 'Be one of the first 1000000 users'),
('BDG088', 'Thought Leadership Icon', 'Make 200 posts!', 'Make 200 posts'),
('BDG089', 'Course Completion Mastery', 'Complete 140 courses!', 'Complete 140 courses'),
('BDG090', 'Content Creation Mastery', 'Create 200 new topics!', 'Create 200 new topics'),
('BDG091', 'Discussion Mastery', 'Participate in 140 discussions!', 'Participate in 140 discussions'),
('BDG092', 'Supreme Achievement', 'Earn 350 badges!', 'Earn 350 badges'),
('BDG093', 'Legacy Leader', 'Be one of the first 2000000 users!', 'Be one of the first 2000000 users'),
('BDG094', 'Visionary Icon', 'Make 220 posts!', 'Make 220 posts'),
('BDG095', 'Course Mastery Expert', 'Complete 150 courses!', 'Complete 150 courses'),
('BDG096', 'Content Creation Legend', 'Create 220 new topics!', 'Create 220 new topics'),
('BDG097', 'Discussion Expert', 'Participate in 150 discussions!', 'Participate in 150 discussions'),
('BDG098', 'Excellence Award', 'Earn 400 badges!', 'Earn 400 badges'),
('BDG099', 'Pinnacle of Success', 'Be one of the first 5000000 users!', 'Be one of the first 5000000 users'),
('BDG100', 'Thought Leadership Mastery', 'Make 250 posts!', 'Make 250 posts');

-- showcase data population

select * from assessment;
select * from assignments;
select * from badges;
select * from category;
select * from certificate;
select * from courses;
select * from discussionforum;
select * from enroll;
select * from lessons;
select * from modules;
select * from notifications;
select * from payments;
select * from quiz;
select * from reviews;
select * from submissions;
select * from users;

-- making sense of grades column in submission

update submissions
set grade = grade - 10
where grade > 100 and grade < 110;

update submissions
set grade = grade - 20
where grade >= 110;

update submissions
set grade = grade - 3;

update submissions
set feedback = 'you deserve the whole world bro <3'
where grade >= 95;

select * from submissions;

-- made custom URLs for "Content Links" in "Lessons" table

update lessons
set contentLink = concat('https://example.com/', replace(ltitle, '','-'));

-- adding scored marks in assessments because i forgot 

alter table assessment 
add score int(11);

update assessment
set score = floor(rand() * (50 - 20 + 1)) + 20;

update assessment
set tmarks = 25
where score between 0 and 23;

update assessment
set tmarks = 30
where score between 24 and 30;

update assessment
set tmarks = 45
where score between 30 and 45;

update assessment
set tmarks = 50
where score between 45 and 50;

select * from assessment;

-- linking lessons and courses

ALTER TABLE lessons
ADD courseID inT(11);

ALTER TABLE lessons
ADD ConSTRAinT fk_courseID FOREIGN KEY (courseID)
REFERENCES courses(courseID) on DELETE CasCADE;

UPDATE lessons
SET courseID = (
    select courseID 
    from courses
    order by Rand()
    limit 1
);

alter table assessment
add sID int(11);

alter table assessment
add constraint uIDas foreign key (sID)
references users(userID) on delete cascade;

update assessment
set sID = (
	select u.userID
    from users u
	where u.role = 'Student'
    order by rand()
    limit 1
);

-- Course

alter table assessment
add cID int(11);

alter table assessment
add constraint cIDas foreign key (cID)
references courses(courseID) on delete cascade;

update assessment
set cID = (
	select courseID
    from courses
    order by rand()
    limit 1
);

-- ALTER TABLE courses DROP FOREIGN KEY lsn_crs;

/*``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ implementation for "join Queries" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

```````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````*/

-- 1. Find instructors and the Courses They Teach

select u.fname, u.lname, c.courseName
from users u
inner join courses c on u.userID = c.instID
where u.role like 'instructor';

-- 2. instructors' Ratings:

select distinct u.fname, u.lname, c.courseName, avg(r.rating) as avg_rating
from users u
join courses c on u.userID = c.instID
join reviews r on c.courseID = r.cID
where u.role like 'instructor'
group by u.userID, c.courseID
order by avg_rating desc
limit 3;

-- 3. Displays students who haven’t submitted asignments

select u.fname, u.lname
from users u
left join submissions s on u.userID = s.sID
left join assignments a on s.asID = a.asgmntID
where s.subID is null and u.role = 'Student';

-- 4. instructor's salary per course:

select u.fname, u.lname, c.courseName, sum(p.amount) as salary
from users u 
join courses c on u.userID = c.instID
join payments p on c.courseID = p.cID
where u.role = 'instructor'
group by u.userID 
order by salary desc;

-- 5. Total revenue generated by each course:

select c.courseName, sum(p.amount) as totalRev
from courses c
join payments p on c.courseID = p.cID
group by c.courseName
order by totalRev desc;

-- 6. Average student progress by course:

select c.courseName, avg(e.progress) as avgProg
from courses c
join enroll e on c.courseID = e.cID
group by c.courseName 
having avgProg > 50;

-- 7. Find All Certificates Issued for Completed Courses

select u.fname, u.lname, c.courseName, certf.certLink
from users u
inner join certificate certf on u.userID = certf.sID
inner join courses c on certf.cID = c.courseID
inner join enroll e on u.userID = e.studID and e.status = 'Completed'
where u.role = 'Student';

-- 8. Find Quizzes and Their associated Lessons and Courses

select q.qtext, l.ltitle as topic, c.courseName
from quiz q
inner join lessons l on q.asID = l.lessonID
inner join modules m on l.modID = m.moduleID
inner join courses c on m.cID = c.courseID;

-- 9 List all lessons with their course and module

select l.ltitle as topic, m.moduleName, c.courseName 
from lessons l 
inner join modules m on l.modID = m.moduleID
inner join courses c on m.cID = c.courseID;

-- 10. Top 5 Courses with the Most Revenue

select c.courseName, sum(p.amount) as totalRev
from courses c
inner join payments p on c.courseID = p.cID
group by c.courseName
order by totalRev desc
limit 5;


/*``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ implementation for "Co-related Queries" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

```````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````*/

-- 1. Find the courses where the average score of students in their assessments is higher than the average score of all courses (along with student names).

select c.courseName, u.fname, u.lname, avg(a.score) as course_avg
from courses c
join lessons l on c.courseID = l.courseID
join assessment a on l.lessonID = a.lessonID
join users u on a.sID = u.userID
group by c.courseID
having avg(a.score) > (select avg (score) from assessment);

-- 2. Which student has enrolled in the most courses?

select u.fname, u.lname, count(e.cID) as course_count
from users u
join enroll e on u.userID = e.studID
where u.role = 'Student'
group by u.userID
order by count(e.cID) desc;  -- limit 1;

-- 3. Payment Reminder (send notification (emails) to students)
 
select u.fname, u.lname, u.email, p.payDate, p.amount
from Users u
join Payments p on u.userID = p.sID
where p.status = 'Pending' and u.role = 'Student' and datediff(curdate(), p.payDate) > 7;

-- 4. Students active on Discussion Forums

select u.userID, u.fname, u.lname, count(df.postID) as postcount
from users u
join discussionForum df on u.userID = df.sID
where u.role = 'Student'
group by u.userID
order by postcount desc;

-- 5. Display the students who have submitted all assignments  for the courses they are enrolled in.

select u.fname, u.lname, c.courseName
from users u
join enroll e on u.userID = e.studID
join courses c on e.cID = c.courseID
join lessons l on c.courseID = l.courseID
left join assignments a on l.lessonID = a.lessID
left join submissions s on a.asgmntID = s.asID and s.sID = u.userID
group by u.userID, c.courseID
having count(distinct a.asgmntID) = count(distinct s.subID);

-- 6. Identify courses that have more than 2 modules but less than 5 lessons across all modules.

select c.courseName
from courses c
where (
	select count(m.moduleID) 
    from modules m 
    where m.cID = c.courseID) > 2
and (
		select count(l.lessonID) 
		from lessons l 
		where l.modID in (
				select modID 
				from modules 
				where courseID = c.courseID)) < 5;

-- 7. instructors with High Student Satisfaction 

select u.userID, u.fname, u.lname, avg(r.rating) as avgRating
from users u
join courses c on c.instID = u.userID
join reviews r on c.courseID = r.cID
where r.rating > 4 and u.role = 'instructor'
group by u.userID
having count(distinct c.courseID) > 2;

-- 8. List the modules that have lessons with a total duration longer than the duration of all lessons in that course.

select m.moduleName
from modules m
where 
(
	select sum(l.duration) 
	from lessons l 
	where l.modID = m.moduleID) > 
      (
		select avg(l2.duration)
		from lessons l2 
		where l2.modID in (
		select modID 
        from modules 
        where courseID = m.cID
       )
);
       
-- 9. Recommend courses to students based on their enrollment history.

select u.fname, u.lname, c.courseName as Course_Recommendation
from Users u
join Enroll e on u.userID = e.studID
join Courses c on e.cID = c.courseID
where c.category = (
  select category
  from Courses
  where courseID = e.cID
  and u.role = 'Student'
);

-- 10. Display the courses where the average review rating is higher than 4.5 across all students.

select c.courseName, avg(r.rating) as avg_rating
from courses c
join reviews r on c.courseID = r.cID
group by c.courseID
having avg(r.rating) > 4.5
order by avg_rating desc;

-- 11. Students with Completed Courses and Badges

select u.userID, u.fname, u.lname, count(cert.certID) as completioncount, b.badgeName
from users u
join certificate cert on u.userID = cert.sID
join badges b on cert.cID = b.bdgID
where u.role = 'Student' and cert.issueDate IS not NULL
group by u.userID;

-- 12. Students with High assignment Scores

select u.userID, u.fname, u.lname, avg(a.score) as avgScore
from users u
join submissions s on u.userID = s.sID
join assessment a on s.asID = a.asID
where u.role = 'Student' -- and a.score > 80
group by u.userID
order by avgScore desc;

/*``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ implementation for "Sub Queries" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

```````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````*/
-- 1. Displays every course name with the total count of its modules in descending order

select c.courseName,
	(select count(*)
	from modules m
	where m.cID = c.courseID) AS module_count
from courses c
order by module_count desc;

-- 2. Displays the names of all students who enrolled in courses in the year 2024 (using exists).

select u.fname, u.lname
from users u
where exists (
    select 1 
    from enroll e 
    where e.studID = u.userID 
    and year(e.enDate) = 2024
)
and u.role = 'Student';

-- 3. Display the names of those instructors whose at least one student lives in ‘Cantt’ (using ANY operator).

select u.fname, u.lname
from users u
where u.role = 'instructor'
and u.userID = ANY (
    select c.instID 
    from courses c
    inner join enroll e ON c.courseID = e.cID
    inner join users s ON e.studID = s.userID
    where s.address LIKE '%Cantt%'
);

-- 4. Display module IDs whose content length is less than the average content length of all modules.

select m.moduleID, m.moduleName
from modules m
where length(m.content) < (
    select avg(length(content)) from modules);
    

-- 5. Retrieve the total duration of each Computer Science categorey, sorted in ascending order.

select c.courseName, sum(c.duration) as Duration
from Courses c
where c.category = 'Computer Science'
group by courseID
order by duration asc;

-- 6. Display the instructors' names and course names for instructors who are teaching courses with less than 5 lessons.

select u.fname, u.lname, c.courseName
from users u
inner join courses c ON u.userID = c.instID
where (select count(*) 
       from lessons l 
       inner join modules m ON l.modID = m.moduleID 
       where m.cID = c.courseID) < 5 and u.role = 'instructor';

-- 7. Display the names of courses that have lessons of type 'Quiz'.

select c.courseName
from courses c
where exists (
    select 1
    from lessons l
    inner join modules m ON l.modID = m.moduleID
    where m.cID = c.courseID
    and l.contentType = 'Quiz'
);

-- 8. Display the names of students who have not enrolled in any courses in 2024.

select u.fname, u.lname
from users u
where u.role = 'Student'
and not exists (
    select 1
    from enroll e
    where e.studID = u.userID
    and year(e.enDate) = 2024
);

-- 9. Display the names of students who have enrolled in courses with at least one level of "Advanced" course.

select u.fname, u.lname
from users u
where u.role = 'Student'
and exists (
    select 1 
    from courses c
    where c.level = 'Advanced'
    and exists (
        select 1 
        from enroll e
        where e.cID = c.courseID
        and e.studID = u.userID
    )
);

-- 10. Display the names of instructors who are teaching less than 3 courses.

select u.fname, u.lname
from users u
where u.role = 'instructor'
and (select count(*) from courses c where c.instID = u.userID) < 3;

-- 11. Display the names of all courses that have more than 2 modules.

select c.courseName
from courses c
where (select count(*) from modules m where m.cID = c.courseID) > 2;


/*``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ implementation for "Nested Queries" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

```````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````*/

-- 1. Average assessment score for 'advanced' level courses

select avg(score)
from assessment
where lessonID in (
    select lessonID 
    from lessons 
    where modID in (
        select modID 
        from modules 
        where cID in (
            select courseID 
            from courses 
            where level = 'Advanced'
        )
    )
);

-- 2. Find the total number of lessons in modules that belong to 'Data Structures and Algorithms' course

select count(lessonID)
from lessons
where modID in (
    select modID
    from modules
    where cID = (select courseID from courses where courseName = 'Data Structures and Algorithms')
);

-- 3. Students who have earned badges

select fname, lname
from users
where userID in (
    select userID
    from badges
    where role = 'Student'
);


-- 4. List courses where students have made more than 10 submissions in total but the average quiz score is below 60:

select courseName
from courses
where courseID in (
    select courseID 
    from submissions 
    group by courseID 
    having count(subID) > 10
)
and courseID in (
    select courseID 
    from assessment 
    where type = 'Quiz'
    group by courseID 
    having avg(score) < 60
);

-- 5. Find lessons that belong to the course with the highest review ratings

select courseID, ltitle as Title
from lessons
where modID in (
    select modID 
    from modules 
    where cID = (
        select courseID
        from reviews 
        group by courseID 
        order by avg(rating) desc
        limit 1
    )
);

-- 6. Display the students' names and contact details who are enrolled in courses with a duration greater than 60 hours using an inner join.

select u.fname, u.lname, u.contact
from users u
inner join courses c ON u.userID = c.instID
where c.duration > 20 and u.role = 'Student';

-- 7. Display the first and last name of the instructor along with the course name for the course with the maximum duration.

select u.fname, u.lname, c.courseName
from users u
inner join courses c ON u.userID = c.instID
where c.duration = (select max(duration) from courses)
and u.role = 'instructor';

-- 8. Retrieve users who are instructors of not Advanced courses.

select u.*
from users u
where u.userID in (select instID from courses) 
and u.userID not in (select instID from courses where level = 'Advanced');

-- 9. Display the complete records of lessons created in a module along with the course name and instructor name.

select u.fname, u.lname, l.*, c.courseName
from lessons l
inner join modules m ON l.modID = m.moduleID
inner join courses c ON m.cID = c.courseID
inner join users u ON c.instID = u.userID;

-- 10. Using the in command, display the users' names and the courses they are teaching, including only beginner-level courses.

select u.fname, u.lname, c.courseName
from users u
inner join courses c ON u.userID = c.instID
where c.level in ('Beginner');

-- 11. Display the names and roles of all users, along with the course name they are teaching or learning, using multiple RIGHT JOinS.

select u.fname, u.lname, u.role, c.courseName
from users u
RIGHT JOin courses c ON u.userID = c.instID
RIGHT JOin modules m ON c.courseID = m.cID;

-- 12. Display the course names of all courses that have both lessons and modules assigned to them, using multiple in commands.

select c.courseName
from courses c
where c.courseID in (select m.cID from modules m) 
and c.courseID in (select l.modID from lessons l);



SET SQL_SAFE_UPDATES = 1; 																														-- requiring a where clause for UPDATE and DELETE statements to prevent accidental data modification.
SET FOREIGN_KEY_CHECKS = 1; 	


show tables;
describe assessment;
describe assignments;
describe badges;
describe category;
describe certificate;
describe courses;
describe discussionforum;
describe enroll;
describe lessons;
describe modules;
describe notifications;
describe payments;
describe quiz;
describe reviews;
describe submissions;
describe users;
																												-- enforcing referential integrity constraints to ensure data consistency across related tables.
                                                                                                                