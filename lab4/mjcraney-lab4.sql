-- Lab 4: JOIN and WHERE
-- mjcraney
-- Nov 1, 2019

USE `STUDENTS`;
-- STUDENTS-1
-- Find all students who study in classroom 111. For each student list first and last name. Sort the output by the last name of the student.
SELECT FirstName,LastName FROM list 
WHERE classroom = 111
ORDER BY LastName;


USE `STUDENTS`;
-- STUDENTS-2
-- For each classroom report the grade that is taught in it. Report just the classroom number and the grade number. Sort output by classroom in descending order.
SELECT DISTINCT classroom,grade FROM list 
ORDER BY classroom DESC;


USE `STUDENTS`;
-- STUDENTS-3
-- Find all teachers who teach fifth grade. Report first and last name of the teachers and the room number. Sort the output by room number.
SELECT DISTINCT First,Last,classroom FROM teachers NATURAL JOIN list
WHERE grade = 5
ORDER BY classroom;


USE `STUDENTS`;
-- STUDENTS-4
-- Find all students taught by OTHA MOYER. Output first and last names of students sorted in alphabetical order by their last name.
SELECT FirstName,LastName FROM list NATURAL JOIN teachers
WHERE First = 'OTHA' AND Last = 'MOYER'
ORDER BY LastName;


USE `STUDENTS`;
-- STUDENTS-5
-- For each teacher teaching grades K through 3, report the grade (s)he teaches. Each name has to be reported exactly once. Sort the output by grade and alphabetically by teacher’s last name for each grade.
SELECT DISTINCT First,Last,grade FROM list NATURAL JOIN teachers
WHERE grade <= 3
ORDER BY grade,Last;


USE `BAKERY`;
-- BAKERY-1
-- Find all chocolate-flavored items on the menu whose price is under $5.00. For each item output the flavor, the name (food type) of the item, and the price. Sort your output in descending order by price.
SELECT Flavor,Food,PRICE FROM goods
WHERE PRICE < 5.00 AND FLAVOR = 'Chocolate'
ORDER BY PRICE DESC;


USE `BAKERY`;
-- BAKERY-2
-- Report the prices of the following items (a) any cookie priced above $1.10, (b) any lemon-flavored items, or (c) any apple-flavored item except for the pie. Output the flavor, the name (food type) and the price of each pastry. Sort the output in alphabetical order by the flavor and then pastry name.
SELECT Flavor,Food,PRICE FROM goods
WHERE (Food = 'Cookie' AND PRICE > 1.10)
OR (Flavor = 'Lemon')
OR (Flavor = 'Apple' AND Food <> 'Pie')
ORDER BY Flavor,Food;


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who made a purchase on October 3, 2007. Report the name of the customer (last, first). Sort the output in alphabetical order by the customer’s last name. Each customer name must appear at most once.
SELECT DISTINCT LastName,FirstName FROM receipts JOIN customers 
ON Customer = CId
WHERE SaleDate = '2007-10-03'
ORDER BY LastName;


USE `BAKERY`;
-- BAKERY-4
-- Find all different cakes purchased on October 4, 2007. Each cake (flavor, food) is to be listed once. Sort output in alphabetical order by the cake flavor.
SELECT DISTINCT Flavor,Food FROM 
receipts JOIN items
ON RNumber = Receipt
JOIN goods
ON Item = GId
WHERE SaleDate = '2007-10-04' AND Food = 'Cake'
ORDER BY Flavor;


USE `BAKERY`;
-- BAKERY-5
-- List all pastries purchased by ARIANE CRUZEN on October 25, 2007. For each pastry, specify its flavor and type, as well as the price. Output the pastries in the order in which they appear on the receipt (each pastry needs to appear the number of times it was purchased).
SELECT Flavor,Food,PRICE FROM receipts
JOIN items ON RNumber = Receipt
JOIN goods ON Item = GId
JOIN customers ON Customer = CId
WHERE SaleDate = '2007-10-25' AND LastName = 'CRUZEN' AND FirstName = 'ARIANE';


USE `BAKERY`;
-- BAKERY-6
-- Find all types of cookies purchased by KIP ARNN during the month of October of 2007. Report each cookie type (flavor, food type) exactly once in alphabetical order by flavor.

SELECT DISTINCT Flavor,Food FROM receipts
JOIN items ON RNumber = Receipt
JOIN goods ON Item = GId
JOIN customers ON Customer = CId
WHERE Food = 'Cookie' AND LastName = 'ARNN' AND FirstName = 'KIP'
ORDER BY Flavor;


