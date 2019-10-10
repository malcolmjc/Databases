CREATE TABLE Album (
   AId INT PRIMARY KEY,
   Title VARCHAR(255),
   Year INT,
   Label VARCHAR(255),
   Type VARCHAR(255)
);

CREATE TABLE Band (
   Id INT PRIMARY KEY,
   FirstName VARCHAR(255),
   LastName VARCHAR(255)
);

CREATE TABLE Song (
   SongId INT PRIMARY KEY,
   Title VARCHAR(255)
);

CREATE TABLE Instrument (
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

CREATE TABLE TrackList (
   AlbumId INT,
   Position INT,
   SongId INT,
   FOREIGN KEY (AlbumId) REFERENCES Album (AId),
   FOREIGN KEY (SongId) REFERENCES Song (SongId),
   PRIMARY KEY (AlbumId, Position, SongId)
);

CREATE TABLE Vocal (
   SongId INT,
   BandMate INT,
   Type VARCHAR(255),
   FOREIGN KEY (SongId) REFERENCES Song (SongId),
   FOREIGN KEY (BandMate) REFERENCES Band (Id),
   PRIMARY KEY (SongId, BandMate, Type)
);