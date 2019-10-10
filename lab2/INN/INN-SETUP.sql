CREATE TABLE Room (
   RoomId CHAR(3) PRIMARY KEY,
   roomName VARCHAR(255),
   beds INT,
   bedType VARCHAR(255),
   maxOccupancy INT,
   basePrice INT,
   decor VARCHAR(255)
);

CREATE TABLE Reservation (
   Code INT PRIMARY KEY,
   Room CHAR(3) FOREIGN KEY,
   CheckIn DATE,
   CheckOut DATE,
   Rate DECIMAL(7, 2),
   LastName VARCHAR(255),
   FirstName VARCHAR(255),
   Adults INT CHECK(Adults > 0),
   Kids INT
);
