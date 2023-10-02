----------Tasks on WHERE, GROUP BY, HAVING, ORDER BY clauses----------
-- Task: 1 (Serge I: 2002-09-30)
-- Find model number, speed, and hard drive size for all PCs under $500. Output: model, speed and hd
SELECT DISTINCT Model, Speed, HD
FROM PC
WHERE Price < 500


-- Task: 2 (Serge I: 2002-09-21)
-- Find printer manufacturers. Withdraw: maker
SELECT DISTINCT Maker
FROM Product
WHERE Type = 'printer'


-- Task: 3 (Serge I: 2002-09-30)
-- Find the model number, memory capacity, and screen sizes of PC notepads priced over $1,000.
SELECT Model, Ram, Screen
FROM Laptop
WHERE Price > 1000


-- Task: 4 (Serge I: 2002-09-21)
-- Find all entries in the Printer table for color printers.
SELECT *
FROM Printer
WHERE Color = 'y'


-- Task: 5 (Serge I: 2002-09-30)
-- Find the model number, speed and hard drive size of PCs that have 12x or 24x CD and are priced under $600.
SELECT Model, Speed, Hd
FROM PC
WHERE Price < 600
AND (Cd = '12x' OR Cd = '24x')


-- Task: 31 (Serge I: 2002-10-22)
-- For classes of ships with gun calibers of at least 16 inches, indicate the class and country.
SELECT Class, Country
FROM Classes
WHERE Bore >= 16


-- Task: 33 (Serge I: 2002-11-02)
-- List the ships sunk in the North Atlantic). Conclusion: ship.
SELECT Shipbattle
FROM Outcomes
WHERE Battle = 'North Atlantic'
AND Result = 'sunk'


-- Task: 11 (Serge I: 2002-11-02)
-- Find the average PC speed.
SELECT avg(Speed)
FROM PC


-- Task: 12 (Serge I: 2002-11-02)
-- Find the average speed of PC notepads priced over $1,000.
SELECT avg(Speed)
FROM Laptop
WHERE Price > 1000


-- Task: 22 (Serge I: 2003-02-13)
-- For each PC speed value,
-- exceeding 600 MHz, determine the average price of a PC with the same speed. Output: speed, average price.
SELECT Speed, [average price] = avg(Price)
FROM PC
WHERE Speed > 600
GROUP BY Speed


-- Task: 15 (Serge I: 2003-02-03)
-- Find the sizes of hard drives that match on two or more PCs. Withdraw: HD
SELECT Hd = Hd
FROM PC
GROUP BY HD
HAVING count(*) >= 2


-- Task: 20 (Serge I: 2003-02-13)
-- Find manufacturers that make at least three different PC models. Output: Maker, number of PC models.
SELECT Maker, [number of PC models] = count(*)
FROM Product
WHERE Type = 'PC'
GROUP BY Maker
HAVING count(Model) >= 3


-- Task: 40 (Serge I: 2012-04-20)
-- Find manufacturers who produce more than one model, all of which are produced
-- Manufacturer models are products of the same type.
-- Output: maker, type

SELECT Maker = max(Maker), Type
FROM Product
GROUP BY Maker, Type
HAVING count(DISTINCT Type) = 1
AND count(Model) > 1


-- Task: 90 (Serge I: 2012-05-04)
-- Print all rows from the Product table except the three rows with the lowest model numbers and the three rows with the highest model numbers.
SELECT *
FROM Product
WHERE Model NOT IN (SELECT TOP (3) Model
FROM Product
ORDER BY Model)

AND Model NOT IN (SELECT TOP (3) Model
FROM Product
ORDER BY Model DESC);


-- Task: 42 (Serge I: 2002-11-05)
-- Find the names of ships sunk in battles and the name of the battle in which they were sunk.
SELECT Ship, Battle
FROM Outcomes
WHERE Result = 'sunk'


-- Task: 38 (Serge I: 2003-02-19)
-- Find countries that have ever had conventional battleship classes ('bb') and have ever had cruiser classes ('bc').
SELECT Country
FROM Classes
GROUP BY Country
HAVING count(DISTINCT Type) = 2


-- Task: 53 (Serge I: 2002-11-05)
-- Determine the average number of guns for classes of battleships.
-- Get the result accurate to 2 decimal places.

SELECT cast(avg(cast(Numguns AS NUMERIC(5, 2))) AS NUMERIC(5, 2)) AS 'Avg-numGuns'
FROM Classes
WHERE Type = 'bb'


-- Task: 86 (Serge I: 2012-04-20)
-- For each manufacturer, list in alphabetical order, separated by "/", all types of products it produces.
-- Output: maker, list of product types
SELECT Maker
CASE
WHEN count(DISTINCT Type) = 3
THEN 'Laptop/PC/Printer'
WHEN count(DISTINCT Type) = 1
THEN max(Type)
ELSE min(Type) + '/' + max(Type)
END
FROM Product
GROUP BY Maker


-- Task: 85 (Serge I: 2012-03-16)
-- Find manufacturers who produce only printers or only PCs.
-- At the same time, the required PC manufacturers must produce at least 3 models.
SELECT DISTINCT Maker
FROM Product
GROUP BY Maker
HAVING count(DISTINCT Type) = 1
AND ((min(Type) = 'PC' AND count(Model) >= 3) OR min(Type) = 'Printer')


-- Task: 24 (Serge I: 2003-02-03)
-- List the model numbers of any type that have the highest price across all products in the database.

;
WITH Sql_Data(Price, Model) AS (
SELECT Price, Model

FROM PC
UNION ALL
SELECT Price, Model
FROM Laptop
UNION ALL
SELECT Price, Model
FROM Printer
)

SELECT DISTINCT Model
FROM Sql_Data
WHERE Price = (SELECT TOP (1) Price
FROM Sql_Data
ORDER BY Price DESC)


-- Task: 18 (Serge I: 2003-02-03)
-- Find manufacturers of the cheapest color printers. Output: maker, price
SELECT DISTINCT Product.Maker, Printer.Price

FROM Product,
Printer

WHERE Product.Model = Printer.Model

AND Printer.Price = (
SELECT min(Price)
FROM Printer

WHERE Printer.Color = 'y'
)
AND Printer.Color = 'y'


-- Task: 77 (Serge I: 2003-04-09)
-- Determine the days when the maximum number of flights from
-- Rostov ('Rostov'). Output: number of flights, date.
SELECT TOP (1) WITH TIES Number = count(DISTINCT T.Trip_No), Date
FROM Trip AS T
JOIN Pass_In_Trip AS P ON P.Trip_No = T.Trip_No
WHERE T.Town_From = 'Rostov'
GROUP BY Date
ORDER BY Number DESC


-- Task: 97 (qwrqwr: 2013-02-15)
-- Select from the Laptop table those rows for which the following condition is true:
-- values from the speed, ram, price, screen columns can be arranged in such a way that each subsequent value is 2 times or more greater than the previous one.
-- Note: all known laptop characteristics are greater than zero.
-- Output: code, speed, ram, price, screen.
SELECT Code, Speed, Ram, Price, Screen
FROM Laptop
WHERE (Speed >= 2 * Ram OR Speed <= Ram / 2.0)
AND (Speed >= 2 * Price OR Speed <= Price / 2)
AND (Speed >= 2 * Screen OR Speed <= Screen / 2.0)
AND (Ram >= 2 * Price OR Ram <= Price / 2.0)
AND (Ram >= 2 * Screen OR Ram <= Screen / 2.0)
AND (Price >= 2 * Screen OR Price <= Screen / 2.0)


----------Control on clauses WHERE, GROUP BY, HAVING, ORDER BY----------
--Test question 1.
-- Run a job against the AdventureWorks2019 database.
-- For each product in the Production.Product table, display its name and the number of spaces in this product name.
-- For example, for the product "Mountain-100 Black, 44" two spaces are expected
USE Adventureworks2019
SELECT Name, Spaces = len(Name) - len(replace(Name, ' ', ''))
FROM Production.Product


--Test question 2.
--Run a job against the AdventureWorks2019 database.
--For each product in the Production.Product table, display its name and title with all numbers removed.
--For example, for the product "Mountain-100 Black, 44" the expected value is "Mountain-Black, "
USE Adventureworks2019
SELECT Name
[Non-numeric Name] = (replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(Name, '1', ''), '2', ''), '3',
''), '4', ''), '5', ''), '6', ''), '7', ''), '8',
''), '9', ''), '0', ''))
FROM Production.Product


