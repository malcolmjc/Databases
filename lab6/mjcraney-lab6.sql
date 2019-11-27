-- Lab 6
-- mjcraney
-- Nov 27, 2019

USE `BAKERY`;
-- BAKERY-1
-- Find all customers who did not make a purchase between October 5 and October 11 (inclusive) of 2007. Output first and last name in alphabetical order by last name.
select FirstName,LastName from (
    select distinct Customer from receipts 
    where Customer not in (
        select distinct Customer from receipts
        where (SaleDate >= '2007-10-05' and SaleDate <= '2007-10-11')
        order by Customer
    )
) t1
join customers on CId = Customer
order by LastName
;


USE `BAKERY`;
-- BAKERY-2
-- Find the customer(s) who spent the most money at the bakery during October of 2007. Report first, last name and total amount spent (rounded to two decimal places). Sort by last name.
with CustomerSpending as (
    select Customer,FirstName,LastName,SUM(PRICE) as Spent from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    join customers on Customer = CId
    where SaleDate >= '2007-10-01' and SaleDate <= '2007-10-31'
    group by Customer
)
select FirstName,LastName,Round(Spent,2) from CustomerSpending
where Spent = (
    select MAX(Spent) from CustomerSpending
)
;


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who never purchased a twist ('Twist') during October 2007. Report first and last name in alphabetical order by last name.

with FullTable as (
    select * from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    join customers on Customer = CId
    where SaleDate >= '2007-10-01' and SaleDate <= '2007-10-31'
)
select distinct FirstName,LastName from FullTable
where Customer not in (
    select distinct Customer from FullTable
    where Food = 'Twist'
)
order by LastName
;


USE `BAKERY`;
-- BAKERY-4
-- Find the type of baked good (food type & flavor) responsible for the most total revenue.
with GoodRevenue as (
    select Food,Flavor,SUM(PRICE) as Revenue from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    group by Food,Flavor
)
select Flavor,Food from GoodRevenue
where Revenue = (
    select MAX(Revenue) from GoodRevenue
)
;


USE `BAKERY`;
-- BAKERY-5
-- Find the most popular item, based on number of pastries sold. Report the item (food, flavor) and total quantity sold.
with GoodsSold as (
    select Food,Flavor,Count(*) as Sold from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    group by Food,Flavor
)
select Flavor,Food,Sold from GoodsSold
where Sold = (
    select MAX(Sold) from GoodsSold
)
;


USE `BAKERY`;
-- BAKERY-6
-- Find the date of highest revenue during the month of October, 2007.
with DayRevenue as (
    select SaleDate,SUM(PRICE) as Revenue from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    where SaleDate >= '2007-10-01' and SaleDate <= '2007-10-31'
    group by SaleDate
)
select SaleDate from DayRevenue
where Revenue = (
    select MAX(Revenue) from DayRevenue
)
;


USE `BAKERY`;
-- BAKERY-7
-- Find the best-selling item (by number of purchases) on the day of the highest revenue in October of 2007.
with DayRevenue as (
    select SaleDate,SUM(PRICE) as Revenue from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    where SaleDate >= '2007-10-01' and SaleDate <= '2007-10-31'
    group by SaleDate
),
GoodsSold as (
    select SaleDate,Food,Flavor,Count(*) as Sold from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    group by Food,Flavor,SaleDate
),
GoodsSoldMaxDay as (
    select Food,Flavor,Sold from GoodsSold 
    where SaleDate = (
        select SaleDate from DayRevenue
        where Revenue = (
            select MAX(Revenue) from DayRevenue
        )
    )
)
select Flavor,Food,Sold from GoodsSoldMaxDay
where Sold = (
    select MAX(Sold) from GoodsSoldMaxDay
)
;


