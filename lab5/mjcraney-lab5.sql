-- Lab 5
-- mjcraney
-- Nov 9, 2019

USE `STUDENTS`;
-- STUDENTS-1
-- Report the names of teachers who have between seven and eight (inclusive) students in their classrooms. Sort output in alphabetical order by the teacher's last name.
select distinct teachers.last, teachers.first from teachers 
join list on teachers.classroom = list.classroom
group by teachers.last, teachers.first
having count(*) >= 7 and count(*) <= 8
order by teachers.last;


USE `STUDENTS`;
-- STUDENTS-2
-- For each grade, report the number of classrooms in which it is taught and the total number of students in the grade. Sort the output by the number of classrooms in descending order, then by grade in ascending order.

select grade, COUNT(grade), SUM(total) from
(select grade, COUNT(classroom) as total from list
group by grade, classroom) t1
group by grade
order by COUNT(grade) DESC, grade
;


USE `STUDENTS`;
-- STUDENTS-3
-- For each Kindergarten (grade 0) classroom, report the total number of students. Sort output in the descending order by the number of students.
select classroom, COUNT(classroom) as Students from list
where grade = 0
group by classroom
order by Students DESC
;


USE `STUDENTS`;
-- STUDENTS-4
-- For each fourth grade classroom, report the student (last name) who is the last (alphabetically) on the class roster. Sort output by classroom.
select classroom, MAX(lastname) as LastOnRoster from list
where grade = 4
group by classroom
order by classroom
;


USE `BAKERY`;
-- BAKERY-1
-- For each flavor which is found in more than three types of items offered at the bakery, report the average price (rounded to the nearest penny) of an item of this flavor and the total number of different items of this flavor on the menu. Sort the output in ascending order by the average price.
select Flavor,ROUND(AVG(PRICE),2) as AveragePrice,
Count(Flavor) as DifferentPastries from goods
group by Flavor
having count(*) > 3
order by AveragePrice
;


USE `BAKERY`;
-- BAKERY-2
-- Find the total amount of money the bakery earned in October 2007 from selling eclairs. Report just the amount.
select SUM(PRICE) as EclairRevenue from receipts
join items on Receipt = RNumber
join goods on Item = GId
where SaleDate >= '2007-10-01' and SaleDate <= '2007-10-31'
and Food = 'Eclair'
;


USE `BAKERY`;
-- BAKERY-3
-- For each visit by NATACHA STENZ output the receipt number, date of purchase, total number of items purchased and amount paid, rounded to the nearest penny. Sort by the amount paid, most to least.
select RNumber,SaleDate,
COUNT(SaleDate) as NumberOfItems,
ROUND(SUM(PRICE),2) as CheckAmount 
from customers
join receipts on CId = Customer
join items on Receipt = RNumber
join goods on Item = GId
where LastName = 'STENZ' AND FirstName = 'NATACHA'
group by SaleDate,RNumber
order by SUM(Price) DESC
;


USE `BAKERY`;
-- BAKERY-4
-- For each day of the week of October 8 (Monday through Sunday) report the total number of purchases (receipts), the total number of pastries purchased and the overall daily revenue. Report results in chronological order and include both the day of the week and the date.
select DayName(SaleDate) as Day,
SaleDate,
COUNT(Distinct RNumber) as Receipts,
Count(Customer)as Items,
ROUND(Sum(PRICE),2) as Revenue
from receipts
join items on Receipt = RNumber
join goods on Item = GId
where Month(SaleDate) = 10
and DayOfMonth(SaleDate) >= 8
and DayOfMonth(SaleDate) <= 14
group by SaleDate
order by SaleDate
;


USE `BAKERY`;
-- BAKERY-5
-- Report all days on which more than ten tarts were purchased, sorted in chronological order.
select SaleDate
from receipts
join items on Receipt = RNumber
join goods on Item = GId
where Food = 'Tart'
group by SaleDate
having COUNT(*) > 10
;


USE `CSU`;
-- CSU-1
-- For each campus that averaged more than $2,500 in fees between the years 2000 and 2005 (inclusive), report the total cost of fees for this six year period. Sort in ascending order by fee.
select campus,SUM(fee) as Total from campuses
join fees on Id = CampusId
where fees.Year >= 2000
and fees.Year <= 2005
group by campus
having SUM(fee) / COUNT(*) > 2500.0
order by Total;


USE `CSU`;
-- CSU-2
-- For each campus for which data exists for more than 60 years, report the average, the maximum and the minimum enrollment (for all years). Sort your output by average enrollment.
select Campus,MIN(Enrolled),AVG(Enrolled),MAX(Enrolled) as Minimum from campuses
join enrollments
on CampusId = Id
group by Campus
having COUNT(enrollments.Year) > 60
order by AVG(Enrolled)
;


