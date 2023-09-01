create database lavadb;
use lavadb;

select * from dbo.machinefailure

--Column names
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'machinefailure';

--Counting Rows:
SELECT COUNT(*) FROM machinefailure; 
-- Retrieves the total number of rows in the table

--Summarizing Columns:
-- Retrieves the minimum, maximum, average, and sum of a numerical column

DECLARE @ColumnName NVARCHAR(100)
DECLARE @MinValue FLOAT, @MaxValue FLOAT, @AvgValue FLOAT, @SumValue FLOAT

DECLARE column_cursor CURSOR FOR
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'machinefailure' AND DATA_TYPE IN ('INT', 'FLOAT')

CREATE TABLE NumericalSummary (
    ColumnName NVARCHAR(100),
    MinValue FLOAT,
    MaxValue FLOAT,
    AvgValue FLOAT,
    SumValue FLOAT)

OPEN column_cursor    --Cursors are used to iterate over the rows returned by a query.
FETCH NEXT FROM column_cursor INTO @ColumnName   
--fetches the next row from the cursor into the variable @ColumnName. It retrieves the name of the next column in the result set.

WHILE @@FETCH_STATUS = 0              --starts a while loop that continues as long as there are more rows to fetch
BEGIN
    DECLARE @DynamicSQL NVARCHAR(MAX)
    SET @DynamicSQL = 'SELECT @MinValue = MIN(' + QUOTENAME(@ColumnName) + '), 
	                  @MaxValue = MAX(' + QUOTENAME(@ColumnName) + '), 
					  @AvgValue = AVG(' + QUOTENAME(@ColumnName) + '), 
					  @SumValue = SUM(' + QUOTENAME(@ColumnName) + ') FROM ' + QUOTENAME('machinefailure')
    
    EXEC sp_executesql @DynamicSQL, N'@MinValue FLOAT OUTPUT, 
	                                @MaxValue FLOAT OUTPUT, 
									@AvgValue FLOAT OUTPUT, 
									@SumValue FLOAT OUTPUT', 
									@MinValue = @MinValue OUTPUT, 
									@MaxValue = @MaxValue OUTPUT, 
									@AvgValue = @AvgValue OUTPUT, 
									@SumValue = @SumValue OUTPUT
    
    INSERT INTO NumericalSummary (ColumnName, MinValue, MaxValue, AvgValue, SumValue)
    VALUES (@ColumnName, @MinValue, @MaxValue, @AvgValue, @SumValue)

    FETCH NEXT FROM column_cursor INTO @ColumnName      --fetches the next row from the cursor into the variable @ColumnName
END

CLOSE column_cursor
DEALLOCATE column_cursor                     --deallocation of cursor

SELECT *
FROM NumericalSummary


--Filtering Data:
SELECT *
FROM machinefailure
where HyPr>100


SELECT *
FROM machinefailure
WHERE Downtime = 'No_Machine_Failure'; -- Applies a condition to filter the data,



-- To find the number of observations
select count(*) FROM machinefailure

--To find number of machines of a particular type
select (Machine_ID), count(*)
FROM machinefailure
group by (Machine_ID)

--To find number of machines on a particular shop floor
select (Assembly_Line_No), count(*)
FROM machinefailure
group by (Assembly_Line_No)
--Hence we can conclude all L1 machines are on shopfloor1, similarly for others
--OR
select (Machine_ID),(Assembly_Line_No), count(*)
FROM machinefailure
group by (Machine_ID),(Assembly_Line_No)

--To find number of machines that have failed
select Downtime, count(*)
FROM machinefailure
group by Downtime

