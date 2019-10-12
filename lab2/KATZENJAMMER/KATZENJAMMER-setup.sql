CREATE TABLE Albums (
   AId INT PRIMARY KEY,
   Title VARCHAR(255) UNIQUE,
   Year INT,
   Label VARCHAR(255),
   Type VARCHAR(255)
);

CREATE TABLE Band (
   Id INT PRIMARY KEY,
   FirstName VARCHAR(255),
   LastName VARCHAR(255)
);

CREATE TABLE Songs (
   SongId INT PRIMARY KEY,
   Title VARCHAR(255) UNIQUE
);

CREATE TABLE Instruments (
   SongId INT,
   BandMateId INT,
   Instrument VARCHAR(255),
   FOREIGN KEY (SongId) REFERENCES Song (SongId),
   FOREIGN KEY (BandMateId) REFERENCES Band (Id),
   PRIMARY KEY (SongId, BandMateId, Instrument)
);

CREATE TABLE Performance (
   SongId INT,
   BandMateId INT,
   StagePosition VARCHAR(255),
   FOREIGN KEY (SongId) REFERENCES Song (SongId),
   FOREIGN KEY (BandMateId) REFERENCES Band (Id),
   PRIMARY KEY (SongId, BandMateId)
);

CREATE TABLE TrackLists (
   AlbumId INT,
   Position INT,
   SongId INT,
   FOREIGN KEY (AlbumId) REFERENCES Album (AId),
   FOREIGN KEY (SongId) REFERENCES Song (SongId),
   PRIMARY KEY (AlbumId, Position, SongId)
);

CREATE TABLE Vocals (
   SongId INT,
   BandMate INT,
   Type VARCHAR(255),
   FOREIGN KEY (SongId) REFERENCES Song (SongId),
   FOREIGN KEY (BandMate) REFERENCES Band (Id),
   PRIMARY KEY (SongId, BandMate, Type)
);
