

select * from Salaries
select * from Departments
select * from Roles
select * from Cities
select * from Salaries
select * from Workers
select * from Attendance
select * from Workers w
left join Roles r on w.RoleID=r.RoleID join Departments d on d.DepartmentID=w.DepartmentID
left join Attendance a on a.WorkerID=w.WorkerID



---1
  --פרוצדורה  המשנה את התפקיד של עובד מסויים ע"י שימוש בסאב סלקט
alter procedure changeRole
@idNumber int,
@newRoleName varchar (30),
@newDepartment varchar(30)
as begin
    update Workers
    set RoleID = (select RoleID from roles where RoleName=@newRoleName ),
	DepartmentID=(select DepartmentID from Departments where DepartmentName=@newDepartment )
	where IDNumber=@idNumber
	 print 'העובד הועבר בהצלחה למשרה חדשה במחלקה חדשה'
end
go

exec changeRole
@idNumber='556677889' ,
@newRoleName='עובד סוציאלי',
@newDepartment='רווחה'

---בדיקה שאכן השתנה עי שימוש בVIEW
select * from allDetails
select * from Roles



SELECT * FROM Workers w
join Roles r on w.RoleID=r.RoleID
join Departments d on w.DepartmentID=d.DepartmentID




-----2
-----פונקציה שבודקת כמה עובדים יש לכל תפקיד
---עם שימוש בגרופ ביי, פונקציה אגרגטיבית
create function numWorkers()
returns table
as return 
(
select r.RoleName,count(w.WorkerID) as numWorkers  from Roles r
left join  Workers w on w.RoleID=r.RoleID
group by r.RoleName
)
select * from dbo.numWorkers()



-----5
----סלקט מתוך טבלה שמשתמשת בפונקציה,
----שימוש בטבלת cte
----הסלקט משתמש בפונקציה 
----שמחזירה כמה עובדים עובדים בכל תפקיד
----ומציג להם גם באיזה אגף הם נמצאים ובאיזה קומה
;with cte as(
select * from dbo.numWorkers()
)
select distinct d.DepartmentName,d.DepartmentFloor, c.* from cte c
left join Roles r on c.RoleName=r.RoleName
left join Workers w on r.RoleID=w.RoleID
left join Departments d on w.DepartmentID=d.DepartmentID


---3a
--פונקציה שמקבלת  תז עובד,ותאריך .היא עושה פעולת חישוב של סכום שעות  
--והיא מחזירה כמה שעות עבד בתאריך שהוכנס
go
create function dbo.FN_numHours (@IDNumber bigint, @date date)
returns int
as
begin
declare @num int= ( select datediff(minute, CheckInTime, CheckOutTime) / 60.0 as NumHours
from Attendance a
join Workers w on w.WorkerID=a.WorkerID
where IDNumber=@IDNumber and date=@date
)
    
    return(@num)
end


select dbo.FN_numHours(123456789,'2024-02-15')




----3b
--פרוצדורה שתקבל מספר ת"ז ותאריך, תחשב כמה שעות העובד עבד באותו יום  
--באמצעות הפונקציה ) ותעדכן לפי שכר שעתי שלו מתוך)
--טבלת Salaries.
----עי לולאת WHILE 
--!!!כי היה צריך דווקא שימוש בלולאת WHILE בפרויקט הזה..
--שמוסיפה על כל שעה את הסכום השעתי.
--ומדפיסה את הסכום ש"הרויח" ביום זה או שלא עבד
----הוספתי טריי וקצ בשליפה של הפרוצדורה
--- כדי שאם יכניסו משהו לא טוב- הוא לא יתן

alter procedure checkSalaryDay 
   @date date,
    @ID_Number varchar(20)
as
begin

declare @num int=(select dbo.FN_numHours(@ID_Number,@date))
declare @sum int
declare  @c int

if @num>0
begin
set @sum=0
set @c=0
while(@c<@num)
begin
set @sum+=(select s.HourlyRate from Workers w
join Salaries s on w.SalaryID=s.SalaryID and w.IDNumber=@ID_Number)
set @c=@c+1
end

print @sum
end
else 
begin
select 'העובד לא עבד ביום זה'
end

end


exec checkSalaryDay 

    @ID_Number=987654321,
	@date='2025-02-15'
	
	----שליפה עם טריי וקצ
begin try
exec checkSalaryDay 
    @ID_Number=123456789,
	@date='-02-15'
end try
begin catch
select 'ארעה שגיאה'
end catch
	----שליפה עם טריי וקצ