USE `CSU`;
-- CSU-1
-- Report all campuses from Los Angeles county. Output the full name of campus in alphabetical order.
SELECT Campus FROM campuses
WHERE County = 'Los Angeles'
ORDER BY Campus;


USE `CSU`;
-- CSU-2
-- For each year between 1994 and 2000 (inclusive) report the number of students who graduated from California Maritime Academy Output the year and the number of degrees granted. Sort output by year.
SELECT year,degrees FROM degrees JOIN (SELECT Id,Campus,Location,Year as Founded FROM campuses) campuses
ON CampusId = Id
WHERE Campus = 'California Maritime Academy' AND year >= 1994 AND year <= 2000
ORDER BY year;


USE `CSU`;
-- CSU-3
-- Report undergraduate and graduate enrollments (as two numbers) in ’Mathematics’, ’Engineering’ and ’Computer and Info. Sciences’ disciplines for both Polytechnic universities of the CSU system in 2004. Output the name of the campus, the discipline and the number of graduate and the number of undergraduate students enrolled. Sort output by campus name, and by discipline for each campus.
SELECT campus,name,gr,ug FROM discEnr 
JOIN (SELECT Name,Id as DId FROM disciplines) disciplines
ON Discipline = DId
JOIN (SELECT Id,Campus,Location,Year as Founded FROM campuses) campuses
ON CampusId = Id
WHERE (Name = 'Mathematics' OR Name = 'Engineering' OR Name = 'Computer and Info. Sciences')
AND Campus LIKE '%Polytechnic%'
AND year = 2004
ORDER BY Campus,Name;


USE `CSU`;
-- CSU-4
-- Report graduate enrollments in 2004 in ’Agriculture’ and ’Biological Sciences’ for any university that offers graduate studies in both disciplines. Report one line per university (with the two grad. enrollment numbers in separate columns), sort universities in descending order by the number of ’Agriculture’ graduate students.
SELECT t1.campus,Agriculture,Biology FROM
(SELECT DISTINCT campus,Gr as Agriculture
FROM (SELECT Name,Id as DId FROM disciplines) disciplines
JOIN discEnr
ON Discipline = DId
JOIN (SELECT Id,Campus,Location,Year as Founded FROM campuses) campuses 
ON CampusId = Id
WHERE Name = 'Agriculture'
AND gr > 0
AND year = 2004) t1

JOIN

(SELECT DISTINCT campus,Gr as Biology
FROM (SELECT Name,Id as DId FROM disciplines) disciplines
JOIN discEnr
ON Discipline = DId
JOIN (SELECT Id,Campus,Location,Year as Founded FROM campuses) campuses 
ON CampusId = Id
WHERE Name = 'Biological Sciences'
AND gr > 0
AND year = 2004) t2

ON t1.campus = t2.campus

ORDER BY Agriculture DESC;


USE `CSU`;
-- CSU-5
-- Find all disciplines and campuses where graduate enrollment in 2004 was at least three times higher than undergraduate enrollment. Report campus names and discipline names. Sort output by campus name, then by discipline name in alphabetical order.
SELECT campus,name,ug,gr
FROM (SELECT Name,Id as DId FROM disciplines) disciplines
JOIN discEnr
ON Discipline = DId
JOIN (SELECT Id,Campus,Location,Year as Founded FROM campuses) campuses 
ON CampusId = Id
WHERE gr / 3 > ug
AND year = 2004
ORDER BY campus,name;


USE `CSU`;
-- CSU-6
-- Report the total amount of money collected from student fees (use the full-time equivalent enrollment for computations) at ’Fresno State University’ for each year between 2002 and 2004 inclusively, and the amount of money (rounded to the nearest penny) collected from student fees per each full-time equivalent faculty. Output the year, the two computed numbers sorted chronologically by year.
SELECT fees.year,enrollments.FTE * fee AS COLLECTED,ROUND((enrollments.FTE * fee) / faculty.FTE, 2) AS 'PER FACULTY' FROM fees
JOIN campuses ON fees.CampusId = Id
JOIN faculty ON faculty.CampusId = Id AND faculty.year = fees.year
JOIN enrollments ON enrollments.year = fees.year AND enrollments.CampusId = Id
WHERE fees.year <= 2004 AND fees.year >= 2002
AND campus = 'Fresno State University'
;