--Security question 3.
--Run a job against the AdventureWorks2019 database.
--For each product in the Production.Product table, display its name and the number of vowels in the name.
USE Adventureworks2019
SELECT Name
[Vowel Count] = len(Name) - len(
replace(
replace(
replace(
replace(
replace(
lower(Name), 'a', ''), 'e', ''), 'i', ''), 'o', ''), 'u', ''))
FROM Production.Product


--Test question 6.
--Run a job against the AdventureWorks2019 database.
--Based on data from the SellStartDate column of the Production.Product table, determine whether the year is a leap year.
--Propose at least three algorithms for solving the problem.
SELECT Sellstartdate,
Year = year(Sellstartdate),
CASE
WHEN year(Sellstartdate) % 4 = 0 AND year(Sellstartdate) % 100 != 0
THEN 'Leap'
WHEN year(Sellstartdate) % 400 = 0
THEN 'Leap'
ELSE 'Not leap'
END
FROM Production.Product

SELECT Sellstartdate,
Year = year(Sellstartdate),
iif(datepart(DAYOFYEAR, datefromparts(year(Sellstartdate), 12, 31)) = 366, 'Leap', 'Not leap')
FROM Production.Product

SELECT Sellstartdate,
Year = year(Sellstartdate),
iif(day(eomonth(dateadd(DAY, 31, dateadd(YEAR, year(Sellstartdate) - 1900, 0)))) = 29, 'Leap', 'Not leap')
FROM Production.Product


----------Tasks on operators over data sets, table joins (JOIN) and subqueries----------
USE [sql-ex]
--Task: 8 (Serge I: 2003-02-03)
--Find a manufacturer that makes PCs, but not PC notebooks.

SELECT Maker
FROM Product
WHERE Type = 'pc'
EXCEPT
SELECT Maker
FROM Product
WHERE Type = 'laptop'

--Task: 24 (Serge I: 2003-02-03)
--List the model numbers of any type that have the highest price across all products in the database.

SELECT TOP (1) WITH TIES Model
FROM (SELECT Model, Price
FROM Laptop
UNION
SELECT Model, Price
FROM PC
UNION
SELECT Model, Price
FROM Printer) AS A
ORDER BY Price DESC

--Task: 30 (Serge I: 2003-02-14)
--Assuming that the receipt and expenditure of money at each collection point is recorded an arbitrary number of times (the primary key in the tables is the code column), it is required to obtain a table in which each item for each date of operations will correspond to one row.
--Output: point, date, total point consumption per day (out), total point receipt per day (inc). Missing values are considered NULL.

;
WITH T1 AS (
SELECT Point, Date, Out = NULL, Inc
FROM Income
UNION ALL
SELECT Point, Date, Out, Inc = NULL
FROM Outcome
)
SELECT Point, Date, Out = sum(Out), Inc = sum(Inc)
FROM T1
GROUP BY Point, Date

--Task: 6 (Serge I: 2002-10-28)
--For each manufacturer producing PC notepads with a hard drive capacity of at least 10 GB, find the speeds of such PC notepads. Conclusion: manufacturer, speed.

SELECT DISTINCT P.Maker, Lap.Speed
FROM Product AS P
INNER JOIN Laptop AS Lap ON P.Model = Lap.Model
WHERE Hd >= 10

--Task: 9 (Serge I: 2002-11-02)
--Find PC manufacturers with at least 450 MHz processor. Withdraw: Maker

SELECT DISTINCT P.Maker
FROM Product AS P
INNER JOIN Pc ON P.Model = Pc.Model
WHERE Speed >= 450

--Task: 13 (Serge I: 2002-11-02)
--Find the average speed of PCs manufactured by manufacturer A.

SELECT Avg = avg(Pc.Speed)
FROM Product AS P
INNER JOIN Pc ON P.Model = Pc.Model
WHERE P.Maker = 'A'

--Task: 16 (Serge I: 2003-02-03)
--Find pairs of PC models that have the same speed and RAM. As a result, each pair is specified only once, i.e. (i,j), but not (j,i), Output order: higher number model, lower number model, speed and RAM.

SELECT DISTINCT T1.Model, T2.Model, T1.Speed, T1.Ram
FROM Pc AS T1
INNER JOIN Pc AS T2 ON T1.Speed = T2.Speed AND T1.Ram = T2.Ram AND T1.Model > T2.Model

--Task: 19 (Serge I: 2003-02-13)
--For each manufacturer that has models in the Laptop table, find the average screen size of the notebook PCs it produces.
--Output: maker, medium screen size.

SELECT Maker, Avgscr = avg(Laptop.Screen)
FROM Product
JOIN Laptop ON Product.Model = Laptop.Model
GROUP BY Maker

--Task: 23 (Serge I: 2003-02-14)
--Find manufacturers who produce both PCs
--with a speed of at least 750 MHz, and PC notebooks with a speed of at least 750 MHz.
--Output: Maker

SELECT Maker
FROM (SELECT Model
FROM PC
WHERE Speed >= 750) AS Pc750(Pc_Model)
JOIN
Product ON Product.Model = Pc750.Pc_Model
INTERSECT
SELECT Maker
FROM (SELECT Model
FROM Laptop
WHERE Speed >= 750) AS Lt750(Lt_Model)
JOIN
Product ON Product.Model = Lt750.Lt_Model

--Task: 29 (Serge I: 2003-02-14)
--Assuming that the receipt and expenditure of money at each collection point is recorded no more than once a day [i.e. primary key (item, date)], write a query with output data (item, date, receipt, expense). Use Income_o and Outcome_o tables.

SELECT Point = coalesce(O.Point, I.Point), Date = coalesce(O.Date, I.Date), I.Inc, O.Out
FROM Outcome_O AS O
FULL JOIN Income_O AS I ON I.Point = O.Point AND O.Date = I.Date

--Task: 10 (Serge I: 2002-09-23)
--Find the printer models with the highest price. Output: model, price

SELECT Model, Price
FROM Printer
WHERE Price = (SELECT max(Price)
FROM Printer)
ORDER BY Price DESC

--Task: 17 (Serge I: 2003-02-03)
--Find notepad PC models whose speed is less than the speed of each PC.
--Output: type, model, speed

SELECT DISTINCT P.Type, L.Model, L.Speed
FROM Laptop AS L
INNER JOIN Product AS P ON L.Model = P.Model
WHERE Speed < ALL (SELECT Speed
FROM PC)

--Task: 25 (Serge I: 2003-02-14)
--Find the printer manufacturers that make the PC with the least amount of RAM and the fastest processor among all the PCs with the least amount of RAM. Withdraw: Maker

SELECT DISTINCT Maker
FROM Product
WHERE Model IN (
SELECT Model
FROM PC
WHERE Ram = (
SELECT min(Ram)
FROM PC
)
AND Speed = (
SELECT max(Speed)
FROM PC
WHERE Ram = (
SELECT min(Ram)
FROM PC
)
)
)
AND Maker IN (
SELECT Maker
FROM Product
WHERE Type = 'printer'
)

--Task: 27 (Serge I: 2003-02-03)
--Find the average PC disk size for each manufacturer that produces printers. Output: maker, medium size HD.

SELECT Product.Maker, avg(Pc.Hd)
FROM PC,
Product
WHERE Product.Model = Pc.Model
AND Product.Maker IN (SELECT DISTINCT Maker
FROM Product
WHERE Product.Type = 'printer')
GROUP BY Maker

--Task: 34 (Serge I: 2002-11-04)
--According to the Washington International Treaty of early 1922, it was prohibited to build battleships with a displacement of more than 35 thousand tons. Indicate the ships that violated this agreement (consider only ships with a known year of launch). Display the names of the ships.

SELECT Name
FROM Classes
Ships
WHERE Launched >= 1922
AND Displacement > 35000
AND Type = 'bb'
AND Ships.Class = Classes.Class

--HomeWork

--Task: 38 (Serge I: 2003-02-19)
--Find countries that have ever had conventional battleship classes ('bb') and have ever had cruiser classes ('bc').

SELECT Country
FROM Classes
WHERE Type = 'bb'
GROUP BY Classes.Country
INTERSECT
SELECT Country
FROM Classes
WHERE Type = 'bc'
GROUP BY Classes.Country

--Task: 44 (Serge I: 2002-12-04)
--Find the names of all ships in the database starting with the letter R.

SELECT Name
FROM Ships
WHERE Name LIKE 'R%'
UNION
SELECT O.Ship
FROM Outcomes AS O
WHERE O.Ship LIKE 'R%'