USE `BAKERY`;
-- BAKERY-8
-- For every type of Cake report the customer(s) who purchased it the largest number of times during the month of October 2007. Report the name of the pastry (flavor, food type), the name of the customer (first, last), and the number of purchases made. Sort output in descending order on the number of purchases, then in alphabetical order by last name of the customer, then by flavor.
with CakesPerCustomer as (
    select Customer,FirstName,LastName,Flavor,Food,Count(*) as qty from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    join customers on Customer = CId
    where 
    SaleDate >= '2007-10-01' 
    and SaleDate <= '2007-10-31'
    and Food = 'Cake'
    group by Customer,Flavor,Food
)
select Flavor,Food,FirstName,LastName,qty from CakesPerCustomer c1
where qty = (
    select MAX(qty) from CakesPerCustomer c2
    where c2.Flavor = c1.Flavor
)
order by qty DESC,LastName,Flavor
;


USE `BAKERY`;
-- BAKERY-9
-- Output the names of all customers who made multiple purchases (more than one receipt) on the latest day in October on which they made a purchase. Report names (first, last) of the customers and the earliest day in October on which they made a purchase, sorted in chronological order.

with LastPurchaseDay as (
    select MAX(SaleDate) as LastSale,Customer as C,FirstName,LastName from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    join customers on Customer = CId
    group by Customer
),
FirstPurchaseDay as (
    select Min(SaleDate) as FirstSale,Customer as C2 from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    join customers on Customer = CId
    group by Customer
)
select LastName,FirstName,FirstSale from  receipts
join LastPurchaseDay on C = Customer and LastSale = SaleDate
join FirstPurchaseDay on C2 = Customer
group by Customer
having Count(RNumber) > 1
order by FirstSale,LastName
;


USE `BAKERY`;
-- BAKERY-10
-- Find out if sales (in terms of revenue) of Chocolate-flavored items or sales of Croissants (of all flavors) were higher in October of 2007. Output the word 'Chocolate' if sales of Chocolate-flavored items had higher revenue, or the word 'Croissant' if sales of Croissants brought in more revenue.

with CroissantRevenue as (
    select SUM(PRICE) as Crois from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    where Food = 'Croissant'
),
ChocolateRevenue as (
    select SUM(PRICE) as Choc,Flavor from receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    where Flavor = 'Chocolate'
)
select  
Case WHEN Choc > Crois 
Then
'Chocolate'
Else
'Croissant'
END
from ChocolateRevenue join CroissantRevenue
;


USE `INN`;
-- INN-1
-- Find the most popular room (based on the number of reservations) in the hotel  (Note: if there is a tie for the most popular room status, report all such rooms). Report the full name of the room, the room code and the number of reservations.

with RoomReservations as (
    select Room,RoomName,Count(CODE) as ResCount from reservations
    join rooms on Room = RoomCode
    group by Room
)
select RoomName,Room,ResCount from RoomReservations
where ResCount = (
    select MAX(ResCount) from RoomReservations
)
;


USE `INN`;
-- INN-2
-- Find the room(s) that have been occupied the largest number of days based on all reservations in the database. Report the room name(s), room code(s) and the number of days occupied. Sort by room name.
with RoomReservations as (
    select Room,RoomName,DateDiff(Checkout,CheckIn) as ResCount from reservations
    join rooms on Room = RoomCode
    group by Room,CheckIn,CheckOut
),
DaysOccupied as (
    select Room,RoomName,SUM(ResCount) as Total from RoomReservations
    group by Room
)
select RoomName,Room,Total from DaysOccupied
where Total = (
    select MAX(Total) from DaysOccupied
)
;


USE `INN`;
-- INN-3
-- For each room, report the most expensive reservation. Report the full room name, dates of stay, last name of the person who made the reservation, daily rate and the total amount paid. Sort the output in descending order by total amount paid.
with RoomReservations as (
    select CODE,CheckIn,Checkout,LastName,Rate,Room,RoomName,DateDiff(Checkout,CheckIn) * Rate as Cost from reservations
    join rooms on Room = RoomCode
    group by CODE
),
CostsPerRes as (
    select CODE,RoomName,Room,MAX(Cost) as MaxCost from RoomReservations
    group by CODE
)
select RoomName,CheckIn,Checkout,LastName,Rate,Cost from RoomReservations r1
where Cost = (
    select MAX(Cost) from RoomReservations r2
    where r1.Room = r2.Room
)
order by Cost DESC
;


