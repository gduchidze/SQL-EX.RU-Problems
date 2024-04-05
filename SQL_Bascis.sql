-- 1 
/*SELECT *
FROM SQLTutorial.dbo.Employ1
 Inner Join SQLTutorial.dbo.EmploySalary
	ON Employ1.EmployID = EmploySalary.EmployID */
-- 2
/* SELECT Employ1.EmployID, Firstname, Lastname, Salary
From SQLTutorial.dbo.Employ1
Inner Join SQLTutorial.dbo.EmploySalary
	ON Employ1.EmployID = EmploySalary.EmployID
WHERE Firstname <> 'Zura'
ORDER BY Salary DESC */

/* SELECT JobTitle , AVG(Salary)-- აირჩიე სამსახურის დასახელება საშვალო ხელფასი დაითველე 
FROM SQLTutorial.dbo.Employ1 -- SQLTutorial ბაზიდან Employ1 ცხრილი
Inner Join SQLTutorial.dbo.EmploySalary --გააერთიანე ეს ორი ბაზა 
	ON Employ1.EmployID = EmploySalary.EmployID -- ID ების საშუალებით
WHERE JobTitle = 'Cashier' -- სადაც სამსახურის დასახელება არის 'Cashier'
GROUP BY JobTitle */   -- დააჯგუფე ეს ყველა ერთად და დაუწერე საშუალო ხელფასი

/*SELECT Firstname, Lastname, Age ,
CASE
	WHEN AGE = 47 THEN 'Stanly'
	WHEN Age > 30 THEN 'Old'
	WHEN Age BETWEEN 27 AND 30 THEN 'Young'
	--WHEN AGE = 47 THEN 'Stanly' რადგან ზემოთ პირველი პირველი პირობა სრულდება თუ ეს ქონდიშენი გვინდა რო შესრულდეს მის ზემოთ უნდა გადავიტანოთ
	ELSE 'Baby'
END
From SQLTutorial.dbo.Employ1
WHERE Age is not NULL
ORDER BY Age  */

/*
SELECT Employ1.EmployID, Firstname, Lastname,JobTitle, Salary,
CASE 
	WHEN JobTitle = 'Teacher' THEN Salary + (Salary * .10)
	WHEN JobTitle = 'DevOps Engineer' THEN Salary + (Salary * .40)
	WHEN JobTitle = 'Chef' THEN Salary + (Salary * .010)
	ELSE Salary + (Salary * .03)
END AS SalaryAfterRaise
From SQLTutorial.dbo.Employ1
Join SQLTutorial.dbo.EmploySalary
	ON Employ1.EmployID = EmploySalary.EmployID
	*/