--Task: 45 (Serge I: 2002-12-04)
--Find the names of all ships in the database that consist of three or more words (for example, King George V).
--Assume that words in names are separated by single spaces, and there are no trailing spaces.

SELECT Name
FROM Ships
WHERE Name LIKE '% % %'
UNION
SELECT O.Ship
FROM Outcomes AS O
WHERE O.Ship LIKE '% % %'

--Task: 73 (Serge I: 2009-04-17)
--For each country, determine the battles in which the ships of this country did not participate.
--Conclusion: country, battle

SELECT DISTINCT C.Country, B.Name
FROM Battles B,
Classes C
EXCEPT
SELECT C.Country, O.Battle
FROM Outcomes O
LEFT JOIN Ships S ON S.Name = O.Ship
LEFT JOIN Classes C ON O.Ship = C.Class OR S.Class = C.Class
WHERE C.Country IS NOT NULL
GROUP BY C.Country, O.Battle

--Task: 90 (Serge I: 2012-05-04)
--Display all rows from the Product table except the three rows with the lowest model numbers and the three rows with the highest model numbers.

SELECT *
FROM Product
ORDER BY Model
OFFSET 3 ROWS FETCH NEXT (SELECT count(*)
FROM Product) - 3 - 3 ROWS ONLY

--second

SELECT *
FROM Product
WHERE Model NOT IN (
SELECT Model
FROM (
SELECT TOP 3 Model
FROM Product
ORDER BY Model
UNION
SELECT TOP 3 Model
FROM Product
ORDER BY Model DESC) Asd)

--Task: 49 (Serge I: 2003-02-17)
--Find the names of ships with 16-inch guns (take into account the ships from the Outcomes table).

SELECT Ship
FROM(
SELECT Ship, Ship AS Class
FROM Outcomes
UNION
SELECT Name, Class
FROM Ships
) AS S
JOIN Classes C ON C.Class = S.Class
WHERE Bore = 16

--Task: 50 (Serge I: 2002-11-05)
--Find battles that involved Kongo class ships from the Ships table.

SELECT DISTINCT B.Name
FROM Battles B
JOIN Outcomes O ON B.Name = O.Battle
WHERE O.Ship IN
(SELECT Name
FROM Ships
WHERE Class = 'Kongo')

--Task: 52 (qwrqwr: 2010-04-23)
--Determine the names of all ships from the Ships table that can be a Japanese battleship,
--having a number of main guns of at least nine, a caliber of guns of less than 19 inches and a displacement of no more than 65 thousand tons

SELECT S.Name
FROM Ships AS S
JOIN Classes C ON C.Class = S.Class
WHERE (C.Type = 'bb' OR C.Type IS NULL)
AND (C.Country = 'Japan' OR C.Country IS NULL)
AND (C.Numguns >= 9 OR C.Numguns IS NULL)
AND (C.Bore < 19.0 OR C.Bore IS NULL)
AND (C.Displacement <= 65000 OR C.Displacement IS NULL)

--Task: 55 (Serge I: 2003-02-16)
--For each class, determine the year when the first ship of this class was launched. If the launching year of the lead ship is unknown, determine the minimum launching year for ships of this class. Output: class, year.

SELECT Cl.Class, min(Sh.Launched)
FROM Classes Cl
LEFT JOIN Ships Sh ON Sh.Class = Cl.Class
GROUP BY Cl.Class

--Task: 56 (Serge I: 2003-02-16)
--For each class, determine the number of ships of this class sunk in battles. Output: class and number of sunk ships.

SELECT C.Class, count(T.Ship)
FROM Classes AS C
LEFT JOIN (
SELECT O.Ship, S.Class
FROM Outcomes AS O
LEFT JOIN Ships AS S ON S.Name = O.Ship
WHERE O.Result = 'sunk'
) AS T ON C.Class = T.Ship OR C.Class = T.Class
GROUP BY C.Class

--Task: 66 (Serge I: 2003-04-09)
--For all days in the interval from 01/04/2003 to 07/04/2003, determine the number of flights from Rostov.
--Output: date, number of flights

;
WITH T1 AS
(SELECT Dataa = cast('2003-04-01' AS DATETIME)
UNION ALL
SELECT dateadd(DAY, 1, Dataa)
FROM T1
WHERE Dataa < '2003-04-07'
)
SELECT T1.Dataa, count(DISTINCT T.Trip_No)
FROM T1
LEFT JOIN Pass_In_Trip AS P ON P.Date = T1.Dataa
LEFT JOIN Trip AS T ON T.Trip_No = P.Trip_No AND T.Town_From = 'Rostov'
GROUP BY T1.Dataa

--Task: 71 (Serge I: 2008-02-23)
--Find those PC manufacturers whose all PC models are available in the PC table.

SELECT Maker
FROM Product AS Z
WHERE Type = 'pc'
EXCEPT
(SELECT Maker
FROM Product AS A
JOIN
(SELECT Model
FROM Product
WHERE Type = 'pc'
EXCEPT
SELECT DISTINCT Model
FROM Pc) B ON A.Model = B.Model)

--Task: 95 (qwrqwr: 2013-02-08)
--Based on information from the Pass_in_Trip table, for each airline determine:
--1) number of flights performed;
--2) number of aircraft types used;
--3) the number of different passengers transported;
--4) the total number of passengers transported by the company.
--Output: Company name, 1), 2), 3), 4).

SELECT C.Name AS Company_Name,
count(DISTINCT cast(Pit.Date AS VARCHAR(35)) + cast(Pit.Trip_No AS VARCHAR(35))) AS Flights,
count(DISTINCT T.Plane) AS Planes,
count(DISTINCT Pit.Id_Psg) AS Diff_Psngrs,
count(Pit.Id_Psg) AS Total_Psngrs
FROM Pass_In_Trip AS Pit
INNER JOIN Trip AS T ON T.Trip_No = Pit.Trip_No
INNER JOIN Company AS C ON T.Id_Comp = C.Id_Comp
GROUP BY C.Name

--Task: 43 (qwrqwr: 2011-10-28)
--Indicate the battles that took place in years that do not coincide with any of the years the ships were launched.

SELECT Name
FROM Battles
WHERE year(Date) NOT IN
(SELECT Launched
FROM Ships
WHERE Launched IS NOT NULL)

--Task: 63 (Serge I: 2003-04-08)
--Identify the names of different passengers who have ever flown in the same seat more than once.

SELECT Name
FROM Passenger
WHERE Id_Psg IN
(SELECT Id_Psg
FROM Pass_In_Trip
GROUP BY Place, Id_Psg
HAVING count(*) > 1)


----------Tabular expression tasks----------
--Task: 59 (Serge I: 2003-02-15)
--Calculate the cash balance at each collection point for the database with reporting no more than once a day.
--Output: point, remainder.
SELECT Incs.Point,
iif(sum(Out) IS NULL, sum(Inc), sum(Inc) - sum(Out)) Remain
FROM (SELECT I.Point, Inc = sum(Inc)
FROM Income_O I
GROUP BY I.Point) AS Incs
LEFT JOIN
(SELECT O.Point, Out = sum(Out)
FROM Outcome_O O
GROUP BY O.Point) AS Ou
ON Incs.Point = Ou.Point
GROUP BY Incs.Point


--Task: 60 (Serge I: 2003-02-15)
--Calculate the cash balance at the beginning of the day 04/15/01 at each collection point for the reporting database
--more than once a day. Conclusion: point, remainder.
--Comment. Do not take into account items for which there is no information before the specified date.
SELECT Income_O.Point,
Remain = CASE
WHEN sum(Inc) - min(Outcome) > 0 THEN sum(Inc) - min(Outcome)
WHEN min(Outcome) IS NULL THEN sum(Inc)
ELSE 0
END
FROM Income_O
FULL JOIN (SELECT Point, Outcome = sum(Out)
FROM Outcome_O
WHERE [date] < '20010415'
GROUP BY Point) AS O
ON O.Point = Income_O.Point
WHERE [date] < '20010415'
GROUP BY Income_O.Point


--Task: 26 (Serge I: 2003-02-14)
--Find the average price of PCs and PC-notepads produced by manufacturer A (Latin letter).
--Output: one overall average price.
;
WITH T1 AS (
SELECT T.Price
FROM Product AS P
INNER JOIN Pc AS T ON P.Model = T.Model
WHERE Maker = 'A'
UNION ALL
SELECT T.Price
FROM Product AS P
INNER JOIN Laptop AS T ON P.Model = T.Model
WHERE P.Maker = 'A'
)
SELECT avg(Price)
FROM T1


