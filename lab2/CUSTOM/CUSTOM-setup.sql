DROP TABLE IF EXISTS Weather;
DROP TABLE IF EXISTS Climbs;

CREATE TABLE Weather (
   Date DATE PRIMARY KEY,
   BatteryVoltageAVG DECIMAL(35, 30),
   TemperatureAVG DECIMAL(35, 30),
   RelativeHumidityAVG DECIMAL(35, 30),
   WindSpeedDailyAVG DECIMAL(35, 30),
   WindDirectionAVG DECIMAL(35, 30),
   SolareRadiationAVG DECIMAL(35, 30)
);

CREATE TABLE Climbs (
   Id INT PRIMARY KEY,
   Date DATE,
   Attempted INT,
   Succeeded INT,
   SuccessPercentage DECIMAL(20,19)
   FOREIGN KEY (Date) REFERENCES Weather (Date)
);