--To change column names
exec sp_rename 'machinefailure.Hydraulic_Pressure_bar','HyPr','Column'
exec sp_rename 'machinefailure.Coolant_Pressure_bar','CooPr','Column'
exec sp_rename 'machinefailure.Air_System_Pressure_bar','AirPr','Column'
exec sp_rename 'machinefailure.Coolant_Temperature_C','CooTemp','Column'
exec sp_rename 'machinefailure.Hydraulic_Oil_Temperature_C','HyTemp','Column'
exec sp_rename 'machinefailure.Spindle_Bearing_Temperature_C','SpTemp','Column'
exec sp_rename 'machinefailure.Spindle_Vibration_µm','SpVib','Column'
exec sp_rename 'machinefailure.Tool_Vibration_µm','ToolVib','Column'
exec sp_rename 'machinefailure.Spindle_Speed_RPM','SpSpeed','Column'
exec sp_rename 'machinefailure.Voltage_volts','Volt','Column'
exec sp_rename 'machinefailure.Cutting_kN','Cutting','Column'






--Descriptive statistics
--Hydraulic_Pressure(bar)
--Minimum value: 
SELECT MIN([HyPr]) FROM machinefailure;
--Maximum value: 
SELECT MAX([HyPr]) FROM machinefailure;
--Mean/average: 
SELECT AVG([HyPr]) FROM machinefailure;
--Mode (most frequent value):
SELECT TOP 1 [HyPr], COUNT(*) AS max_count
FROM machinefailure
GROUP BY [HyPr]
ORDER BY max_count DESC;
--Median
WITH SortedData AS (
    SELECT [HyPr], ROW_NUMBER() OVER (ORDER BY [HyPr]) AS RowAsc,
                ROW_NUMBER() OVER (ORDER BY [HyPr] DESC) AS RowDesc
    FROM machinefailure
)

SELECT AVG([HyPr] * 1.0) AS Median
FROM SortedData
WHERE RowAsc = RowDesc OR RowAsc + 1 = RowDesc OR RowAsc = RowDesc + 1;






--Coolant_Pressure(bar)
SELECT MIN(CooPr) FROM machinefailure;

SELECT MAX(CooPr) FROM machinefailure;

SELECT AVG(CooPr) FROM machinefailure;

SELECT TOP 1 [CooPr], COUNT(*) AS count
FROM machinefailure
GROUP BY [CooPr]
ORDER BY count DESC;




--Air_System_Pressure(bar)
SELECT MIN([AirPr]) FROM machinefailure;

SELECT MAX([AirPr]) FROM machinefailure;

SELECT AVG([AirPr]) FROM machinefailure;

SELECT TOP 1 [AirPr], COUNT(*) AS count
FROM machinefailure
GROUP BY [AirPr]
ORDER BY count DESC;



--Coolant_Temperature(Â°C)
SELECT MIN([CooTemp]) FROM machinefailure;

SELECT MAX([CooTemp]) FROM machinefailure;

SELECT AVG([CooTemp]) FROM machinefailure;

SELECT TOP 1 [CooTemp], COUNT(*) AS count
FROM machinefailure
GROUP BY [CooTemp]
ORDER BY count DESC;




--Hydraulic_Oil_Temperature(Â°C)
SELECT MIN([HyTemp]) FROM machinefailure;

SELECT MAX([HyTemp]) FROM machinefailure;

SELECT AVG([HyTemp]) FROM machinefailure;

SELECT TOP 1 [HyTemp], COUNT(*) AS count
FROM machinefailure
GROUP BY [HyTemp]
ORDER BY count DESC;




--Spindle_Bearing_Temperature(Â°C)
SELECT MIN(SpTemp) FROM machinefailure;

SELECT MAX(SpTemp) FROM machinefailure;

SELECT AVG(SpTemp) FROM machinefailure;

SELECT TOP 1 [SpTemp], COUNT(*) AS count
FROM machinefailure
GROUP BY [SpTemp]
ORDER BY count DESC;




--Spindle_Vibration(Âµm)
SELECT MIN([SpVib]) FROM machinefailure;

SELECT MAX([SpVib]) FROM machinefailure;

SELECT AVG([SpVib]) FROM machinefailure;

SELECT TOP 1 [SpVib], COUNT(*) AS count
FROM machinefailure
GROUP BY [SpVib]
ORDER BY count DESC;





--Tool_Vibration(Âµm)
SELECT MIN([ToolVib]) FROM machinefailure;

SELECT MAX([ToolVib]) FROM machinefailure;

SELECT AVG([ToolVib]) FROM machinefailure;