--Task: 28 (Serge I: 2012-05-04)
--Using the Product table, determine the number of manufacturers producing one model.
;
WITH T1 AS (
SELECT Maker
FROM Product
GROUP BY Maker
HAVING count(Model) = 1
)
SELECT count(*)
FROM T1;

WITH T1 AS (
SELECT *, Num = count(Model) OVER (PARTITION BY Maker)
FROM Product
)
SELECT count(*)
FROM T1
WHERE Num = 1


--Task: 30 (Serge I: 2003-02-14)
--Assuming that the receipt and expenditure of money at each collection point is recorded an arbitrary number of times
--(the primary key in tables is the code column), you want to get a table in which each item for each
--one line will correspond to the date of operations.
--Output: point, date, total point consumption per day (out), total point receipt per day (inc).
--Missing values are considered NULL.
;
WITH T1 AS (
SELECT Point, Date, Out = NULL, Inc
FROM Income
UNION ALL
SELECT Point, Date, Out, Inc = NULL
FROM Outcome
)
SELECT Point, Date, Out = sum(Out), Inc = sum(Inc)
FROM T1
GROUP BY Point, Date


--Task: 32 (Serge I: 2003-02-17)
--One of the characteristics of a ship is the half cube of the caliber of its main guns (mw).
--With an accuracy of 2 decimal places, determine the average value of mw for the ships of each country,
--which has ships in the database.
;
WITH T1 AS (
SELECT S.Name, C.Country, Mw = power(C.Bore, 3) / 2
FROM Classes AS C
INNER JOIN Ships AS S ON C.Class = S.Class
UNION
SELECT C.Class, C.Country, Mw = power(C.Bore, 3) / 2
FROM Classes AS C
INNER JOIN Outcomes AS O ON C.Class = O.Ship
)
SELECT Country, cast(avg(Mw) AS DECIMAL(7, 2))
FROM T1
GROUP BY Country


--Task: 37 (Serge I: 2003-02-17)
--Find classes that include only one ship from the database (also include ships in Outcomes).
;
WITH T AS (
SELECT Class, Name
FROM Ships
UNION
SELECT Ship, Ship
FROM Outcomes)
SELECT C.Class
FROM Classes C
LEFT JOIN T ON C.Class = T.Class
GROUP BY C.Class
HAVING count(T.Name) = 1


--Task: 41 (Serge I: 2019-05-31)
--For each manufacturer that has models in at least one of the PC, Laptop or Printer tables,
--determine the maximum price for its products.
--Output: name of the manufacturer, if there is NULL among the prices for the products of this manufacturer, then output NULL for this manufacturer,
--otherwise the maximum price.
;
WITH Cte_Maker_Model_Price AS (
    SELECT Maker, Product.Model, Price
        FROM Product
                 INNER JOIN Pc ON Product.Model = Pc.Model
    UNION
    SELECT Maker, Product.Model, Price
        FROM Product
                 INNER JOIN Laptop ON Product.Model = Laptop.Model
    UNION
    SELECT Maker, Product.Model, Price
        FROM Product
                 INNER JOIN Printer ON Product.Model = Printer.Model
)
SELECT Maker,
       CASE
           WHEN max(iif(Price IS NULL, 1, 0)) = 0
               THEN max(Price)
           END
FROM Cte_Maker_Model_Price
GROUP BY Maker

--Task: 51 (Serge I: 2003-02-17)
--Find the names of the ships that have the largest number of guns among all available ships of the same displacement
--(take into account ships from the Outcomes table).
;
WITH T1 AS (
SELECT C.Class, S.Name, C.Numguns, C.Displacement
FROM Classes AS C
INNER JOIN Ships AS S ON S.Class = C.Class
UNION
SELECT C.Class, Name = O.Ship, C.Numguns, C.Displacement
FROM Classes AS C
INNER JOIN Outcomes AS O ON O.Ship = C.Class),
T2 AS (
SELECT Max_Numgums = max(Numguns), Displacement
FROM T1
GROUP BY Displacement)
SELECT T1.Name
FROM T1
INNER JOIN T2 ON T1.Displacement = T2.Displacement AND T1.Numguns = T2.Max_Numgums


--Task: 89 (Serge I: 2012-05-04)
--Find manufacturers that have the most models in the Product table, as well as those that have the fewest models.
--Output: maker, number of models
;
WITH T1 AS (
SELECT Maker, Count_Model = count(Model)
FROM Product
GROUP BY Maker)
SELECT*
FROM T1
WHERE Count_Model = (SELECT min(Count_Model)
FROM T1)
OR Count_Model = (SELECT max(Count_Model)
FROM T1)


--Task: 66 (Serge I: 2003-04-09)
--For all days in the interval from 01/04/2003 to 07/04/2003, determine the number of flights from Rostov.
--Output: date, number of flights
;
WITH T1 AS
(SELECT Dataa = cast('2003-04-01' AS DATETIME)
UNION ALL
SELECT dateadd(DAY, 1, Dataa)
FROM T1
WHERE Dataa < '2003-04-07'
)
SELECT T1.Dataa, count(DISTINCT T.Trip_No)
FROM T1
LEFT JOIN Pass_In_Trip AS P ON P.Date = T1.Dataa
LEFT JOIN Trip AS T ON T.Trip_No = P.Trip_No AND T.Town_From = 'Rostov'
GROUP BY T1.Dataa


--Task: 133 (yuriy.rozhok: 2007-03-24)
--Let there be some subset S of the set of integers. Let's call a sequence of numbers "a hill with vertex N"
--from S, in which numbers less than N are arranged (from left to right without separators) first in an ascending chain, and then -
--descending chain, and the value N between them.
--For example, for S = {1, 2, ..., 10} a hill with top 5 is represented by the following sequence: 123454321. For S,
--consisting of the identifiers of all companies, for each company build a “slide”, considering its identifier in
--top quality.
--Consider identifiers as positive numbers and take into account that there is no data in the database for which the number of digits in the "slide"
--may exceed 70.
--Output: id_comp, "slide"
;
WITH T1 AS (
SELECT Id = Id_Comp, Number = row_number() OVER (ORDER BY Id_Comp)
FROM Company AS C
),
T2 AS (
SELECT Number, Id, Left_Hill = cast('' AS VARCHAR(8000)), Right_Hill = cast('' AS VARCHAR(8000))
FROM T1
WHERE Number = 1
UNION ALL
SELECT T1.Number, T1.Id, T2.Left_Hill + cast(T2.Id AS VARCHAR(8000)),
cast(T2.Id AS VARCHAR(8000)) + T2.Right_Hill
FROM T1
INNER JOIN T2 ON T1.Number = T2.Number + 1
)
SELECT Id, Hill = Left_Hill + cast(Id AS VARCHAR(8000)) + Right_Hill
FROM T2


--Task: 61 (Serge I: 2003-02-14)
--Calculate the cash balance at all collection points for the database with reporting no more than once a day.
SELECT Remain = iif(sum(Inc) - min(Outcome) > 0, sum(Inc) - min(Outcome), 0)
FROM Income_O,
(SELECT Outcome = sum(Out)
FROM Outcome_O) AS O


--Task: 67 (Serge I: 2010-03-27)
--Find the number of routes served by the largest number of flights.
--Notes.
--1) A - B and B - A are considered DIFFERENT routes.
--2) Use only Trip table
;
WITH T1 AS (
SELECT Town_From, Town_To, Num = count(*)
FROM Trip
GROUP BY Town_From, Town_To)
SELECT count(*)
FROM T1
WHERE Num = (SELECT max(Num)
FROM T1)


--Task: 68 (Serge I: 2010-03-27)
--Find the number of routes served by the largest number of flights.
--Notes.
--1) A - B and B - A are considered the SAME route.
--2) Use only Trip table
;
WITH T1 AS (
SELECT Town_From = iif(Town_From > Town_To, Town_From, Town_To),
Town_To = iif(Town_From > Town_To, Town_To, Town_From)
FROM Trip),
T2 AS (
SELECT TOP 1 WITH TIES Max = count(*)
FROM T1
GROUP BY Town_To, Town_From
ORDER BY count(*) DESC)
SELECT Num = count(*)
FROM T2


