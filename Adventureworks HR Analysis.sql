--Individual Queries were used to get the required data from the tables of interest.
--They were loaded individually to power bi as different tables.

-- Employee Fact Table
SELECT employee.EmployeeId,
       CONCAT(FirstName," ",LastName) as EmployeeName,
       ManagerID,
       employee.Title,
       Department,
       ShiftID,
       BirthDate,
       MaritalStatus,
       Gender,
       HireDate,
       SalariedFlag,
       VacationHours,
       SickLeaveHours,
FROM `adwentureworks_db.employee` as employee
LEFT JOIN `adwentureworks_db.contact` as contact 
ON employee.ContactID = contact.ContactId
LEFT JOIN `adwentureworks_db.employeedepartmenthistory` as emp_dept_history
ON employee.EmployeeId = emp_dept_history.EmployeeID
LEFT JOIN `adwentureworks_db.department` as department
ON department.DepartmentID = emp_dept_history.DepartmentID
WHERE EndDate IS NULL;

--Employee Department History Dimension Table
SELECT EmployeeID,
       emp_dept_history.DepartmentID,
       StartDate,
       EndDate
FROM `adwentureworks_db.employeedepartmenthistory` as emp_dept_history
LEFT JOIN `adwentureworks_db.department` as department
ON department.DepartmentID = emp_dept_history.DepartmentID;

--Employee Shift Dimension Table
SELECT ShiftID, 
       Name
FROM `adwentureworks_db.shift` as shift;

-- Employee Address Dimension Table
SELECT EmployeeID,
       address.city as City,
       province.Name as State,
       country.Name as Country
FROM `adwentureworks_db.employeeaddress` as employee_address
LEFT JOIN `adwentureworks_db.address` as address
ON employee_address.AddressID = address.AddressID
LEFT JOIN `adwentureworks_db.stateprovince` as province
ON address.StateProvinceID = province.StateProvinceID
LEFT JOIN `adwentureworks_db.countryregion` as country
ON province.CountryRegionCode = country.CountryRegionCode;

-- Department Pay Dimension Table
SELECT Name as Department,
       AVG(Rate) as Rate
FROM `adwentureworks_db.employeepayhistory` as employee_pay
LEFT JOIN `adwentureworks_db.employeedepartmenthistory` as dept
ON employee_pay.EmployeeID = dept.EmployeeID
LEFT JOIN `adwentureworks_db.department` as dept_
ON dept_.DepartmentID = dept.DepartmentID
GROUP BY Name
ORDER BY Rate DESC;

--Employee Pay Dimension table
SELECT EmployeeID,
       MAX(Rate) as Rate,
FROM `adwentureworks_db.employeepayhistory` as emp_pay
GROUP BY EmployeeID;