SELECT TOP 1 [ToolVib], COUNT(*) AS count
FROM machinefailure
GROUP BY [ToolVib]
ORDER BY count DESC;






--Spindle_Speed(RPM)
SELECT MIN([SpSpeed]) FROM machinefailure;

SELECT MAX([SpSpeed]) FROM machinefailure;

SELECT AVG([SpSpeed]) FROM machinefailure;

SELECT TOP 1 [SpSpeed], COUNT(*) AS count
FROM machinefailure
GROUP BY [SpSpeed]
ORDER BY count DESC;






--Voltage(volts)
SELECT MIN([Volt]) FROM machinefailure;

SELECT MAX([Volt]) FROM machinefailure;

SELECT AVG([Volt]) FROM machinefailure;

SELECT TOP 1 [Volt], COUNT(*) AS count
FROM machinefailure
GROUP BY [Volt]
ORDER BY count DESC;



--Torque(Nm)
SELECT MIN([Torque_Nm]) FROM machinefailure;

SELECT MAX([Torque_Nm]) FROM machinefailure;

SELECT AVG([Torque_Nm]) FROM machinefailure;

SELECT TOP 1 [Torque_Nm], COUNT(*) AS count
FROM machinefailure
GROUP BY [Torque_Nm]
ORDER BY count DESC;





--Cutting(kN)
SELECT MIN([Cutting]) FROM machinefailure;

SELECT MAX([Cutting]) FROM machinefailure;

SELECT AVG([Cutting]) FROM machinefailure;

SELECT TOP 1 [Cutting], COUNT(*) AS count
FROM machinefailure
GROUP BY [Cutting]
ORDER BY count DESC;






--Downtime
SELECT MIN([Downtime]) FROM machinefailure;

SELECT MAX([Downtime]) FROM machinefailure;

SELECT AVG([Downtime]) FROM machinefailure;

SELECT TOP 1 [Downtime], COUNT(*) AS count
FROM machinefailure
GROUP BY [Downtime]
ORDER BY count DESC;







--To examine patterns between Hydraulic_Pressure(bar) and Coolant_Temperature(Â°C)
SELECT [HyPr], [CooPr], COUNT(*) AS Frequency
FROM machinefailure
GROUP BY [HyPr], [CooPr];

--Correlation Analysis:
SELECT CORREL(Variable1, Variable2) AS Correlation
FROM machinefailure
Group By [Variable1], [Variable2];



--To analyse patterns between Spindle_Vibration(µm) and Tool_Vibration(µm)
SELECT [SpVib], [ToolVib], COUNT(*) AS Frequency
FROM machinefailure
GROUP BY [SpVib], [ToolVib];


--Association between Spindle_Vibration(µm) and Tool_Vibration(µm)
SELECT [SpVib], [ToolVib], COUNT(*) AS Frequency
FROM machinefailure
GROUP BY [SpVib], [ToolVib];


--To examine whether higher hydraulic pressure is associated with higher cutting force
SELECT [HyPr], Cutting, COUNT(*) AS Frequency
FROM machinefailure
GROUP BY [HyPr], Cutting;


--To explore the relationship between coolant pressure and coolant temperature
SELECT [CooPr], [CooTemp], COUNT(*) AS Frequency
FROM machinefailure
GROUP BY [CooPr], [CooTemp];



--Analyzing the relationship between spindle speed and spindle vibration 
SELECT [SpSpeed], [SpVib], COUNT(*) AS Frequency
FROM machinefailure
GROUP BY [SpSpeed], [SpVib];





--To find null VALUES
SELECT * 
FROM machinefailure
WHERE (Date) is NULL OR (Machine_ID) is NULL or (Assembly_Line_No) is NULL 
--Hence no null values in these columns

--To fill missing values
--We use median if we have outliers, else mean to fill null values

--To find null VALUES
SELECT * 
FROM machinefailure
WHERE [HyPr] is NULL 

--To find outliers
--over here means all the data values
--let assume outliers to be outside 2 stdev from mean i.e. 95% accuracy