--Task: 83 (dorin_larsen: 2006-03-14)
--Determine the names of all ships from the Ships table that satisfy at least
--combinations of any four criteria from the following list:
--numGuns=8
--bore=15
--displacement = 32000
--type=bb
--launched = 1915
--class=Kongo
--country=USA
SELECT Name
FROM Ships AS S
JOIN Classes AS Cl1 ON S.Class = Cl1.Class
WHERE iif(Numguns = 8, 1, 0) +
iif(Bore = 15, 1, 0) +
iif(Displacement = 32000, 1, 0) +
iif(Type = 'bb', 1, 0) +
iif(Launched = 1915, 1, 0) +
iif(S.Class = 'kongo', 1, 0) +
iif(Country = 'usa', 1, 0) >= 4


--Task: 88 (Serge I: 2003-04-29)
--Among those who use the services of only one company, determine the names of the different passengers who flew more often than others.
--Output: passenger name, number of flights and company name.
;
WITH T1 AS (
    SELECT Pit.Id_Psg, Count_Trip = count(T.Trip_No), Company = min(C.Name)
        FROM Trip AS T
                 INNER JOIN Pass_In_Trip AS Pit ON T.Trip_No = Pit.Trip_No
                 INNER JOIN Company AS C ON C.Id_Comp = T.Id_Comp
        GROUP BY Pit.Id_Psg
        HAVING count(DISTINCT C.Id_Comp) = 1)
SELECT P.Name, Count_Trip, T1.Company
    FROM T1
             INNER JOIN Passenger AS P ON P.Id_Psg = T1.Id_Psg
    WHERE Count_Trip = (SELECT max(Count_Trip)
                            FROM T1)

--Задание: 91 (Serge I: 2015-03-20)
--With an accuracy of two decimal places, determine the average amount of paint per square.
;
WITH T1 AS (
SELECT Utq.Q_Id, S = sum(coalesce(Utb.B_Vol, 0))
FROM Utq
LEFT JOIN Utb ON Utq.Q_Id = Utb.B_Q_Id
GROUP BY Utq.Q_Id
)
SELECT cast(avg(cast(S AS NUMERIC(10, 2))) AS NUMERIC(10, 2))
FROM T1

--Task: 102 (Serge I: 2003-04-29)
--Identify the names of the different passengers who flew
--only between two cities (there and/or back).
;
WITH T1 AS (
    SELECT T.Trip_No, Town_From, Town_To, Id_Psg
        FROM Trip AS T
                 INNER JOIN Pass_In_Trip AS Pit ON Pit.Trip_No = T.Trip_No
    UNION ALL
    SELECT T.Trip_No, Town_To, Town_From, Id_Psg
        FROM Trip AS T
                 INNER JOIN Pass_In_Trip AS Pit ON Pit.Trip_No = T.Trip_No)
SELECT Name = min(Name)
    FROM T1
             INNER JOIN Passenger AS P ON P.Id_Psg = T1.Id_Psg
    GROUP BY P.Id_Psg
    HAVING count(DISTINCT Town_From) = 2
       AND count(DISTINCT Town_To) = 2


--Задание: 140 (no_more: 2017-07-07)
--Determine how many battles occurred during each decade, from the date of the first battle in the database to the date of the last.
--Output: decade in the "1940s" format, number of battles.
;
WITH T1 AS (
SELECT Years = (year(Date) / 10) * 10, Battles = count(*)
FROM Battles
GROUP BY (year(Date) / 10) * 10
),
T2 AS (
SELECT Years = 0
, Buttles = 0
UNION ALL
SELECT Years + 10, 0
FROM T2
             WHERE Years + 10 <= year(getdate())
     ),
     T3 AS (
         SELECT *
             FROM T1
         UNION ALL
         SELECT *
             FROM T2
     )
SELECT Years = cast(Years AS VARCHAR(4)) + 's', Buttles = sum(Battles)
    FROM T3
    WHERE Years <= (SELECT max(Years)
                        FROM T1)
      AND (Years >= (SELECT min(Years)
                         FROM T1))
    GROUP BY cast(Years AS VARCHAR(4)) + 's'
    OPTION (MAXRECURSION 0)

-- Find a number consisting of 10 digits, which can be obtained if in a sequence of consecutively written natural numbers
-- 12345678910111213... take a number consisting of ten digits, starting from the left with the number 10000.
-- That is, necessary in the sequence 12345678910111213... select numbers starting from position 10000 to 10009
DECLARE @A INT = 10000;
DECLARE @B INT = 10;
WITH T1 AS (
SELECT Num = 1,
Strn = cast('1' AS VARCHAR(MAX))
UNION ALL
SELECT Num + 1,
Strn + cast(Num + 1 AS VARCHAR(38))
FROM T1
WHERE len(Strn) <= @A + @B
)
SELECT substring(Strn, @A, @B)
FROM T1
WHERE Num = (
SELECT max(Num)
FROM T1
)
OPTION (MAXRECURSION 0)


-- Find a number consisting of 10 digits that can be obtained if in a sequence of consecutively written Fibonacci numbers
-- 1123581321345589... take a number consisting of ten digits, starting from the left with the number 3000.
-- That is, necessary in the sequence 1123581321345589... select numbers starting from position 3000 to 3009.
;
WITH T1 AS (
SELECT Number = cast(1 AS DECIMAL(38, 0)),
Pr_Fi = cast(0 AS DECIMAL(38, 0)),
Fi = cast(1 AS DECIMAL(38, 0)),
Str = cast('' AS VARCHAR(MAX))
UNION ALL
SELECT Number + 1,
Fi,
Pr_Fi + Fi,
[Str] + cast(Fi AS VARCHAR(MAX))
FROM T1
WHERE len([Str]) < 3000 + 9
)
SELECT substring([Str], 3000, 10)
FROM T1
WHERE Fi = (
SELECT max(Fi)
FROM T1
)
OPTION (MAXRECURSION 200)


