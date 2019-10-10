CREATE TABLE Airline (
   ID INT PRIMARY KEY,
   Airline VARCHAR(255),
   Abbreviation VARCHAR(255),
   Country VARCHAR(255)
);

CREATE TABLE Airport (
   AirportCode CHAR(3) PRIMARY KEY,
   City VARCHAR(255),
   AirportName VARCHAR(255),
   Country VARCHAR(255),
   CountryAbbrev VARCHAR(255)
);

CREATE TABLE Flight (
   FlightNo INT,
   Airline INT,
   SourceAirport CHAR(3),
   DestAirport CHAR(3),
   FOREIGN KEY (SourceAirport) REFERENCES Airport (AirportCode),
   FOREIGN KEY (DestAirport) REFERENCES Airport (AirportCode),
   PRIMARY KEY (Flightno, Airline)
);