begin try
exec checkSalaryDay 
    
	@date='15-02-15'
end try
begin catch
select 'ארעה שגיאה'
end catch
	
	 
	 -------בדיקה שהפרוצדורה עובדת נכון..
	select * from Workers w
	join Attendance a on w.WorkerID=a.WorkerID
	where IDNumber= 987654321
	 
----4a
--פרוצדורה שמקבלת עובד ומחזירה אם הוא קיים ואם לא היא מכניסה
alter procedure checkWorker 
    @first_name varchar(20),
	@last_name varchar(20),
    @ID_Number varchar(20),
	@WorkerID int output
as
begin
   if not exists (select * from Workers where FirstName=@first_name and IDNumber=@ID_Number)
   begin
   insert into Workers (FirstName,LastName,CityID,DepartmentID,RoleID,SalaryID,ShiftTypeID,StartDate,IDNumber)
   values(@First_name,@last_name,null,null,null,null,null,getdate(),@ID_Number)
   select @WorkerID = SCOPE_IDENTITY()
print 'העובד הוכנס למערכת בהצלחה'
end 
else
begin
select @WorkerID = WorkerID from Workers where IDNumber = @ID_Number
print'העובד כבר קיים במערכת'
end
end

declare @WorkerID int;  -- להגדיר את המשתנה לפני השימוש
exec checkWorker
@first_name='יעקב',
	@last_name='שיף',
    @ID_Number=023090765,
	    @WorkerID = @WorkerID output

---4b
-----פרוצדורה שמקבלת פרטי עובד, בודקת אם הוא קיים ואז מכניסה לו שעת כניסה או יציאה
---משתמשת ב if, else
alter procedure updateHours 
    @first_name1 VARCHAR(20),
	@last_name1 VARCHAR(20),
    @ID_Number1 VARCHAR(20)
as
begin
declare @WorkerID int
   exec checkWorker
@first_name=@first_name1,
	@last_name=@last_name1,
    @ID_Number= @ID_Number1,
	@WorkerID = @WorkerID output

    begin try


	if 
	not exists(select CheckInTime from Attendance a
	where a.WorkerID=@WorkerID and a.Date=convert(date,GETDATE()))

	begin
	insert into Attendance  (WorkerID,Date,CheckInTime) values(@WorkerID,convert(date,GETDATE()),convert(time,GETDATE()))
	print'ברוך הבא/ה'
	end
	else 
	begin
	update Attendance 
	set CheckOutTime=convert(time,GETDATE())
	where WorkerID = @WorkerID and Date = convert(date, GETDATE())  
	print'להתראות!'
	end
end

exec updateHours 
    @first_name1='תמר',
	@last_name1='לביא',
    @ID_Number1 ='215554343'

	exec updateHours 
	@first_name1='שני',
	@last_name1='דוד',
    @ID_Number1='0234345655'

	----הייתי צריכה לעדכן את זה כדי שיהיה אופציה להכניס רק שעת כניסה
	alter table Attendance 
alter column CheckOutTime time null




-----6
-----view
---מציג לי את כל פרטי הלקוחות הקיימים בלי מספרים של איידי וכו,
---הוא מציג לי בעצם מציג פרטים סופיים ומתומצטים לכל עובד
---בנוסף הוא מציג אם הוא קשור לפרוייקט או לא.

create view allDetails as
select w.FirstName,w.LastName,w.IDNumber,
c.CityName,r.RoleName,d.DepartmentName,s.HourlyRate,
case when p. ProjectName is  null then 'לא קשור לפרוייקט!'  else p.ProjectName  end as projects
from [dbo].[Workers] w
left join Cities c on w.CityID=c.CityID
left join [Roles] r on w.RoleID=r.RoleID
left join [Departments] d on w.DepartmentID=d.DepartmentID
left join [Salaries] s on w.SalaryID=s.SalaryID
left join [Projects] p on p.WorkerID=w.WorkerID

select * from allDetails


----7
------טריגר לעדכון סטטוס פרויקט  ר
--כאשר סטטוס של פרויקט משתנה  מ-"בביצוע" ל-"הושלם", נוודא אם יש פעילות שקשורה
----לו (כגון שעות עבודה או עדכונים), ונשתמש ב-TRY...CATCH כדי להתמודד עם כל בעיה.

