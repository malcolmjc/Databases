-- AIRLINES 1
DELETE FROM flights WHERE DestAirport <> 'AKI' AND SourceAirport <> 'AKI';

-- AIRLINES 2
UPDATE flights SET FlightNo = FlightNo + 2000 WHERE Airline <> 7 AND Airline <> 10 AND Airline <> 12;

-- AIRLINES 3
DROP TABLE IF EXISTS 3nf_flights;
DROP TABLE IF EXISTS 3nf_airlines;
DROP TABLE IF EXISTS 3nf_airports100;
DROP TABLE IF EXISTS 3nf_countries;

CREATE TABLE 3nf_countries (
   Abbreviation VARCHAR(255) PRIMARY KEY,
   Name VARCHAR(255) UNIQUE
);

CREATE TABLE 3nf_airlines (
   ID INT PRIMARY KEY,
   Airline VARCHAR(255) UNIQUE,
   Abbreviation VARCHAR(255) UNIQUE,
   Country VARCHAR(255),
   FOREIGN KEY (Country) REFERENCES 3nf_countries (Abbreviation)
);

CREATE TABLE 3nf_airports100 (
   AirportCode CHAR(3) PRIMARY KEY,
   City VARCHAR(255) NOT NULL,
   AirportName VARCHAR(255) NOT NULL,
   Country VARCHAR(255),
   FOREIGN KEY (Country) REFERENCES 3nf_countries (Abbreviation)
);

CREATE TABLE 3nf_flights (
   FlightNo INT,
   Airline INT,
   SourceAirport CHAR(3),
   DestAirport CHAR(3),
   FOREIGN KEY (SourceAirport) REFERENCES 3nf_airports100 (AirportCode),
   FOREIGN KEY (DestAirport) REFERENCES 3nf_airports100 (AirportCode),
   FOREIGN KEY (Airline) REFERENCES 3nf_airlines (ID),
   PRIMARY KEY (Flightno, Airline)
);

-- Update airports100 CountryAbbrev to Match airlines
UPDATE airports100 SET CountryAbbrev = 'USA' WHERE CountryAbbrev = 'US ';

-- Fill Countries Table
INSERT INTO 3nf_countries(Abbreviation, Name)
SELECT DISTINCT CountryAbbrev, Country
FROM airports100;

-- Fill Airlines Table
INSERT INTO 3nf_airlines(ID, Airline, Abbreviation, Country)
SELECT ID, Airline, Abbreviation, Country
FROM airlines;

-- Fill Airports Table
INSERT INTO 3nf_airports100(AirportCode, City, AirportName, Country)
SELECT AirportCode, City, AirportName, CountryAbbrev
FROM airports100;

-- Fill Flights Table
INSERT INTO 3nf_flights(FlightNo, Airline, SourceAirport, DestAirport)
SELECT FlightNo, Airline, SourceAirport, DestAirport
FROM flights;

-- BAKERY 1
UPDATE goods SET Price = Price + 2 WHERE Food = 'Cake' AND (Flavor = 'Lemon' OR Flavor = 'Napoleon');

-- BAKERY 2
UPDATE goods SET Price = Price * 1.15 WHERE (Flavor = 'Apricot' OR Flavor = 'Chocolate') AND Price < 5.95;

-- BAKERY 3
ALTER TABLE receipts
CHANGE COLUMN Date SaleDateTime DateTime;

-- INN 1
CREATE TABLE RoomService (
   ID INT AUTO_INCREMENT PRIMARY KEY,
   ReservationCode INT NOT NULL,
   OrderTime DATETIME NOT NULL,
   DeliveryTime DATETIME NOT NULL,
   Bill Decimal(7, 2) NOT NULL,
   Gratuity Decimal(7, 2),
   FirstName VARCHAR(255) NOT NULL,
   FOREIGN KEY (ReservationCode) REFERENCES Reservations (Code)
);

INSERT INTO RoomService(ReservationCode, OrderTime, DeliveryTime, Bill, Gratuity, FirstName)
VALUES (98805, '2018-01-19 03:14:07', '2018-01-19 05:14:07', 23.00, 2.30, 'Tom'),
       (56475, '2018-01-20 03:14:07', '2018-01-20 05:14:07', 23.00, 2.30, 'Jennifer'),
       (56737, '2018-01-20 03:14:07', '2018-01-20 05:14:07', 23.00, 2.30, 'Mark'),
       (98805, '2018-01-20 03:14:07', '2018-01-20 05:14:07', 23.00, 2.30, 'Tom');

INSERT INTO RoomService(ReservationCode, OrderTime, DeliveryTime, Bill, FirstName)
VALUES (98805, '2018-01-21 03:14:07', '2018-01-21 05:14:07', 23.00, 'Tom');

INSERT INTO RoomService(ReservationCode, OrderTime, DeliveryTime, Bill, FirstName)
VALUES (66494, '2018-01-21 03:14:07', '2018-01-21 05:14:07', 23.00, 'Ena');

-- INN 2
DELETE RoomService FROM Reservations INNER JOIN RoomService 
   WHERE Reservations.Code = RoomService.ReservationCode AND
         (Reservations.FirstName = 'ENA' AND Reservations.LastName = 'KOLB') AND
         (Reservations.CheckOut < curdate() - interval 6 month);

DELETE FROM Reservations WHERE FirstName = 'ENA' AND LastName = 'Kolb' AND
         CheckOut < curdate() - interval 6 month;
-- INN 3
DELIMITER **
CREATE TRIGGER Overlapping BEFORE INSERT ON Reservations
FOR EACH ROW
  BEGIN
    IF EXISTS (SELECT * from Reservations WHERE ROOM = New.Room AND CheckOut > NEW.CheckIn AND CheckIn < NEW.CheckOut) THEN
      SIGNAL SQLSTATE '45000';
     END IF;
   END;**
DELIMITER ;
