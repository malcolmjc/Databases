DROP TABLE IF EXISTS Vocals;
DROP TABLE IF EXISTS Instruments;
DROP TABLE IF EXISTS Performance;
DROP TABLE IF EXISTS Tracklists;
DROP TABLE IF EXISTS Albums;
DROP TABLE IF EXISTS Band;
DROP TABLE IF EXISTS Songs;

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
   Id INT PRIMARY KEY,
   Title VARCHAR(255) UNIQUE
);

CREATE TABLE Instruments (
   SongId INT,
   Bandmate INT,
   Instrument VARCHAR(255),
   FOREIGN KEY (SongId) REFERENCES Songs (Id),
   FOREIGN KEY (Bandmate) REFERENCES Band (Id),
   PRIMARY KEY (SongId, Bandmate, Instrument)
);

CREATE TABLE Performance (
   SongId INT,
   Bandmate INT,
   StagePosition VARCHAR(255),
   FOREIGN KEY (SongId) REFERENCES Songs (Id),
   FOREIGN KEY (Bandmate) REFERENCES Band (Id),
   PRIMARY KEY (SongId, Bandmate)
);

CREATE TABLE Tracklists (
   AlbumId INT,
   Position INT,
   SongId INT,
   FOREIGN KEY (AlbumId) REFERENCES Albums (AId),
   FOREIGN KEY (SongId) REFERENCES Songs (Id),
   PRIMARY KEY (AlbumId, Position, SongId)
);

CREATE TABLE Vocals (
   SongId INT,
   Bandmate INT,
   Type VARCHAR(255),
   FOREIGN KEY (SongId) REFERENCES Songs (Id),
   FOREIGN KEY (Bandmate) REFERENCES Band (Id),
   PRIMARY KEY (SongId, Bandmate, Type)
);
