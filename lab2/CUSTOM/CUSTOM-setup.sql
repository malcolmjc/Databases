DROP TABLE IF EXISTS Climbs;
DROP TABLE IF EXISTS Weather;

CREATE TABLE Weather (
   Date DATE PRIMARY KEY,
   BatteryVoltageAVG DECIMAL(20, 10),
   TemperatureAVG DECIMAL(20, 10),
   RelativeHumidityAVG DECIMAL(20, 10),
   WindSpeedDailyAVG DECIMAL(20, 10),
   WindDirectionAVG DECIMAL(20, 10),
   SolareRadiationAVG DECIMAL(20, 10)
);

CREATE TABLE Climbs (
   Id INT PRIMARY KEY,
   Date DATE,
   Route VARCHAR(255),
   Attempted INT,
   Succeeded INT,
   SuccessPercentage DECIMAL(15,13)
);
