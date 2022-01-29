--7.
SELECT City
FROM Customers
INTERSECT
SELECT City
From Employees
--8.
--a.
SELECT distinct c.City
FROM Customers c 
WHERE c.City not in (Select City FROM Employees)
--b.
SELECT City
FROM Customers
EXCEPT
SELECT City
From Employees
--9.
SELECT ProductName, ProductOrderQuantity
FROM Products p JOIN (
SELECT ProductID, SUM(Quantity) as ProductOrderQuantity
FROM [Order Details]
GROUP BY ProductID
) x ON p.ProductID = x.ProductID 
--10.
SELECT City, Sum(Quantity) as TotalProduct
FROM (
SELECT o.OrderID, o.CustomerID, c.City, od.Quantity
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
) dt 
GROUP BY City
--11.
--a.
SELECT City, COUNT(City) as CountCity
FROM (
SELECT *
FROM Customers
UNION
SELECT *
FROM Customers
) dt 
GROUP BY City
HAVING Count(City) >= 2
--b.
SELECT City, CountCity
FROM (Select city, Count(City) as CountCity
FROM Customers 
GROUP BY City
HAVING Count(City) >= 2
) dt 
--12.
SELECT City, COUNT(City) as KindsofProduct
FROM(
SELECT distinct City, ProductID
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID JOIN Customers c ON o.CustomerID = c.CustomerID
--ORDER BY City
) dt 
GROUP BY City
HAVING COUNT(City) >= 2
--13.
SELECT distinct c.CompanyName, c.City, o.ShipCity
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.City <> o.ShipCity
--14.
SELECT Top 5(z.TotalQuantity), z.ProductName, z.AvgUnitPrice,  z.CustomerCity
FROM (
SELECT y.ProductName, y.AvgUnitPrice, y.CustomerCity, y.TotalQuantity
FROM(
SELECT x.ProductName, x.AvgUnitPrice, c.City AS CustomerCity, x.TotalQuantity
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID JOIN  (
SELECT dt.ProductName, dt.ProductID, dt.AvgUnitPrice, sum(od.Quantity) as TotalQuantity
FROM [Order Details] od JOIN (
SELECT p.ProductName, p.ProductID, avg(od.UnitPrice) AS AvgUnitPrice
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName, p.ProductID
) dt ON od.ProductID = dt.ProductID
GROUP BY dt.ProductName, dt.AvgUnitPrice, dt.ProductID
) x ON x.ProductID = od.ProductID
) y
) z 
--15.
--a.
SELECT e.City
FROM Employees e
WHERE e.City NOT IN (Select distinct c.City
                    From Orders o JOIN Customers c ON o.CustomerID = c.CustomerID)
--b.
SELECT e.City
FROM Employees e
EXCEPT
SELECT c.City
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
--16.
SELECT x.City
FROM (
    SELECT e.City, COUNT(e.City) as CityOrder
    FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
    GROUP BY e.City
) x 
WHERE x.CityOrder = (
    SELECT Max(co.CityOrder) as MaxCityOrder
FROM(
    SELECT e.City, COUNT(e.City) as CityOrder
    FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
    GROUP BY e.City
) co )
INTERSECT
SELECT y.City
FROM(
    SELECT e.City, SUM(od.Quantity) as CityQuantity
    FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY e.City
) y 
WHERE y.CityQuantity =(
SELECT Max(CityQuantity) as MaxCityQuantity
FROM(
SELECT e.City, SUM(od.Quantity) as CityQuantity
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.City
) cq )