-- For individual customers (The PersonType field from the Person table contains 'IN' – Individual (retail) customer)
-- from the states of Texas, Alaska, Florida, Georgia, New York, create a view containing the names and surnames of individual
-- buyers and their postal address (AddressLine1, City, state name, zip code
USE Adventureworks2019
DROP VIEW IF EXISTS In_Information;
GO
CREATE VIEW In_Information AS
SELECT Pers.Firstname,
       Pers.Lastname,
       Adress.Addressline1,
       Adress.City,
       State = State.Name, Adress.Postalcode
    FROM Person.Person AS Pers
             JOIN Person.Businessentityaddress AS Business
                  ON Pers.Businessentityid = Business.Businessentityid
             JOIN Person.Address AS Adress
                  ON Adress.Addressid = Business.Addressid
             JOIN Person.Stateprovince AS State
                  ON State.Stateprovinceid = Adress.Stateprovinceid
    WHERE Pers.Persontype = 'in'
AND State.Name IN ('Alaska', 'Texas', 'Georgia', 'Florida', 'New York')


----------Control for recursive generalized table expressions---------
USE Adventureworks2019
-- Test question 1.
-- Run a job against the AdventureWorks2019 database.
-- In the Production.Product table, find the cheapest product with a non-zero price and display its name
-- one character per line in the form of a table of two columns: number of the character in the line, character.
DECLARE @Data VARCHAR(30)
SET @Data = (SELECT TOP (1) Product.Name
                 FROM Production.Product
                 WHERE Production.Product.Standardcost > 0
                 ORDER BY Production.Product.Standardcost);
WITH Resulttable AS
         (
             SELECT [UpdateText] = stuff(@Data, 1, 1, ''), Char = left(@Data, 1), Num = 1
             UNION ALL
             SELECT stuff([UpdateText], 1, 1, ''), left([UpdateText], 1), Resulttable.Num + 1
                 FROM Resulttable
                 WHERE len([UpdateText]) > 0
         )
SELECT Num, Char
    FROM Resulttable;


-- Контрольный вопрос 2.
-- Run a job against the AdventureWorks2019 database.
-- For each supplier in the Purchasing.Vendor table, display its account number AccountNumber
-- and display a column in which the characters of the AccountNumber string will be sorted in ascending order
-- (i.e. sort characters within a string alphabetically)
WITH Base AS (
SELECT Item.[char], Pv.Accountnumber
FROM Purchasing.Vendor AS Pv
CROSS APPLY (SELECT substring(Pv.Accountnumber, 1 + Number, 1) [char]
FROM Master..Spt_Values --[1, 2047]
                                  WHERE Number < len(Pv.Accountnumber)
                                    AND Type = 'P'
        ) AS Item
)
SELECT DISTINCT B1.Accountnumber,
                [Sorted Account Numbers] = replace((SELECT '' + [char]
                                                        FROM Base B2
                                                        WHERE B1.Accountnumber = B2.Accountnumber
                                                        ORDER BY [char]
                                                        FOR XML PATH('')
                                                   ), '&#x20;', ' ')
    FROM Base AS B1;


----------Tasks on PIVOT and UNPIVOT operators and window functions---------
--Task: 84 (Serge I: 2003-06-05)
--For each company, count the number of passengers transported (if there were any in this month) by ten days of April 2003.
--In this case, only take into account the departure date.
--Conclusion: company name, number of passengers for each decade
SELECT *
FROM (
SELECT Company.Name,
Pass_In_Trip.Id_Psg,
T=CASE
                            WHEN day(Date) BETWEEN 1 AND 10 THEN '1-10'
                            WHEN day(Date) BETWEEN 11 AND 20 THEN '11-20'
                            WHEN day(Date) BETWEEN 21 AND 30 THEN '21-30'
                        END
                 FROM Company
                          JOIN Trip ON Company.Id_Comp = Trip.Id_Comp
                          JOIN Pass_In_Trip ON Trip.Trip_No = Pass_In_Trip.Trip_No
                 WHERE year(Date) = 2003
                   AND month(Date) = 4
         ) AS Base
             PIVOT (
             count(Id_Psg)
             FOR T
             IN ([1-10], [11-20], [21-30])
) AS Ptable


--Task: 109 (qwrqwr: 2011-01-13)
--Output:
--1. The names of all squares are black or white.
--2. Total number of white squares.
--3. Total number of black squares.
;
WITH _Data AS
(
SELECT Q_Id, Q_Name, isnull([r], 0) R, isnull([g], 0) G, isnull([b], 0) B
FROM (
SELECT Q_Id, Q_Name, isnull(B_Vol, 0) B_Vol, isnull(V_Color, 'x') V_Color
FROM Dbo.Utv V
                                       JOIN Dbo.Utb B ON V.V_Id = B.B_V_Id
                                       RIGHT JOIN Dbo.Utq Q ON Q.Q_Id = B.B_Q_Id
                      ) T
                          PIVOT
                          (sum(B_Vol) FOR V_Color IN ([r],[g],[b])) P
         )

SELECT Q_Name,
       W_Q = (SELECT count(*)
                  FROM _Data
                  WHERE R + G + B = 255 * 3)
        ,
       B_Q = (SELECT count(*)
                  FROM _Data
                  WHERE R + G + B = 0)
    FROM _Data
    WHERE R + G + B = 255 * 3
       OR R + G + B = 0
--Второй вариант
;
WITH T1 AS (
    SELECT DISTINCT Q_Name, Paint = sum(B_Vol) OVER (PARTITION BY Q_Id)
        FROM Utb
                 RIGHT JOIN Utq
                            ON Utb.B_Q_Id = Utq.Q_Id
),

     T2 AS (
         SELECT *
             FROM T1
             WHERE Paint = 765
                OR Paint IS NULL
     )

SELECT Q_Name,
       White = (SELECT count(*)
                    FROM T2
                    WHERE Paint = 765),
Black = (SELECT count(*)
FROM T2
WHERE Paint IS NULL)
FROM T2


--Task: 111 (Serge I: 2003-12-24)
--Find NOT white and NOT black squares that are colored in different colors in a 1:1:1 ratio. Output: square name,
--amount of paint of one color
;
WITH T1 AS (
SELECT B_Q_Id, Paint = sum(B_Vol), V_Color
FROM Utb
JOIN Utv ON Utv.V_Id = Utb.B_V_Id
GROUP BY B_Q_Id, V_Color
),

T2 AS (
SELECT B_Q_Id, [r], [g], [b]
FROM T1
PIVOT (sum(Paint) FOR V_Color IN ([r], [g], [b])) AS Color
WHERE R = G
AND B = G
AND (R + G + B <> 765)
)

SELECT Utq.Q_Name, Qty = R
FROM T2
JOIN Utq ON Utq.Q_Id = T2.B_Q_Id


--Task: 146 (Serge I: 2008-08-30)
--For a PC with the maximum code from the PC table, display all its characteristics (except the code) in two columns:
--- name of the characteristic (name of the corresponding column in the PC table);
--- значение характеристики
SELECT Character, Value
    FROM (
             SELECT Model = cast(Model AS VARCHAR(1000)),
                    Speed = cast(Speed AS VARCHAR(1000)),
                    Ram   = cast(Ram AS VARCHAR(1000)),
                    Hd    = cast(Hd AS VARCHAR(1000)),
                    Cd    = cast(Cd AS VARCHAR(1000)),
                    Price = cast(isnull(cast(Price AS VARCHAR(1000)), '') AS VARCHAR(1000))
                 FROM Pc
                 WHERE Code IN (SELECT max(Code)
                                    FROM Pc)
         ) T1
             UNPIVOT
( Value FOR Character IN (Model,Speed,Ram,Hd,Cd,Price)) AS Unpivottable


--Task: 47 (Serge I: 2019-06-07)
--Identify the countries that lost all their ships in battles.
;
WITH T1 AS (SELECT Co = count(Name), Country
FROM (SELECT Name, Country
FROM Classes
INNER JOIN Ships ON Ships.Class = Classes.Class
UNION
SELECT Ship, Country
FROM Classes
INNER JOIN Outcomes ON Outcomes.Ship = Classes.Class) Fr1
                GROUP BY Country
),

     T2 AS (SELECT count(Name) AS Co, Country
                FROM (SELECT Name, Country
                          FROM Classes
                                   INNER JOIN Ships ON Ships.Class = Classes.Class
                          WHERE Name IN (SELECT DISTINCT Ship
                                             FROM Outcomes
                                             WHERE Result LIKE 'sunk')
                      UNION
                      SELECT Ship, Country
                          FROM Classes
                                   INNER JOIN Outcomes ON Outcomes.Ship = Classes.Class
WHERE Ship IN (SELECT DISTINCT Ship
FROM Outcomes
WHERE Result LIKE 'sunk')
) Fr2
GROUP BY Country)

SELECT T1.Country
FROM T1
INNER JOIN T2 ON T1.Co = T2.Co AND T1.Country = T2.Country


--Task: 82 (Serge I: 2011-10-08)
--In a set of records from the PC table, sorted by the code column (ascending), find the average price value for
--each six consecutive PCs.
--Output: the code value that is the first in a set of six lines, the average price value in the set.
SELECT TOP ((SELECT count(*)
FROM Pc) - 5) Code, Average = avg(Price) OVER (ORDER BY Code ROWS BETWEEN CURRENT ROW AND 5 FOLLOWING)
FROM PC
ORDER BY Code


--Task: 87 (Serge I: 2003-08-28)
--Assuming that the point of the passenger’s very first departure is the place of residence, find non-Muscovites who flew to
--Moscow more than once.
--Conclusion: passenger name, number of flights to Moscow
;
WITH T1 AS (
    SELECT DISTINCT Id_Psg,
                    Home = first_value(Town_From) OVER (PARTITION BY Id_Psg ORDER BY (Date + Time_Out -
                                                                                      cast(datefromparts(year(Time_Out), month(Time_Out), day(Time_Out))
                                                                                          AS DATETIME)))
        FROM Trip AS T
                 JOIN Pass_In_Trip AS Pt ON Pt.Trip_No = T.Trip_No
)

SELECT Name = min(Name), Trip_Count = count(*)
    FROM Pass_In_Trip AS Pt
             JOIN Trip AS T ON T.Trip_No = Pt.Trip_No
             JOIN T1
                  ON T1.Id_Psg = Pt.Id_Psg
JOIN Passenger AS P
ON P.Id_Psg = T1.Id_Psg
WHERE Town_To = 'moscow'
AND Home <> 'moscow'
GROUP BY T1.Id_Psg
HAVING count(*) > 1


--Task: 100 ($erges: 2009-06-05)
--Write a query that displays all incoming and outgoing transactions from the Income and Outcome tables in the following form:
--date, serial number of the record for this date, receipt item, receipt amount, expense item, expense amount.
--At the same time, all receipt transactions for all items, completed within one day, are ordered by the code field, and also
--all expense transactions are ordered by the code field.
--If there was an unequal number of income/expense transactions in one day, output NULL in the corresponding
--columns in place of missing operations.
SELECT DISTINCT A.Date, AR, B.Point, B.Inc, C.Point, C.Out
FROM (SELECT DISTINCT Date, R = row_number() OVER (PARTITION BY Date ORDER BY Code)
FROM Income
UNION
SELECT DISTINCT Date, row_number() OVER (PARTITION BY Date ORDER BY Code)
FROM Outcome) A
LEFT JOIN (SELECT Date, Point, Inc, Ri = row_number() OVER (PARTITION BY Date ORDER BY Code)
FROM Income) B ON B.Date = A.Date AND B.Ri = AR
LEFT JOIN (SELECT Date, Point, Out, Ro = row_number() OVER (PARTITION BY Date ORDER BY Code)
FROM Outcome) C ON C.Date = A.Date AND C.Ro = AR


--Task: 126 (Serge I: 2015-04-17)
--For a sequence of passengers ordered by id_psg, determine who
--who has flown the most number of flights, as well as those in the sequence immediately before and after him.
--For the first passenger in the sequence, the previous one will be the last one, and for the last passenger the next one will be the first one.
--For each passenger that meets the condition, display: name, name of the previous passenger, name of the next passenger.
;
WITH T1 AS (
SELECT Id_Psg, count(Trip_No) AS Qty
FROM Pass_In_Trip AS Pt
GROUP BY Id_Psg
),

     T2 AS (
         SELECT Id_Psg, Name,
                Previous = coalesce(lag(Id_Psg) OVER (ORDER BY Id_Psg), last_value(Id_Psg)
                                                                                   OVER (ORDER BY Id_Psg ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)),
                Next     = coalesce(lead(Id_Psg) OVER (ORDER BY Id_Psg), first_value(Id_Psg)
                                                                                     OVER (ORDER BY Id_Psg ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING))
             FROM Passenger AS P
     )

SELECT T2.Name,
       (SELECT Name
            FROM Passenger AS P
WHERE P.Id_Psg = [previous]) AS Previous,
(SELECT Name
FROM Passenger AS P
WHERE P.Id_Psg = [next]) AS Next
FROM T1
JOIN T2 ON T2.Id_Psg = T1.Id_Psg
WHERE Qty = (SELECT max(Qty)
FROM T1)

--Task: 147 (Serge I: 2011-02-11)
--Number the rows from the Product table in the following order: manufacturer's name in descending order of the number of models it produces (if the number of models is the same, manufacturer's name in alphabetical order in ascending order), model number (ascending).
--Output: number in accordance with a given order, manufacturer name (maker), model (model)