USE `CSU`;
-- CSU-3
-- For each campus in LA and Orange counties report the total number of degrees granted between 1998 and 2002 (inclusive). Sort the output in descending order by the number of degrees.

select Campus,SUM(degrees) from campuses join
degrees on CampusId = Id
where (County = 'Los Angeles' OR County = 'Orange')
and (degrees.year >= 1998 and degrees.year <= 2002)
group by Campus
order by SUM(degrees) desc
;


USE `CSU`;
-- CSU-4
-- For each campus that had more than 20,000 enrolled students in 2004, report the number of disciplines for which the campus had non-zero graduate enrollment. Sort the output in alphabetical order by the name of the campus. (Exclude campuses that had no graduate enrollment at all.)
select Campus,COUNT(Discipline) from campuses
join enrollments
on enrollments.CampusId = Id
join discEnr
on discEnr.CampusId = Id
where enrollments.year = 2004 and Enrolled > 20000
and Gr > 0
group by Campus
order by Campus
;


USE `MARATHON`;
-- MARATHON-1
-- For each gender/age group, report total number of runners in the group, the overall place of the best runner in the group and the overall place of the slowest runner in the group. Output result sorted by age group and sorted by gender (F followed by M) within each age group.
select AgeGroup,Sex,COUNT(*),MIN(Place),MAX(Place) from marathon
group by AgeGroup,Sex
order by AgeGroup,Sex
;


USE `MARATHON`;
-- MARATHON-2
-- Report the total number of gender/age groups for which both the first and the second place runners (within the group) are from the same state.
select count(*) from
(select AgeGroup,Sex,State from marathon
where GroupPlace = 1 OR GroupPlace = 2
group by AgeGroup,Sex,State
having COUNT(State) = 2) t1
;


USE `MARATHON`;
-- MARATHON-3
-- For each full minute, report the total number of runners whose pace was between that number of minutes and the next. In other words: how many runners ran the marathon at a pace between 5 and 6 mins, how many at a pace between 6 and 7 mins, and so on.
select Minute(Pace),Count(*) from marathon
group by Minute(Pace)
;


USE `MARATHON`;
-- MARATHON-4
-- For each state with runners in the marathon, report the number of runners from the state who finished in top 10 in their gender-age group. If a state did not have runners in top 10, do not output information for that state. Sort in descending order by the number of top 10 runners.
select State,Count(*) from marathon
where GroupPlace < 11
group by State
having Count(*) > 0
order by Count(*) desc
;


USE `MARATHON`;
-- MARATHON-5
-- For each Connecticut town with 3 or more participants in the race, report the average time of its runners in the race computed in seconds. Output the results sorted by the average time (lowest average time first).
select Town,Round(AVG(TIME_TO_SEC(RunTime)),1) from marathon
where State = 'CT'
group by Town
having count(*) >= 3
order by Round(AVG(TIME_TO_SEC(RunTime)),1)
;


USE `AIRLINES`;
-- AIRLINES-1
-- Find all airports with exactly 17 outgoing flights. Report airport code and the full name of the airport sorted in alphabetical order by the code.
select Code,Name from airports
join flights on Code = Source
group by Code,Name
having Count(FlightNo) = 17
order by Code
;


USE `AIRLINES`;
-- AIRLINES-2
-- Find the number of airports from which airport ANP can be reached with exactly one transfer. Make sure to exclude ANP itself from the count. Report just the number.
-- No attempt


USE `AIRLINES`;
-- AIRLINES-3
-- Find the number of airports from which airport ATE can be reached with at most one transfer. Make sure to exclude ATE itself from the count. Report just the number.
-- No attempt


USE `AIRLINES`;
-- AIRLINES-4
-- For each airline, report the total number of airports from which it has at least one outgoing flight. Report the full name of the airline and the number of airports computed. Report the results sorted by the number of airports in descending order. In case of tie, sort by airline name A-Z.
select Name,Count(*) from
(select Name,Count(*) from airlines 
join flights on Id = Airline
group by Name,Source
having Count(Source) > 0) t1
group by Name
order by Count(*) desc,Name
;


USE `INN`;
-- INN-1
-- For each room, report the total revenue for all stays and the average revenue per stay generated by stays in the room that began in the months of September, October and November. Sort output in descending order by total revenue. Output full room names.
select 
RoomName,
Round(SUM(Rate * DateDiff(CheckOut,CheckIn)),2) as TotalRevenue,
Round(AVG(Rate * DateDiff(CheckOut,CheckIn)),2) as AveragePerStay
from reservations
join rooms on RoomCode = Room
where Month(CheckIn) >= 9 and Month(CheckIn) <= 11
group by RoomName
order by SUM(Rate * DateDiff(CheckOut,CheckIn)) desc
;