select * from 
(SELECT [Date], [Machine_ID], [HyPr],
(HyPr - avg(HyPr) over())/ stdev(HyPr) over() as zscore
FROM machinefailure) as zscore_table
where zscore>1.96 or zscore<-1.96
-- here we have used sub query
-- there are outliers so we use median
select avg(HyPr) 
from (select *,row_number() over (order by HyPr desc) as desc_HyPr,
row_number() over (order by HyPr asc) as asc_HyPr 
from machinefailure) as a
where asc_HyPr in (desc_HyPr,desc_HyPr+1,desc_HyPr-1)
Select coalesce(Hypr, 96.335616) from machinefailure



--To find null VALUES
SELECT * 
FROM machinefailure
WHERE [CooPr] is NULL 

--To find outliers
--let assume outliers to be outside 2 stdev from mean i.e. 95% accuracy
select *
from (SELECT [Date], [Machine_ID], [CooPr],
(CooPr - avg(CooPr) over())/ stdev(CooPr) over() as zscore
FROM machinefailure) as zscore_table
where zscore>1.96 or zscore<-1.96

-- extreme outliers
-- here we have used sub query
--there are outliers so we use median
select avg(CooPr) 
from (select *,row_number() over (order by CooPr desc) as desc_CooPr,
row_number() over (order by CooPr asc) as asc_CooPr 
from machinefailure) as a
where asc_CooPr in (desc_CooPr,desc_CooPr+1,desc_CooPr-1)
Select coalesce(CooPr, 4.925576181) from machinefailure






--To find null VALUES
SELECT * 
FROM machinefailure
WHERE [AirPr] is NULL 

--To find outliers
--over here means all the data values
--let assume outliers to be outside 2 stdev from mean i.e. 95% accuracy

select *
from (SELECT [Date], [Machine_ID], [AirPr],
(AirPr - avg(AirPr) over())/ stdev(AirPr) over() as zscore
FROM machinefailure) as zscore_table
where zscore>1.96 or zscore<-1.96
-- here we have used sub query
--there are outliers so we use median
select avg(AirPr) 
from (select *,row_number() over (order by AirPr desc) as desc_AirPr,
row_number() over (order by AirPr asc) as asc_AirPr 
from machinefailure) as a
where asc_AirPr in (desc_AirPr,desc_AirPr+1,desc_AirPr-1)
Select coalesce(AirPr, 6.5029807755) from machinefailure




--To find null VALUES
SELECT * 
FROM machinefailure
WHERE [CooTemp] is NULL 

--To find outliers
--let assume outliers to be outside 2 stdev from mean i.e. 95% accuracy

select *
from (SELECT [Date], [Machine_ID], [CooTemp],
(CooTemp - avg(CooTemp) over())/ stdev(CooTemp) over() as zscore
FROM machinefailure) as zscore_table
where zscore>1.96 or zscore<-1.96
-- here we have used sub query
--there are less an 10 outliers so we can use mean
--No proper way is to use mean in case of outliers
select avg(CooTemp) from machinefailure
Select coalesce(CooTemp, 18.5715434083602) from machinefailure





--To find null VALUES
SELECT * 
FROM machinefailure
WHERE [HyTemp] is NULL 

--To find outliers
--over here means all the data values
--let assume outliers to be outside 2 stdev from mean i.e. 95% accuracy

select *
from (SELECT [Date], [Machine_ID], [HyTemp],
(HyTemp - avg(HyTemp) over())/ stdev(HyTemp) over() as zscore
FROM machinefailure) as zscore_table
where zscore>1.96 or zscore<-1.96
-- here we have used sub query
--there are outliers so we use median
SELECT
(
(SELECT MAX(HyTemp) FROM
(SELECT TOP 50 PERCENT HyTemp FROM machinefailure ORDER BY HyTemp) AS BottomHalf)
+
(SELECT MIN(HyTemp) FROM
(SELECT TOP 50 PERCENT HyTemp FROM machinefailure ORDER BY HyTemp DESC) AS TopHalf)
) / 2 AS Median
Select coalesce(HyTemp, 47.6) from machinefailure


--To find null VALUES
SELECT * 
FROM machinefailure
WHERE [SpTemp] is NULL 