alter trigger trg_checkProjectStatus
on Projects
after update
AS
begin
        declare @beforeStatus varchar(50), @newStatus varchar(50);
		set @beforeStatus=( select Status from deleted)
		set @newStatus=(select Status from inserted)
		if(@beforeStatus='בביצוע') and @newStatus='הושלם'
		begin
		print 'הפרוייקט הסתיים בהצלחה!'
		
		end
    end try
    begin catch
	

        print 'שגיאה בעדכון סטטוס פרויקט'
    end catch
end
update Projects
set Status = 'בביצוע'
where ProjectID = 3;

select * from [dbo].[Projects]


---7
---------טריגר שמשתמש בטרנזקציה
---כדי לא לתת אופציה שפרויקט שהסתיים כבר יחזור להיות בסטטוס בביצוע
--------------newwwwww
alter trigger trg_checkProjectStatus
on Projects
after update
as
begin
     -----לא צריך לעשות 
	 ---begin tranzaction
	 ----כי זה כבר בתוך טריגר.

        declare @beforeStatus varchar(50), @newStatus varchar(50)
		set @beforeStatus=( select Status from deleted)
		set @newStatus=(select Status from inserted)
		
		if(@beforeStatus='בביצוע') and @newStatus='הושלם'
		begin
		 -----עדכון תאריך סיום פרוייקט
		 update Projects
        set EndDate = convert(date, getdate())
        where ProjectID in (select ProjectID from inserted)

		print 'הפרוייקט הסתיים בהצלחה!'

--commit transaction
		end
 
 else 
    begin 
	rollback-- transaction

        print 'שגיאה בעדכון סטטוס פרויקט'
    end 
end
update Projects
set Status = 'בביצוע'
where ProjectID = 7

select * from [dbo].[Projects] p
join Workers w on p.WorkerID=w.WorkerID




drop trigger trg_checkProjectStatus

------יוניון
---מציג לי לייד כל עובד אם הוא משובץ בפרוייקט או לא
select FirstName,LastName, 'משובץ בפרוייקט' as status  from Workers w
join Projects p on p.WorkerID=w.WorkerID
union
select FirstName,LastName, 'לא משובץ בפרוייקט' as status  from Workers w
left join Projects p on p.WorkerID=w.WorkerID
where p.WorkerID is null

-----שימוש בorder by, top1
--שליפת העובד שהתחיל לעבוד אחרון בעירייה
--יש צורך בסאב סלקט, 
--כדי להתייחס גם למקרה שבו כמה עובדים נכנסו באותו יום.
select * from Workers where StartDate=(
select  top 1  StartDate from Workers
order by StartDate desc)


select * from Workers


------שליפת העובד הכי ותיק מכל מחלקה עי שימוש ב
------- cross apply, row number
-----לעובדים בכל מחלקה.
-----בלי סאב סלקט
----תיקון 
select d.DepartmentName, w.WorkerID, w.FirstName, w.LastName, w.StartDate
from Departments d
cross apply (
    select 
    WorkerID,  FirstName, LastName, StartDate, DepartmentID,
    row_number() over (partition by DepartmentID order by StartDate asc) as rn
    from Workers w
    where w.DepartmentID = d.DepartmentID
) w
where w.rn = 1

		-----בדיקה באילו אגפים אין עובדים
		select * from Workers w
		full join Departments d on d.DepartmentID=w.DepartmentID where w.WorkerID is null 



		-----outer apply
		----שליפה המציגה לכל עובד את המשמרת האחרונה שלו
		----כולל עובדים שאין להם משמרות!!
		select w.FirstName, w.LastName, a.Date, a.CheckInTime, a.CheckOutTime from Workers w
		cross apply(
		select top 1 a.Date, a.CheckInTime, a.CheckOutTime from  Attendance a
		where a.WorkerID=w.WorkerID
		order by a.Date desc
		)a
		select * from Attendance



		-----------------sql dynamic
		---עשיתי שליפה ששולפת בטבלה אחת את כל השדות 
		--select כל השדות
		----from
		---כל טבלה בנפרד
		select 'select'+' '+'(' +STRING_AGG(c.name,', ')+')'+' '+'from '+t.name from sys.tables t
		join sys.columns c on t.object_id=c.object_id
		group by t.name


		select c.object_id,t.object_id from sys.tables t
		join sys.columns c on t.object_id=c.object_id
		group by t.name

		select * from sys.tables
		select object_id from sys.columns



select * from [dbo].[Attendance]
select * from [dbo].[Projects]
select * from [dbo].[Departments]
select * from [dbo].[Cities]
select * from [dbo].[Roles]
select * from [dbo].[Salaries]
select * from [dbo].[ShiftTypes]







 
   