USE `INN`;
-- INN-2
-- Report the total number of reservations that began on Fridays, and the total revenue they brought in.
select
COUNT(*) as Stays,
Round(SUM(Rate * DateDiff(CheckOut,CheckIn)),2) as REVENUE
from reservations
where DayName(CheckIn) = 'Friday'
group by DayName(CheckIn)
;


USE `INN`;
-- INN-3
-- For each day of the week, report the total number of reservations that began on that day and the total revenue for these reservations. Report days of week as Monday, Tuesday, etc. Order days from Sunday to Saturday.
select
DayName(CheckIn),
COUNT(*) as Stays,
Round(SUM(Rate * DateDiff(CheckOut,CheckIn)),2) as REVENUE
from reservations
group by DayOfWeek(CheckIn),DayName(CheckIn)
order by DayOfWeek(CheckIn)
;


USE `INN`;
-- INN-4
-- For each room report the highest markup against the base price and the largest markdown (discount). Report markups and markdowns as the signed difference between the base price and the rate. Sort output in descending order beginning with the largest markup. In case of identical markup/down sort by room name A-Z. Report full room names.
select 
roomname,
MAX(Rate - BasePrice) as Markup,
MIN(Rate - BasePrice) as Discount
from reservations
join rooms on Room = RoomCode
group by roomname
order by MAX(Rate - BasePrice) desc,roomname
;


USE `INN`;
-- INN-5
-- For each room report how many nights in calendar year 2010 the room was occupied. Report the room code, the full name of the room and the number of occupied nights. Sort in descending order by occupied nights. (Note: it has to be number of nights in 2010. The last reservation in each room can go beyond December 31, 2010, so the ”extra” nights in 2011 need to be deducted).
select 
t1.RoomCode,
t1.RoomName,
t1.DaysOccupied - t2.DaysOccupied - 1 as DaysOccupied
from

(select RoomCode,RoomName,
SUM(DateDiff(CheckOut,CheckIn)) as DaysOccupied
from reservations
join rooms on Room = RoomCode
where (Year(CheckIn) = 2010 OR Year(CheckOut) = 2010)
group by RoomCode,RoomName) t1

join

(select 
RoomCode,RoomName,
SUM(DateDiff(CheckOut,'2011-01-01')) as DaysOccupied
from reservations
join rooms on Room = RoomCode
where (Year(CheckIn) = 2010 AND Year(CheckOut) = 2011)
group by RoomCode,RoomName) t2

on t1.RoomCode = t2.RoomCode 

order by DaysOccupied Desc
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- For each performer (by first name) report how many times she sang lead vocals on a song. Sort output in descending order by the number of leads.
select Firsname,Count(*) from Vocals
join Band on Bandmate = Id
where VocalType = 'lead'
group by Bandmate
order by Count(*) desc
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report how many different instruments each performer plays on songs from the album 'Le Pop'. Sort the output by the first name of the performers.
select Firsname,Count(distinct Instrument) from Albums
join Tracklists on Album = AId
join Songs on SongId = Tracklists.Song
join Instruments on SongId = Instruments.Song
join Band on Bandmate = Band.Id
where Albums.Title = 'Le Pop'
group by Bandmate
order by Firsname
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- Report the number of times Turid stood at each stage position when performing live. Sort output in ascending order of the number of times she performed in each position.

select StagePosition,Count(*) from Performance 
join Band
on Id = Bandmate 
where Firsname = 'Turid'
group by StagePosition
order by Count(*)
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Report how many times each performer (other than Anne-Marit) played bass balalaika on the songs where Anne-Marit was positioned on the left side of the stage. Sort output alphabetically by the name of the performer.

select Firsname,Count(*) from
(select distinct Performance.Song as Song,Firsname,Instrument from Performance
join Instruments on Performance.Song = Instruments.Song
join Band on Instruments.Bandmate = Band.Id
where Firsname <> 'Anne-Marit' 
and Instrument = 'bass balalaika') t1
join
(select Performance.Song as Song from Performance join Band
on Bandmate = Id
where StagePosition = 'left'
and Firsname = 'Anne-Marit') t2
on t1.Song = t2.Song
group by Firsname
order by Firsname
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Report all instruments (in alphabetical order) that were played by three or more people.
select distinct Instrument from Instruments
group by Instrument
having Count(distinct Bandmate) > 2
order by Instrument
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- For each performer, report the number of times they played more than one instrument on the same song. Sort output in alphabetical order by first name of the performer
select Firsname,Count(*) from Band
join
(select Bandmate from Instruments
group by Bandmate,Song
having Count(Instrument) > 1) t1
on Id = Bandmate
group by Id
order by Firsname
;