;
WITH T1 AS (
SELECT Maker, T = count(Model)
FROM Product
GROUP BY Maker
)

SELECT Number = row_number() OVER (ORDER BY T DESC, T1.Maker , Model), T1.Maker, Model
FROM Product AS P
JOIN T1 ON T1.Maker = P.Maker


--Task: 107 (VIG: 2003-09-01)
--For the fifth passenger who departed from Rostov in April 2003, determine the company, flight number and departure date.
--Comment. It is impossible to assume that two flights depart from Rostov at the same time.
;
WITH T1 AS (
SELECT Number = row_number() OVER (ORDER BY (Date + Time_Out)), Id_Comp, Date, T.Trip_No
FROM Pass_In_Trip AS Pt
JOIN Trip AS T ON T.Trip_No = Pt.Trip_No
WHERE Date >= '20030401'
AND Date <= '20030430'
AND Town_From = 'rostov'
)
SELECT Name, Trip_No, Date
FROM T1
JOIN Company AS C ON C.Id_Comp = T1.Id_Comp
WHERE Number = 5


--Task: 137 (Serge I: 2005-01-19)
--For every fifth model (in ascending order of numbers
--models) from the Product table
--determine the type of product and the average price of the model.
SELECT Mo.Type,
Avg_Price = CASE
WHEN Mo.Type = 'pc' THEN avg(P.Price)
WHEN Mo.Type = 'laptop' THEN avg(Lap.Price)
WHEN Mo.Type = 'printer' THEN avg(Prin.Price)
END
FROM (SELECT Prod.Model, Prod.Type, Prod.Num
FROM (SELECT row_number() OVER (ORDER BY Model) Num, Model, Type
FROM Product) AS Prod
GROUP BY Prod.Model, Prod.Type, Prod.Num
HAVING Num % 5 = 0) AS Mo

LEFT JOIN Pc P ON Mo.Model = P.Model
LEFT JOIN Laptop Lap ON Mo.Model = Lap.Model
LEFT JOIN Printer Prin ON Mo.Model = Prin.Model

GROUP BY Mo.Num, Mo.Type


----------Control on CROSS APPLY, OUTER APPLY, PIVOT and UNPIVOT statements and window functions----------
--Test question 2
--It is required to parse the IP address and place its fields in separate columns

CREATE TABLE Custom
(
IPCHAR(15)
)
INSERT INTO Custom (Ip)

    VALUES ('111.22.33.44'),

           ('222.33.44.55'),

           ('333.44.55.66'),

           ('444.55.66.77');
WITH T1 AS (
    SELECT Ip, [Value], [Id] = row_number() OVER (ORDER BY Custom.[Ip])
        FROM Custom
                 CROSS APPLY string_split(Ip, '.')
)


SELECT [1], [2], [3], [4]
    FROM (
             SELECT [Ip], Value, [Newid] = row_number() OVER (PARTITION BY [Ip] ORDER BY [Id])

                 FROM [T1]) AS [A]
             PIVOT (
             max(Value)
             FOR [Newid]
IN ([1],[2],[3],[4])) [Pvt]


--Security question 4.
--Run a job against the AdventureWorks2019 database. Display a table whose column names are
--categories, and the lines contain the names of subcategories, sorted alphabetically within each category
;
WITH T1 AS (
SELECT DISTINCT [Cat] = C.Name, [Subcat] = S.Name

FROM Adventureworks2019.[Production].[ProductSubcategory] AS S

JOIN Adventureworks2019.Production.Productcategory AS C
ON [C].[ProductCategoryID] = S.[ProductCategoryID])


SELECT [Accessories], [Bikes], [Components], [Clothing]

FROM (SELECT [Cat], [Subcat], [Tt] = row_number() OVER (PARTITION BY [Cat] ORDER BY [Subcat])

FROM [T1]) AS [A]
PIVOT (max([Subcat]) FOR [Cat] IN ([Accessories],[Bikes],[Components],[Clothing])) AS [Table]


----------Tasks for DML statements (INSERT, DELETE, UPDATE)----------
-- Task: 1 (Serge I: 2004-09-08)
-- Add the following model to the PC table:
-- code: 20
-- model: 2111
-- speed: 950
--ram: 512
--hd: 60
-- cd: 52x
-- price: 1100
BEGIN TRANSACTION
INSERT INTO Product(Maker, Model, Type)
VALUES('A', '2111', 'PC')
INSERT INTO Pc(Code, Model, Speed, Ram, Hd, Cd, Price)
VALUES (20, '2111', 950, 512, 60, '52x', 1100)

INSERT INTO Pc(Code, Model, Speed, Ram, Hd, Cd, Price)
SELECT 20, '2111', 950, 512, 60, '52x', 1100

SELECT *
FROM PC
SELECT *
FROM Product

ROLLBACK TRANSACTION


-- Task: 2 (Serge I: 2004-09-08)
-- Add the following products from manufacturer Z to the Product table:
--Model 4003 Printer, Model 4001 PC and Model 4002 Notepad
BEGIN TRANSACTION

INSERT INTO Product(Maker, Model, Type)
VALUES('Z', '4003', 'Printer')
, ('Z', '4001', 'PC')
, ('Z', '4002', 'Laptop')


INSERT INTO Product(Maker, Model, Type)
SELECT 'Z', '4003', 'Printer'
UNION ALL
SELECT 'Z', '4001', 'PC'
UNION ALL
SELECT 'Z', '4002', 'Laptop'

ROLLBACK TRANSACTION

-- Task: 3 (Serge I: 2004-09-08)
-- Add model 4444 code 22 to the PC table, which has a processor speed of 1200 and a price of 1350.
-- Missing characteristics should be filled with default values for the corresponding columns.
BEGIN TRANSACTION
INSERT INTO Pc (Model, Code, Speed, Price)
VALUES('4444', 22, 1200, 1350)

INSERT INTO Pc(Code, Model, Speed, Ram, Hd, Cd, Price)
VALUES (22, '4444', 1200, default, default, default, 1350)

ROLLBACK TRANSACTION

