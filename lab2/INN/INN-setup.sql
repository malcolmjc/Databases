DROP TABLE IF EXISTS Reservations;
DROP TABLE IF EXISTS Rooms;

CREATE TABLE Rooms (
   RoomId CHAR(3) PRIMARY KEY,
   roomName VARCHAR(255),
   beds INT,
   bedType VARCHAR(255),
   maxOccupancy INT,
   basePrice INT,
   decor VARCHAR(255)
);

CREATE TABLE Reservations (
   Code INT PRIMARY KEY,
   Room CHAR(3),
   CheckIn DATE,
   CheckOut DATE,
   Rate DECIMAL(7, 2),
   LastName VARCHAR(255),
   FirstName VARCHAR(255),
   Adults INT CHECK(Adults > 0),
   Kids INT,
   FOREIGN KEY (Room) REFERENCES Rooms (RoomId)
);