--To find outliers
--over here means all the data values
--let assume outliers to be outside 2 stdev from mean i.e. 95% accuracy

select *
from (SELECT [Date], [Machine_ID], [SpTemp],
(SpTemp - avg(SpTemp) over())/ stdev(SpTemp) over() as zscore
FROM machinefailure) as zscore_table
where zscore>1.96 or zscore<-1.96
-- here we have used sub query
--there are outliers so we use median
SELECT
(
(SELECT MAX(SpTemp) FROM
(SELECT TOP 50 PERCENT SpTemp FROM machinefailure ORDER BY SpTemp) AS BottomHalf)
+
(SELECT MIN(SpTemp) FROM
(SELECT TOP 50 PERCENT SpTemp FROM machinefailure ORDER BY SpTemp DESC) AS TopHalf)
) / 2 AS Median
Select coalesce(SpTemp, 35.1) from machinefailure






--To find null VALUES
SELECT * 
FROM machinefailure
WHERE [SpVib] is NULL 

--To find outliers
--over here means all the data values
--let assume outliers to be outside 2 stdev from mean i.e. 95% accuracy

select *
from (SELECT [Date], [Machine_ID], [SpVib],
(SpVib - avg(SpVib) over())/ stdev(SpVib) over() as zscore
FROM machinefailure) as zscore_table
where zscore>1.96 or zscore<-1.96
-- here we have used sub query
--there are outliers so we use median
select avg(SpVib) 
from (select *,row_number() over (order by SpVib desc) as desc_SpVib,
row_number() over (order by SpVib asc) as asc_SpVib 
from machinefailure) as a
where asc_SpVib in (desc_SpVib,desc_SpVib+1,desc_SpVib-1)
Select coalesce(SpVib, 1.007) from machinefailure









--To find null VALUES
SELECT * 
FROM machinefailure
WHERE ToolVib is NULL 

--To find outliers
--over here means all the data values
--let assume outliers to be outside 2 stdev from mean i.e. 95% accuracy

select *
from (SELECT [Date], [Machine_ID], [ToolVib],
(ToolVib - avg(ToolVib) over())/ stdev(ToolVib) over() as zscore
FROM machinefailure) as zscore_table
where zscore>1.96 or zscore<-1.96
-- here we have used sub query
--there are outliers so we use median
select avg(ToolVib) 
from (select *,row_number() over (order by ToolVib desc) as desc_ToolVib,
row_number() over (order by ToolVib asc) as asc_ToolVib 
from machinefailure) as a
where asc_ToolVib in (desc_ToolVib,desc_ToolVib+1,desc_ToolVib-1)
Select coalesce(ToolVib, 25.4025) from machinefailure







--To find null VALUES
SELECT * 
FROM machinefailure
WHERE [SpSpeed] is NULL 

--To find outliers
--over here means all the data values
--let assume outliers to be outside 2 stdev from mean i.e. 95% accuracy

select *
from (SELECT [Date], [Machine_ID], [SpSpeed],
(SpSpeed - avg(SpSpeed) over())/ stdev(SpSpeed) over() as zscore
FROM machinefailure) as zscore_table
where zscore>1.96 or zscore<-1.96
-- here we have used sub query
--there are outliers so we use median
select avg(SpSpeed) 
from (select *,row_number() over (order by SpSpeed desc) as desc_SpSpeed,
row_number() over (order by SpSpeed asc) as asc_SpSpeed
from machinefailure) as a
where asc_SpSpeed in (desc_SpSpeed,desc_SpSpeed+1,desc_SpSpeed-1)
Select coalesce(SpSpeed, 20127) from machinefailure







--To find null VALUES
SELECT * 
FROM machinefailure
WHERE [Volt] is NULL 

--To find outliers
--over here means all the data values
--let assume outliers to be outside 2 stdev from mean i.e. 95% accuracy

