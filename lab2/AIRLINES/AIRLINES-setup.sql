DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS airlines;
DROP TABLE IF EXISTS airports100;

CREATE TABLE airlines (
   ID INT PRIMARY KEY,
   Airline VARCHAR(255) UNIQUE,
   Abbreviation VARCHAR(255) UNIQUE,
   Country VARCHAR(255)
);

CREATE TABLE airports100 (
   AirportCode CHAR(3) PRIMARY KEY,
   City VARCHAR(255),
   AirportName VARCHAR(255),
   Country VARCHAR(255),
   CountryAbbrev VARCHAR(255)
);

CREATE TABLE flights (
   FlightNo INT,
   Airline INT,
   SourceAirport CHAR(3),
   DestAirport CHAR(3),
   FOREIGN KEY (SourceAirport) REFERENCES airports100 (AirportCode),
   FOREIGN KEY (DestAirport) REFERENCES airports100 (AirportCode),
   FOREIGN KEY (Airline) REFERENCES airlines (ID),
   PRIMARY KEY (Flightno, Airline)
);