USE `INN`;
-- INN-4
-- For each room, report whether it is occupied or unoccupied on July 4, 2010. Report the full name of the room, the room code, and either 'Occupied' or 'Empty' depending on whether the room is occupied on that day. (the room is occupied if there is someone staying the night of July 4, 2010. It is NOT occupied if there is a checkout on this day, but no checkin). Output in alphabetical order by room code. 
with RoomOccupations as (
    select RoomName,Room,
    Case WHEN (CheckIn <= '2010-07-04' and Checkout > '2010-07-04')
    Then
        'Occupied'
    Else
        'Empty'
    END
    as Occupied
    from reservations
    join rooms on Room = RoomCode
),
TotalOccupancy as (
    select RoomName,Room,Count(*) as C1
    from RoomOccupations
    group by Room
),
Unoccupied as (
    select RoomName,Room,Count(*) as C2 from RoomOccupations
    where Occupied <> 'Occupied'
    group by Room
)
select TotalOccupancy.RoomName,TotalOccupancy.Room,
Case 
WHEN C1 <> C2
Then
    'Occupied'
Else
    'Empty'
END
from Unoccupied join TotalOccupancy
on TotalOccupancy.Room = Unoccupied.Room
order by Room
;


USE `INN`;
-- INN-5
-- Find the highest-grossing month (or months, in case of a tie). Report the month, the total number of reservations and the revenue. For the purposes of the query, count the entire revenue of a stay that commenced in one month and ended in another towards the earlier month. (e.g., a September 29 - October 3 stay is counted as September stay for the purpose of revenue computation). In case of a tie, months should be sorted in chronological order.
with ReservationCosts as (
    select CheckIn,CheckOut,DateDiff(CheckOut,Checkin) * Rate as Price from reservations
),
MonthlyCosts as (
    select Month(CheckIn) as Month,SUM(Price) as MonthlyCost,Count(*) as NumReservations from ReservationCosts
    group by Month(CheckIn)
)
select MONTHNAME(STR_TO_DATE(Month, '%m')),NumReservations,MonthlyCost from MonthlyCosts
where MonthlyCost = (
    select MAX(MonthlyCost) from MonthlyCosts
)
order by Month
;


USE `STUDENTS`;
-- STUDENTS-1
-- Find the teacher(s) who teach(es) the largest number of students. Report the name of the teacher(s) (first and last) and the number of students in their class.

with StudentsTaught as (
    select teachers.Last,teachers.First,Count(*) as Students from teachers
    join list on teachers.classroom = list.classroom
    group by teachers.Last,teachers.First
)
select * from StudentsTaught
where Students = (
    select MAX(Students) from StudentsTaught
)
;


USE `STUDENTS`;
-- STUDENTS-2
-- Find the grade(s) with the largest number of students whose last names start with letters 'A', 'B' or 'C' Report the grade and the number of students
with StudentsTaught as (
    select grade,Count(*) as Students from teachers
    join list on teachers.classroom = list.classroom
    where LastName like "A%" or LastName like "B%" or LastName like "C%"
    group by grade
)
select * from StudentsTaught
where Students = (
    select MAX(Students) from StudentsTaught
)
;


USE `STUDENTS`;
-- STUDENTS-3
-- Find all classrooms which have fewer students in them than the average number of students in a classroom in the school. Report the classroom numbers in ascending order. Report the number of student in each classroom.
with StudentsPerClassroom as (
    select teachers.classroom,Count(*) as Students from teachers
    join list on teachers.classroom = list.classroom
    group by teachers.classroom
)
select * from StudentsPerClassroom 
where Students < (
    select Avg(Students) from StudentsPerClassroom
)
;


