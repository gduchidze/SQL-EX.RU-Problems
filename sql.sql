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