USE `CSU`;
-- CSU-7
-- Find all campuses where enrollment in 2003 (use the FTE numbers), was higher than the 2003 enrollment in ’San Jose State University’. Report the name of campus, the 2003 enrollment number, the number of faculty teaching that year, and the student-to-faculty ratio, rounded to one decimal place. Sort output in ascending order by student-to-faculty ratio.
SELECT t2.Campus,STUDENTS,Faculty,ROUND(STUDENTS / Faculty, 1) AS RATIO FROM
(SELECT FTE FROM campuses JOIN
enrollments ON CampusId = Id
WHERE enrollments.year = 2003
AND Campus = 'San Jose State University') t1
JOIN 
(SELECT Campus,enrollments.FTE AS Students,faculty.FTE AS Faculty FROM campuses JOIN
    enrollments ON enrollments.CampusId = Id
    JOIN faculty ON faculty.CampusId = Id AND faculty.year = 2003
    WHERE enrollments.year = 2003
    AND Campus <> 'San Jose State University' 
) t2
ON t2.STUDENTS > t1.FTE
ORDER BY RATIO
;


USE `INN`;
-- INN-1
-- Find all modern rooms with a base price below $160 and two beds. Report room names and codes in alphabetical order by the code.
SELECT RoomCode,RoomName FROM rooms
WHERE basePrice < 160 AND beds = 2 AND decor = 'modern'
ORDER BY RoomCode
;


USE `INN`;
-- INN-2
-- Find all July 2010 reservations (a.k.a., all reservations that both start AND end during July 2010) for the ’Convoke and sanguine’ room. For each reservation report the last name of the person who reserved it, checkin and checkout dates, the total number of people staying and the daily rate. Output reservations in chronological order.
SELECT Lastname,CheckIn AS checkin,CheckOut AS checkout,Adults + Kids AS Guests,Rate FROM rooms
JOIN reservations on reservations.Room = RoomCode
WHERE CheckIn >= '2010-07-01' AND CheckOut <= '2010-07-31'
AND RoomName = 'Convoke and sanguine'
ORDER BY CheckIn
;


USE `INN`;
-- INN-3
-- Find all rooms occupied on February 6, 2010. Report full name of the room, the check-in and checkout dates of the reservation. Sort output in alphabetical order by room name.
SELECT RoomName,CheckIn,CheckOut FROM reservations JOIN rooms ON Room = RoomCode
WHERE CheckIn <= '2010-02-06' AND CheckOut > '2010-02-06'
ORDER BY RoomName
;


USE `INN`;
-- INN-4
-- For each stay by GRANT KNERIEN in the hotel, calculate the total amount of money, he paid. Report reservation code, checkin and checkout dates, room name (full) and the total stay cost. Sort output in chronological order by the day of arrival.

SELECT code,RoomName,CheckIn,CheckOut,DATEDIFF(CheckOut, CheckIn) * Rate AS PAID FROM reservations
JOIN rooms ON Room = RoomCode
WHERE FirstName = 'GRANT' AND LastName = 'KNERIEN'
ORDER BY CheckIn
;


USE `INN`;
-- INN-5
-- For each reservation that starts on December 31, 2010 report the room name, nightly rate, number of nights spent and the total amount of money paid. Sort output in descending order by the number of nights stayed.
SELECT RoomName,Rate,DATEDIFF(CheckOut, CheckIn) AS Nights,DATEDIFF(CheckOut, CheckIn) * Rate AS MONEY FROM reservations
JOIN rooms ON Room = RoomCode
WHERE CheckIn = '2010-12-31'
ORDER BY NIGHTS DESC
;


USE `INN`;
-- INN-6
-- Report all reservations in rooms with double beds that contained four adults. For each reservation report its code, the full name and the code of the room, check-in and check out dates. Report reservations in chronological order, then sorted by the three-letter room code (in alphabetical order) for any reservations that began on the same day.
SELECT Code,Room,RoomName,CheckIn,CheckOut FROM reservations
JOIN rooms ON Room = RoomCode
WHERE bedType = 'Double' AND Adults = 4
ORDER BY CheckIn,RoomCode;


USE `MARATHON`;
-- MARATHON-1
-- Report the time, pace and the overall place of TEDDY BRASEL.
select Place,RunTime,Pace from marathon
WHERE FirstName = 'TEDDY' AND LastName = 'BRASEL'
;


USE `MARATHON`;
-- MARATHON-2
-- Report names (first, last), times, overall places as well as places in their gender-age group for all female runners from QUNICY, MA. Sort output by overall place in the race.
select FirstName,LastName,Place,RunTime,GroupPlace from marathon
WHERE Town = 'QUNICY' AND State = 'MA' AND Sex = 'F'
ORDER BY Place;