select *
from (SELECT [Date], [Machine_ID], [Volt],
(Volt - avg(Volt) over())/ stdev(Volt) over() as zscore
FROM machinefailure) as zscore_table
where zscore>1.96 or zscore<-1.96
-- here we have used sub query
--there are outliers so we use median
SELECT
(
(SELECT MAX(Volt) FROM
(SELECT TOP 50 PERCENT Volt FROM machinefailure ORDER BY Volt) AS BottomHalf)
+
(SELECT MIN(Volt) FROM
(SELECT TOP 50 PERCENT Volt FROM machinefailure ORDER BY Volt DESC) AS TopHalf)
) / 2 AS Median
Select coalesce(Volt, 349) from machinefailure








--To find null VALUES
SELECT * 
FROM machinefailure
WHERE [Torque_Nm] is NULL 

--To find outliers
--over here means all the data values
--let assume outliers to be outside 2 stdev from mean i.e. 95% accuracy

select *
from (SELECT [Date], [Machine_ID], [Torque_Nm],
(Torque_Nm - avg(Torque_Nm) over())/ stdev(Torque_Nm) over() as zscore
FROM machinefailure) as zscore_table
where zscore>1.96 or zscore<-1.96
-- here we have used sub query
--there are outliers so we use median
select avg(Torque_Nm) 
from (select *,row_number() over (order by Torque_Nm desc) as desc_Torque_Nm,
row_number() over (order by Torque_Nm asc) as asc_Torque_Nm
from machinefailure) as a
where asc_Torque_Nm in (desc_Torque_Nm,desc_Torque_Nm+1,desc_Torque_Nm-1)
Select coalesce(Torque_Nm, 24.60581383) from machinefailure








--To find null VALUES
SELECT * 
FROM machinefailure
WHERE [Cutting] is NULL 

--To find outliers
--over here means all the data values
--let assume outliers to be outside 2 stdev from mean i.e. 95% accuracy

select *
from (SELECT [Date], [Machine_ID], [Cutting],
(Cutting - avg(Cutting) over())/ stdev(Cutting) over() as zscore
FROM machinefailure) as zscore_table
where zscore>1.96 or zscore<-1.96
-- here we have used sub query
--there are no outliers so we use mean
select avg(Cutting) from machinefailure
Select coalesce(Cutting, 2.78313277176093) from machinefailure







--To find null VALUES
SELECT * 
FROM machinefailure
WHERE [Downtime] is NULL 
--No null values









-- Create a new table to store the cleaned data
CREATE TABLE machinefailure_cleaned (
  [Date] DATETIME2(7),
  [Machine_ID] NVARCHAR(50),
  [Assembly_Line_No] NVARCHAR(50),
  [HyPr] FLOAT,
  [CooPr] FLOAT,
  [AirPr] FLOAT,
  [CooTemp] FLOAT,
  [HyTemp] FLOAT,
  [SpTemp] FLOAT,
  [SpVib] FLOAT,
  [ToolVib] FLOAT,
  [SpSpeed] FLOAT,
  [Volt] FLOAT,
  [Torque_Nm] FLOAT,
  [Cutting] FLOAT,
  [Downtime] NVARCHAR(50)
);

-- Insert the cleaned data into the new table
INSERT INTO machinefailure_cleaned ([Date], [Machine_ID], [Assembly_Line_No], 
                                    [HyPr], [CooPr], [AirPr], [CooTemp], [HyTemp], 
									[SpTemp], [SpVib], [ToolVib], [SpSpeed], [Volt], 
									[Torque_Nm], [Cutting], [Downtime])
SELECT [Date], [Machine_ID], [Assembly_Line_No], COALESCE([HyPr], 96.335616), COALESCE([CooPr], 4.925576181), 
               COALESCE([AirPr], 6.5029807755), COALESCE([CooTemp], 18.5715434083602), COALESCE([HyTemp], 47.6), 
			   COALESCE([SpTemp],35.1), COALESCE([SpVib], 1.007), COALESCE([ToolVib], 25.4025), COALESCE([SpSpeed], 20127), 
			   COALESCE([Volt], 349), COALESCE([Torque_Nm], 24.60581383), COALESCE([Cutting], 2.78313277176093), [Downtime]
FROM machinefailure;

select * from machinefailure_cleaned