USE `STUDENTS`;
-- STUDENTS-4
--  Find all pairs of classrooms with the same number of students in them. Report each pair only once. Report both classrooms and the number of students. Sort output in ascending order by the number of students in the classroom.
with StudentsPerClassroom as (
    select teachers.classroom,Count(*) as Students from teachers
    join list on teachers.classroom = list.classroom
    group by teachers.classroom
),
SameClassrooms as (
    select s1.classroom as c1,s2.classroom as c2,s1.Students from StudentsPerClassroom s1
    join StudentsPerClassroom s2
    on s1.classroom < s2.classroom
    and s1.Students = s2.Students
    order by s1.Students
)
select * from SameClassrooms
;


USE `STUDENTS`;
-- STUDENTS-5
-- For each grade with more than one classroom, report the last name of the teacher who teachers the classroom with the largest number of students in the grade. Output results in ascending order by grade.
with Classes as (
    select grade,COUNT(distinct teachers.classroom) as NumClassrooms from teachers
    join list on teachers.classroom = list.classroom
    group by grade
),
StudentsTaught as (
    select grade,teachers.Last,teachers.First,Count(*) as Students from teachers
    join list on teachers.classroom = list.classroom
    group by teachers.Last,teachers.First,grade
),
MoreThanOneRoom as (
    select * from StudentsTaught
    where grade in (
        select grade from Classes
        where NumClassrooms > 1
    )
)
select grade,Last from MoreThanOneRoom m1
where Students = (
    select MAX(Students) from MoreThanOneRoom m2
    where m2.grade = m1.grade
)
order by grade
;


USE `CSU`;
-- CSU-1
-- Find the campus with the largest enrollment in 2000. Output the name of the campus and the enrollment.

select Campus,Enrolled from enrollments
join campuses on Id = CampusId
where enrollments.year = 2000
and Enrolled = (
    select MAX(Enrolled) from enrollments
    where Year = 2000
)
;


USE `CSU`;
-- CSU-2
-- Find the university that granted the highest average number of degrees per year over its entire recorded history. Report the name of the university.

with DegreesGranted as (
    select CampusId,Campus,SUM(degrees) as Granted from degrees
    join campuses on Id = CampusId
    group by CampusId
)
select Campus from DegreesGranted
where Granted = (
    select MAX(Granted) from DegreesGranted
)
;


USE `CSU`;
-- CSU-3
-- Find the university with the lowest student-to-faculty ratio in 2003. Report the name of the campus and the student-to-faculty ratio, rounded to one decimal place. Use FTE numbers for enrollment.
with Enrollments2003 as (
    select Campus,enrollments.FTE / faculty.FTE as Ratio from campuses
    join faculty on faculty.CampusId = Id
    join enrollments on enrollments.CampusId = Id
    and faculty.Year = enrollments.Year
    where enrollments.Year = 2003
)
select Campus,Round(Ratio,1) from Enrollments2003
where Ratio = (
    select MIN(Ratio) from Enrollments2003
)
;


USE `CSU`;
-- CSU-4
-- Find the university with the largest percentage of the undergraduate student body in the discipline 'Computer and Info. Sciences' in 2004. Output the name of the campus and the percent of these undergraduate students on campus.
with CompSciEnr as (
    select Campus,
    discEnr.Ug / enrollments.Enrolled as Ratio 
    from campuses 
    join discEnr on campuses.Id = discEnr.CampusId
    join enrollments on campuses.Id = enrollments.CampusId
    join disciplines on disciplines.Id = Discipline
    where discEnr.Year = 2004
    and enrollments.Year = 2004
    and Name = 'Computer and Info. Sciences'
)
select Campus,ROUND(Ratio*100,1) from CompSciEnr
where Ratio = (
    select MAX(Ratio) from CompSciEnr
)
;


USE `CSU`;
-- CSU-5
-- For each year between 1997 and 2003 (inclusive) find the university with the highest ratio of total degrees granted to total enrollment (use enrollment numbers). Report the years, the names of the campuses and the ratios. List in chronological order.
with DegreesPerEnrolled as (
    select enrollments.Year,Campus,degrees/Enrolled as DPE from degrees
    join campuses on degrees.CampusId = Id
    join enrollments on enrollments.CampusId = Id
    and degrees.year = enrollments.year
    where degrees.year >= 1997 and degrees.year <= 2003
    and enrollments.year >= 1997 and enrollments.year <= 2003
)
select * from DegreesPerEnrolled d1
where DPE = (
    select MAX(DPE) from DegreesPerEnrolled d2
    where d2.Year = d1.Year
)
order by Year
;