USE `MARATHON`;
-- MARATHON-3
-- Find the results for all 34-year old female runners from Connecticut (CT). For each runner, output name (first, last), town and the running time. Sort by time.
select FirstName,LastName,Town,RunTime from marathon
WHERE Age = 34 AND State = 'CT' AND Sex = 'F'
;


USE `MARATHON`;
-- MARATHON-4
-- Find all duplicate bibs in the race. Report just the bib numbers. Sort in ascending order of the bib number. Each duplicate bib number must be reported exactly once.
SELECT BibNumber
FROM marathon
GROUP BY BibNumber
HAVING COUNT(BibNumber) > 1
ORDER BY BibNumber
;


USE `MARATHON`;
-- MARATHON-5
-- List all runners who took first place and second place in their respective age/gender groups. For age group, output name (first, last) and age for both the winner and the runner up (in a single row). Order the output by gender, then by age group.
SELECT DISTINCT 
t1.Sex,t1.AgeGroup,t1.FirstName,t1.LastName,t1.Age,
t2.FirstName,t2.LastName,t2.Age
FROM
(select Sex,AgeGroup,FirstName,LastName,Age from marathon
WHERE GroupPlace = 1) t1
JOIN
(select Sex,AgeGroup,FirstName,LastName,Age from marathon
WHERE GroupPlace = 2) t2
ON (t1.AgeGroup = t2.AgeGroup AND t1.Sex = t2.Sex)

ORDER BY Sex,AgeGroup
;


USE `AIRLINES`;
-- AIRLINES-1
-- Find all airlines that have at least one flight out of AXX airport. Report the full name and the abbreviation of each airline. Report each name only once. Sort the airlines in alphabetical order.
select DISTINCT Name,Abbr from flights 
JOIN airlines ON Airline = ID
WHERE Source = 'AXX'
ORDER BY Name;


USE `AIRLINES`;
-- AIRLINES-2
-- Find all destinations served from the AXX airport by Northwest. Re- port flight number, airport code and the full name of the airport. Sort in ascending order by flight number.

select flightno,Destination AS Code,airports.Name from flights 
JOIN airlines ON Airline = ID
JOIN airports ON airports.Code = Destination
WHERE Source = 'AXX' AND airlines.Name = 'Northwest Airlines'
ORDER BY flightno;


USE `AIRLINES`;
-- AIRLINES-3
-- Find all *other* destinations that are accessible from AXX on only Northwest flights with exactly one change-over. Report pairs of flight numbers, airport codes for the final destinations, and full names of the airports sorted in alphabetical order by the airport code.
select * from
(select flightno,Destination AS Code,airports.Name from flights 
JOIN airlines ON Airline = ID
JOIN airports ON airports.Code = Destination
WHERE Source = 'AXX' AND airlines.Name = 'Northwest Airlines') t1
JOIN
(select * from flights
JOIN airlines ON Airline = ID
WHERE airlines.Name = 'Northwest Airlines'
) t2
ON t1.Code = t2.Source
;


USE `AIRLINES`;
-- AIRLINES-4
-- Report all pairs of airports served by both Frontier and JetBlue. Each airport pair must be reported exactly once (if a pair X,Y is reported, then a pair Y,X is redundant and should not be reported).
select DISTINCT t1.Source,t1.Destination from
(SELECT DISTINCT Source,Destination FROM flights
JOIN airlines ON Airline = ID
WHERE airlines.Name = 'Frontier Airlines') t1
JOIN
(SELECT DISTINCT Source,Destination FROM flights
JOIN airlines ON Airline = ID
WHERE airlines.Name = 'JetBlue Airways') t2
ON t1.destination = t2.destination 
AND t1.source = t2.source
AND t1.source < t2.destination
;


USE `AIRLINES`;
-- AIRLINES-5
-- Find all airports served by ALL five of the airlines listed below: Delta, Frontier, USAir, UAL and Southwest. Report just the airport codes, sorted in alphabetical order.
select distinct t1.source  from
(SELECT DISTINCT Source FROM flights
JOIN airlines ON Airline = ID
WHERE airlines.Name = 'Frontier Airlines') t1
JOIN
(SELECT DISTINCT Source FROM flights
JOIN airlines ON Airline = ID
WHERE airlines.Name = 'Southwest Airlines') t2
ON t1.source = t2.source
JOIN
(SELECT DISTINCT Source FROM flights
JOIN airlines ON Airline = ID
WHERE airlines.Name = 'US Airways') t3
ON t2.source = t3.source
JOIN
(SELECT DISTINCT Source FROM flights
JOIN airlines ON Airline = ID
WHERE airlines.Name = 'Delta Airlines') t4
ON t3.source = t4.source
JOIN
(SELECT DISTINCT Source FROM flights
JOIN airlines ON Airline = ID
WHERE airlines.Name = 'United Airlines') t5
ON t4.source = t5.source
ORDER BY t1.source
;


