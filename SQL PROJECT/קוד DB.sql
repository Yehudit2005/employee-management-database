---------------------קוד דאתבייס עירייה----------

create database MunicipalityYehudit collate hebrew_100_ci_as
use  MunicipalityYehudit
go
create table Workers (
    WorkerID INT IDENTITY(1,1) not null,
    FirstName VARCHAR(100) not null,
    LastName VARCHAR(100) not null,
    IDNumber int ,
	CityID INT,
    DepartmentID INT,
    RoleID INT,
	SalaryID INT,
    ShiftTypeID INT,
    StartDate DATE not null,
    constraint pk_workers PRIMARY KEY(WorkerID),
    foreign key (CityID) references Cities(CityID),
    foreign key (DepartmentID) references Departments(DepartmentID),
    foreign key (RoleID) references Roles(RoleID),
    foreign key (SalaryID) references Salaries(SalaryID),
    foreign key (ShiftTypeID) references ShiftTypes(ShiftTypeID)

)

----החלטתי שאני רוצה להוסיף שדה תז, הוספתי אותו
---- בהתחלה כנאלל כי חייב ואז אחרי שהוספתי לכוטלם, שניתי לנט נאלל.
alter table Workers
add IDNumber int 
update Workers
set IDNumber = 
    CASE WorkerID
        WHEN 4 THEN 123456789
        WHEN 5 THEN 987654321
        WHEN 6 THEN 112233445
        WHEN 7 THEN 556677889
        WHEN 8 THEN 998877665
        WHEN 9 THEN 334455667
        WHEN 10 THEN 776655443
        WHEN 11 THEN 223344556
    end;
	alter table Workers
alter column IDNumber int not null

create table Attendance (
    AttendanceID INT IDENTITY(1,1) not null,
    WorkerID INT,
    Date DATE not null,
    CheckInTime TIME not null,
    CheckOutTime TIME not null,
    constraint pk_attendance PRIMARY KEY(AttendanceID),
    foreign key (WorkerID) references Workers(WorkerID)
)
create table Departments (
    DepartmentID INT IDENTITY(1,1) not null,
    DepartmentName VARCHAR(50) not null,
    DepartmentFloor INT not null,
    constraint pk_departments PRIMARY KEY(DepartmentID)
)
create table ShiftTypes (
    ShiftTypeID INT IDENTITY(1,1) not null,
    ShiftTypeName VARCHAR(50) not null,
    constraint pk_shifttypes PRIMARY KEY(ShiftTypeID)
)

create table Roles (
    RoleID INT IDENTITY(1,1) not null,
    RoleName VARCHAR(50) not null,
    constraint pk_roles PRIMARY KEY(RoleID)
)

create table Salaries (
    SalaryID INT IDENTITY(1,1) not null,
    HourlyRate int not null,
    constraint pk_salaries PRIMARY KEY(SalaryID)
)

create table Cities (
    CityID INT IDENTITY(1,1) not null,
    CityName VARCHAR(100) not null,
    constraint pk_cities PRIMARY KEY(CityID)
)

create table Projects (
    ProjectID INT IDENTITY(1,1) not null,
    ProjectName VARCHAR(100) not null,  -- שם הפרויקט
    StartDate DATE not null,
    EndDate DATE,
    WorkerID INT, -- עובד אחראי לפרויקט
    Status VARCHAR(50), -- סטטוס הפרויקט: לדוג' "בביצוע", "הושלם"
    Budget INT, -- תקציב הפרויקט (אם רלוונטי)
    constraint pk_projects PRIMARY KEY(ProjectID),
    foreign key (WorkerID) references Workers(WorkerID)
)



insert into Cities (CityName)
values ('ירושלים'),
('בית שמש'),
('מודיעין'),
('תל אביב'),
('ביתר')
insert into Salaries (HourlyRate)
values 
(30),  
(40),  
(50),  
(70),
(80)
insert into Roles (RoleName)
values 

('מזכירה'),     
('מנהל אגף'), 
('עובד סוציאלי'),    
('מנהל משאבי אנוש'), 
('מהנדס עירוני'),   
('מנהל פרויקטים'),  
('מתכנת עירוני'),   
('קב"ט עירוני'),
('מפקחת')
select * from Roles
select * from Projects



insert into Projects (ProjectName, StartDate, EndDate, WorkerID, Status, Budget)
values
('פיתוח מערכת ניהול עירייה', '2023-01-01', null, 5, 'בביצוע', 100000),
('שדרוג תשתיות חשמל', '2023-02-01', null, 8, 'בביצוע', 50000),
('שירותי רווחה לקשישים', '2023-03-01', '2023-08-15', 9, 'הושלם', 25000),
('תכנון וביצוע פרויקט תחבורה ציבורית', '2023-04-01',null, 5, 'בביצוע', 120000),
('תכנית חינוך חדשנית', '2023-05-01', '2023-10-31', 6, 'הושלם', 30000);

insert into Departments (DepartmentName, DepartmentFloor)
values 
('חינוך', 2),     
('תשתיות', 3),     
('רווחה', 1),        
('משאבי אנוש', 4),  
('תכנון עירוני', 5), 
('בטחון', 6),        
('תחבורה', 2),     
('בריאות', 7)
select * from Departments
insert into ShiftTypes (ShiftTypeName)
VALUES 
('בוקר'),   
('צהריים'), 
('לילה') 

select * from Departments
select * from Roles
select * from Cities
select * from Salaries
select * from Workers


insert into Attendance (WorkerID, Date, CheckInTime, CheckOutTime)
values 
 
(4, '2024-02-15', '08:00', '16:00'), -- מיכל כהן
(5, '2024-02-15', '16:00', '00:00'), -- ישראל לוי
(6, '2024-02-15', '00:00', '08:00'), -- דניאל מזרחי
(7, '2024-02-14', '08:00', '16:00'), -- רבקה שמש
(8, '2024-02-14', '08:00', '16:00'), -- יוסי רוזן
(9, '2024-02-13', '08:00', '16:00'), -- מרים פישר
(10, '2024-02-13', '16:00', '00:00'), -- אהרון גולן
(11, '2024-02-12', '00:00', '08:00')

insert into Workers (FirstName, LastName,IDNumber, CityID, DepartmentID, RoleID, SalaryID, ShiftTypeID, StartDate)
values 
('מיכל', 'כהן',123456789, 5, 2, 1, 3, 1, '2020-01-01'),
('ישראל', 'לוי',987654321, 2, 2,6, 2, 2, '2019-04-15'),
('דניאל', 'מזרחי',112233445, 3, 3, 3, 3, 3, '2021-06-20'),
('רבקה', 'שמש',556677889, 4, 4, 4, 4, 1, '2020-08-10'),
('יוסי', 'רוזן',998877665, 1, 5, 5, 5, 2, '2022-02-25'),
('מרים', 'פישר',334455667, 1, 3, 3, 2, 1, '2018-11-30'),
('אהרון', 'גולן',776655443, 2, 6, 8, 2, 1, '2021-03-05'),
('שרי', 'ברק',223344556, 3, 3, 7, 4, 1, '2019-09-11');

insert into Salaries (HourlyRate)
values (75), (80), (100), (120), (130), (140), (150);


SELECT * FROM Salaries;

 
select * from Departments
select * from Roles
select * from Cities
select * from Salaries
SELECT * FROM Workers

SELECT * FROM Attendance