USE `CSU`;
-- CSU-6
-- For each campus report the year of the best student-to-faculty ratio, together with the ratio itself. Sort output in alphabetical order by campus name. Use FTE numbers to compute ratios.
with EnrollmentsPerYear as (
    select Campus,enrollments.Year,
    MAX(enrollments.FTE / faculty.FTE) as Ratio from campuses
    join faculty on faculty.CampusId = Id
    join enrollments on enrollments.CampusId = Id
    and faculty.Year = enrollments.Year
    group by enrollments.Year,Campus
)
select Campus,Year,ROUND(Ratio,2) from EnrollmentsPerYear e1
where Ratio = (
    select MAX(Ratio) from EnrollmentsPerYear e2
    where e2.Campus = e1.Campus
)
order by Campus
;


USE `CSU`;
-- CSU-7
-- For each year (for which the data is available) report the total number of campuses in which student-to-faculty ratio became worse (i.e. more students per faculty) as compared to the previous year. Report in chronological order.

with EnrollmentsPerYear as (
    select Campus,enrollments.Year,
    MAX(enrollments.FTE / faculty.FTE) as Ratio from campuses
    join faculty on faculty.CampusId = Id
    join enrollments on enrollments.CampusId = Id
    and faculty.Year = enrollments.Year
    group by enrollments.Year,Campus
)
select Year+1,Count(*) from EnrollmentsPerYear e1
where Ratio < (
    select MAX(Ratio) from EnrollmentsPerYear e2
    where e1.Campus = e2.Campus
    and e2.Year = e1.Year + 1
)
group by Year
order by Year
;


USE `MARATHON`;
-- MARATHON-1
-- Find the state(s) with the largest number of participants. List state code(s) sorted alphabetically.

with Participants as (
    select State,Count(*) as Num from marathon
    group by State
)
select State from Participants
where Num = (
    select MAX(Num) from Participants
)
order by State
;


USE `MARATHON`;
-- MARATHON-2
--  Find all towns in Rhode Island (RI) which fielded more female runners than male runners for the race. Report the names of towns, sorted alphabetically.

with TownFemales as (
    select Town,Count(*) as Females from marathon
    where State = 'RI' and Sex = 'F'
    group by Town
),
TownMales as (
    select Town,Count(*) as Males from marathon
    where State = 'RI' and Sex = 'M'
    group by Town
)
select TownFemales.Town from
TownFemales join TownMales
on TownFemales.Town = TownMales.Town
where Females > Males
order by TownFemales.Town
;


USE `MARATHON`;
-- MARATHON-3
-- For each state, report the gender-age group with the largest number of participants. Output state, age group, gender, and the number of runners in the group. Report only information for the states where the largest number of participants in a gender-age group is greater than one. Sort in ascending order by state code, age group, then gender.
with ParticipantsPerGroup as (
    select State,Sex,AgeGroup,Count(*) as Participants from marathon
    group by State,Sex,AgeGroup
)
select State,AgeGroup,Sex,Participants from ParticipantsPerGroup p1
where Participants = (
    select MAX(Participants) from ParticipantsPerGroup p2
    where p1.State = p2.State
)
and Participants > 1
order by State,AgeGroup,Sex
;


USE `MARATHON`;
-- MARATHON-4
-- Find the 30th fastest female runner. Report her overall place in the race, first name, and last name. This must be done using a single SQL query (which may be nested) that DOES NOT use the LIMIT clause. Think carefully about what it means for a row to represent the 30th fastest (female) runner.
select Place,FirstName,LastName from marathon m1
where sex = 'F'
and (
    select Count(*) from marathon m2
    where sex = 'F' and m2.Place < m1.Place
) = 29
group by Place
;