USE `AIRLINES`;
-- AIRLINES-6
-- Find all airports that are served by at least three Southwest flights. Report just the three-letter codes of the airports — each code exactly once, in alphabetical order.
SELECT Destination
FROM flights 
JOIN airlines ON Airline = ID
WHERE airlines.Name = 'Southwest Airlines'
GROUP BY Destination
HAVING COUNT(Destination) >= 3
ORDER BY Destination;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report, in order, the tracklist for ’Le Pop’. Output just the names of the songs in the order in which they occur on the album.
select Songs.Title from Albums JOIN
Tracklists ON AId = Album
JOIN Songs ON Song = SongId
WHERE Albums.Title = 'Le Pop';


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- List the instruments each performer plays on ’Mother Superior’. Output the first name of each performer and the instrument, sort alphabetically by the first name.
select Firsname,Instrument from Songs JOIN
Instruments ON Song = SongId 
JOIN Band ON Bandmate = Id
WHERE Title = 'Mother Superior'
ORDER BY Firsname
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List all instruments played by Anne-Marit at least once during the performances. Report the instruments in alphabetical order (each instrument needs to be reported exactly once).
select DISTINCT Instrument from Performance JOIN
Songs ON Performance.Song = SongId
JOIN Band On Performance.Bandmate = Id
Join Instruments ON Instruments.Song = SongId AND Instruments.Bandmate = Id
WHERE Firsname = 'Anne-Marit'
ORDER BY Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find all songs that featured ukalele playing (by any of the performers). Report song titles in alphabetical order.
select Title from Songs JOIN
Instruments ON Song = SongId
WHERE Instrument = 'ukalele'
ORDER BY Title
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments Turid ever played on the songs where she sang lead vocals. Report the names of instruments in alphabetical order (each instrument needs to be reported exactly once).
select Distinct Instrument from Songs 
JOIN Instruments ON Instruments.Song = SongId
JOIN Band On Id = Instruments.Bandmate
JOIN Vocals ON Id = Vocals.Bandmate AND Vocals.Song = SongId
WHERE Firsname = 'Turid' AND VocalType = 'lead'
ORDER BY Instrument
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Find all songs where the lead vocalist is not positioned center stage. For each song, report the name, the name of the lead vocalist (first name) and her position on the stage. Output results in alphabetical order by the song. (Note: if a song had more than one lead vocalist, you may see multiple rows returned for that song. This is the expected behavior).
SELECT s.Title, b.Firsname, p.StagePosition
FROM Songs s
JOIN Performance p
ON s.SongId = p.Song
JOIN Band b
ON b.Id = p.Bandmate
JOIN Vocals v
ON v.Song = s.SongId
AND v.Bandmate = b.Id
WHERE p.StagePosition <> 'center'
AND v.VocalType = 'lead'
ORDER BY s.Title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Find a song on which Anne-Marit played three different instruments. Report the name of the song. (The name of the song shall be reported exactly once)
select Title from Songs 
JOIN Instruments ON Instruments.Song = SongId
JOIN Band On Id = Instruments.Bandmate
WHERE Firsname = 'Anne-Marit'
Group By Title
HAVING COUNT(Title) = 3
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Report the positioning of the band during ’A Bar In Amsterdam’. (just one record needs to be returned with four columns (right, center, back, left) containing the first names of the performers who were staged at the specific positions during the song).
select t3.Firsname AS 'RIGHT', t1.Firsname AS CENTER,
t4.Firsname AS BACK, t2.Firsname AS 'LEFT' FROM

(
(SELECT * FROM Songs 
JOIN Performance ON Song = SongId
JOIN Band ON Id = Bandmate
WHERE Title = 'A Bar in Amsterdam' AND StagePosition = 'center') t1

JOIN

(SELECT * FROM Songs 
JOIN Performance ON Song = SongId
JOIN Band ON Id = Bandmate
WHERE Title = 'A Bar in Amsterdam' AND StagePosition = 'left') t2

JOIN

(SELECT * FROM Songs 
JOIN Performance ON Song = SongId
JOIN Band ON Id = Bandmate
WHERE Title = 'A Bar in Amsterdam' AND StagePosition = 'right') t3

JOIN

(SELECT * FROM Songs 
JOIN Performance ON Song = SongId
JOIN Band ON Id = Bandmate
WHERE Title = 'A Bar in Amsterdam' AND StagePosition = 'back') t4
)
;