-- Task: 4 (Serge I: 2004-09-08)
-- For each group of notepads with the same model number, add an entry to the PC table with the following characteristics:
-- code: minimum notepad code in the group +20;
-- model: notepad model number +1000;
-- speed: maximum speed of the notepad in the group;
-- ram: maximum RAM capacity of notepad in group *2;
-- hd: maximum size of HD notepad in group *2;
-- cd: default value;
-- price: the maximum price of a notebook in the group, reduced by 1.5 times.
-- Note. Treat the model number as a number.
BEGIN TRANSACTION

INSERT INTO Pc (Code, Model, Speed, Ram, Hd, Price)
SELECT min(Code) + 20
, Model + 1000
,max(Speed)
, max(Ram) * 2
, max(Hd) * 2
, max(Price) / 1.5
FROM Laptop
GROUP BY Model

ROLLBACK TRANSACTION


-- Task: 5 (Serge I: 2004-09-08)
-- Remove computers from the PC table that have a minimum amount of disk or memory.
DELETE
FROM PC
WHERE Hd = (SELECT min(Hd)
FROM PC
)
OR Ram = (SELECT min(Ram)
FROM PC)


-- Task: 6 (Serge I: 2004-09-08)
-- Remove all notepads made by manufacturers that do not make printers.
BEGIN TRANSACTION

WITH T1 AS (
SELECT Model
FROM Product
WHERE [type] = 'Laptop'
AND Maker NOT IN (SELECT Maker
FROM Product
WHERE [type] = 'Printer')
)
DELETE
FROM Laptop
WHERE Model IN (SELECT *
FROM T1)
SELECT *
FROM Laptop

ROLLBACK TRANSACTION

-- Task: 7 (Serge I: 2004-09-08)
-- Printer production was transferred from manufacturer A to manufacturer Z. Make the appropriate change.
BEGIN TRANSACTION

UPDATE Product
SET Maker = 'Z'
WHERE Maker = 'A'
AND Type = 'printer'

SELECT *
FROM Product

ROLLBACK TRANSACTION

-- Task: 8 (Serge I: 2004-09-08)
-- Remove all ships sunk in battles from the Ships table.
BEGIN TRANSACTION

DELETE
FROM Ships
WHERE Name IN (SELECT Name
FROM Ships AS S,
Outcomes AS O
WHERE S.Name = O.Ship
AND Result = 'sunk')
SELECT *
FROM Ships

ROLLBACK TRANSACTION

-- Task: 9 (Serge I: 2004-09-08)
-- Change the data in the Classes table so that gun calibers are measured in
-- centimeters (1 inch = 2.5 cm), and displacement in metric tons (1
-- metric ton = 1.1 tons). Calculate displacement to within
- whole.
BEGIN TRANSACTION
UPDATE Classes
SET Bore=Bore * 2.5, Displacement= round(Displacement / 1.1, 0)

SELECT *
FROM Classes

ROLLBACK TRANSACTION


-- Task: 10 (Serge I: 2004-09-09)
-- Add to the PC table those PC models from Product that are not in the PC table.
-- In this case, the models must have the following characteristics:
-- 1. The code is equal to the model number plus the maximum code that was before insertion.
-- 2. Speed, memory and disk capacity, as well as CD speed should have the maximum characteristics among all available
-- in the PC table.
-- 3. The price should be the average of all PCs available in the PC table before insertion.
BEGIN TRANSACTION

INSERT INTO Pc (Code, Model, Speed, Ram, Hd, Cd, Price)
SELECT (SELECT max(P.Code)
FROM Pc AS P) + Model,
Model,
(SELECT max(P.Speed)
FROM Pc AS P),
       (SELECT max(P.Ram)
            FROM Pc AS P),
       (SELECT max(P.Hd)
            FROM Pc AS P),
       cast((SELECT max(cast(left(Cd, len(Cd) - 1) AS INT))
                 FROM Pc) AS VARCHAR(30)) + 'x',
       (SELECT avg(P.Price)
            FROM Pc AS P)
    FROM Product
    WHERE Type = 'pc'
      AND Model NOT IN (SELECT Model
                            FROM Pc)

SELECT *
    FROM Pc

SELECT *
    FROM Product

ROLLBACK TRANSACTION

-- Задание: 11 (Serge I: 2004-09-09)
-- For each group of notepads with the same model number, add an entry to the PC table with the following characteristics:
-- code: minimum notepad code in the group +20;
-- model: notepad model number +1000;
-- speed: maximum speed of the notepad in the group;
-- ram: maximum RAM capacity of notepad in group *2;
-- hd: maximum size of HD notepad in group *2;
-- cd: cd with the highest speed among all PCs;
-- price: maximum price of a notepad in a group, reduced by 1.5 times
BEGIN TRANSACTION

INSERT INTO Pc (Code, Model, Speed, Ram, Hd, Cd, Price)
SELECT min(Code) + 20, cast(Model AS INTEGER) + 1000, max(Speed), max(Ram) * 2, max(Hd) * 2,
cast((SELECT max(cast(left(Cd, len(Cd) - 1) AS INT))
FROM Pc) AS VARCHAR(30)) + 'x', max(Price) / 1.5
FROM Laptop
GROUP BY Model

SELECT *
FROM PC

ROLLBACK TRANSACTION

-- Task: 12 (Serge I: 2004-09-09)
-- Add one inch to the screen size of each notepad,
-- produced by manufacturers E and B, and reduce its price by $100.
BEGIN TRANSACTION

UPDATE Laptop
SET Screen = Screen + 1, Price = Price - 100
WHERE Model IN (SELECT Model
FROM Product
WHERE Maker = 'E'
OR Maker = 'B')

SELECT *
FROM Laptop

SELECT *
FROM Product

ROLLBACK TRANSACTION


-- Task: 13 (Serge I: 2004-09-09)
-- Enter information into the database that the Rodney was sunk in a battle that took place on 25/10/1944,
-- and the ship Nelson was damaged - 01/28/1945.
-- Note: assume that the date of the battle is unique in the Battles table.

BEGIN TRANSACTION

INSERT INTO Outcomes(Ship, Battle, Result)
VALUES('Rodney',
(SELECT Name
FROM Battles
WHERE Date = '1944-10-25 00:00:00'), 'sunk'),
('Nelson',
(SELECT Name
FROM Battles
WHERE Date = '1945-01-28 00:00:00'), 'damaged')

SELECT *
FROM Outcomes

SELECT *
FROM Battles

ROLLBACK TRANSACTION


-- Task: 14 (Serge I: 2004-09-09)
-- Remove classes that have less than three ships in the database (take into account ships from Outcomes).
BEGIN TRANSACTION

DELETE
FROM Classes
WHERE Class NOT IN (SELECT Class
FROM (SELECT Class
FROM Ships

UNION ALL

                                  SELECT DISTINCT Ship
                                      FROM Outcomes
                                      WHERE Ship NOT IN (SELECT Name
                                                             FROM Ships)) AS X
                            GROUP BY Class
                            HAVING count(*) >= 3)

SELECT *
    FROM Outcomes

SELECT *
    FROM Classes

SELECT *
    FROM Ships

ROLLBACK TRANSACTION

-- Задание: 15 (Serge I: 2009-06-05)
-- From each group of PCs with the same model number in the PC table, delete all rows except the row with the largest for that
-- groups by code (column code).
BEGIN TRANSACTION

DELETE
FROM PC
WHERE Code NOT IN (SELECT max(Code)
FROM PC
GROUP BY Model)
SELECT *
FROM PC

ROLLBACK TRANSACTION

-- Task: 16 (Serge I: 2004-09-09)
-- Remove from the Product table those models that are not in other tables.
BEGIN TRANSACTION

DELETE
    FROM Product
    WHERE Product.Model NOT IN (
        SELECT Model
            FROM Pc

        UNION

        SELECT Model
            FROM Laptop

        UNION

        SELECT Model
            FROM Printer
            GROUP BY Model
    )

SELECT *
    FROM Pc

SELECT *
    FROM Printer

SELECT *
    FROM Product

ROLLBACK TRANSACTION


-- Задание: 17 (Serge I: 2017-04-14)
-- Remove from the PC table computers whose hd value is among the three lowest values.
BEGIN TRANSACTION

DELETE
FROM PC
WHERE Hd IN (
SELECT TOP 3 HD
FROM(
SELECT DISTINCT HD
FROM PC
) AS T1
ORDER BY Hd
)

SELECT *
FROM PC

ROLLBACK TRANSACTION