USE `MARATHON`;
-- MARATHON-5
-- For each town in Connecticut report the total number of male and the total number of female runners. Both numbers shall be reported on the same line. If no runners of a given gender from the town participated in the marathon, report 0. Sort by number of total runners from each town (in descending order) then by town.

with Combined as (
    select Town,Count(*) as Participants from marathon
    where State = 'CT'
    group by Town
),
Males as (
    select Town,Count(*) as Participants from marathon
    where State = 'CT'
    and Sex = 'M'
    group by Town
)
select Combined.Town,
CASE
    when Males.Participants is NULL then 0
    else Males.Participants
END
as Men,
CASE
    when Males.Participants is NULL then Combined.Participants
    else Combined.Participants - Males.Participants
END
as Women
from Combined
left join Males on Males.Town = Combined.Town
order by Combined.Participants DESC,Town
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report the first name of the performer who never played accordion.

select Firsname from Band where Id not in (
    select distinct Bandmate from Instruments
    where Instrument = 'accordion'
)
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report, in alphabetical order, the titles of all instrumental compositions performed by Katzenjammer ("instrumental composition" means no vocals).

select Title from Songs
where SongId not in (
    select distinct Song
    from Vocals
)
order by Title
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- Report the title(s) of the song(s) that involved the largest number of different instruments played (if multiple songs, report the titles in alphabetical order).
with InstrumentsPerSong as (
    select SongId,Title,Count(Instrument) as InsCount from Songs
    join Instruments on SongId = Song
    group by Song
)
select Title from InstrumentsPerSong
where InsCount = (
    select MAX(InsCount) from InstrumentsPerSong
)
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find the favorite instrument of each performer. Report the first name of the performer, the name of the instrument and the number of songs the performer played the instrument on. Sort in alphabetical order by the first name.

with InstrumentCount as (
    select Firsname,Id,Instrument,Count(*) as TimesPlayed from Band join
    Instruments on Id = Bandmate
    group by Id,Instrument
)
select Firsname,Instrument,TimesPlayed from InstrumentCount i1
where TimesPlayed = (
    select MAX(TimesPlayed) from InstrumentCount i2
    where i1.Id = i2.id
)
order by Firsname,Instrument
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments played ONLY by Anne-Marit. Report instruments in alphabetical order.
with AnneInstruments as (
    select distinct Instrument from Band
    join Instruments on Id = Bandmate
    where Firsname = 'Anne-Marit'
)
select * from AnneInstruments
where Instrument not in (
    select distinct Instrument from Band
    join Instruments on Id = Bandmate
    where Firsname <> 'Anne-Marit'
)
order by Instrument
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Report the first name of the performer who played the largest number of different instruments. Sort in ascending order.

with InstrumentCount as (
    select Firsname,Id,Count(distinct Instrument) as NumIns from Band join
    Instruments on Id = Bandmate
    group by Id
)
select Firsname from InstrumentCount
where NumIns = (
    select MAX(NumIns) from InstrumentCount
)
order by Firsname
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Who spent the most time performing in the center of the stage (in terms of number of songs on which she was positioned there)? Return just the first name of the performer(s). Sort in ascending order.

with TimeCenters as (
    select Bandmate,Firsname,Count(*) as Centers from Performance
    join Band on Bandmate = Id
    where StagePosition = 'center'
    group by Bandmate
)
select Firsname from TimeCenters 
where Centers = (
    select MAX(Centers) from TimeCenters
)
order by Firsname
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Which instrument(s) was/were played on the largest number of songs? Report just the names of the instruments (note, you are counting number of songs on which an instrument was played, make sure to not count two different performers playing same instrument on the same song twice).
with SongsPerInstrument as (
    select Instrument,Count(distinct Song) as Songs from Instruments
    join Songs on Song = SongId
    group by Instrument
)
select Instrument from SongsPerInstrument
where Songs = (
    select MAX(Songs) from SongsPerInstrument
)
;


