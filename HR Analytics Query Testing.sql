--Using SQL to test if data is corresponding with data visualization

SELECT * FROM hrdata
--Testing KPI
--Employee Count
SELECT SUM(employee_count) AS employee_count
FROM hrdata
--WHERE education = 'High School'
--WHERE department = 'Sales'

--Attrition Count
SELECT COUNT(attrition) AS attrition_count
FROM hrdata
WHERE attrition = 'Yes'
AND department ='R&D'
AND education_field ='Medical'
AND education ='High School'

--Attrition Rate
SELECT ROUND((((SELECT COUNT(attrition) FROM hrdata 
WHERE attrition ='Yes' --AND department ='Sales'
)/ SUM(employee_count)) * 100), 2) 
FROM hrdata  
--WHERE department ='Sales'

--Active Employees
SELECT (SUM(employee_count) - 
(SELECT COUNT(attrition) FROM hrdata WHERE attrition ='Yes' 
--AND gender ='Male'
)) 
AS Active_Employee
FROM hrdata
--WHERE gender ='Male'

--Avg Age
SELECT ROUND(AVG(age), 0) FROM hrdata
WHERE department = 'R&D'

--Testing Attrition By Gender

SELECT gender, COUNT(attrition)
FROM hrdata
WHERE attrition ='Yes' AND education = 'High School'
GROUP BY gender
ORDER BY COUNT(attrition) DESC

--Department wise Attrition
SELECT department, COUNT(attrition),
ROUND((CAST(COUNT(attrition) AS numeric) / 
(SELECT COUNT(attrition) 
FROM hrdata WHERE attrition= 'Yes' AND gender ='Female')) * 100, 2) AS pct
FROM hrdata
WHERE attrition = 'Yes' AND gender = 'Female'
GROUP BY department
ORDER BY COUNT(attrition) DESC

--Number of Employees by Age Group
SELECT age, SUM(employee_count)
FROM hrdata
GROUP BY age
ORDER BY age

--Education Field Attrition
SELECT education_field, COUNT(attrition)
FROM hrdata
WHERE attrition ='Yes' AND gender = 'Female'
GROUP BY education_field
ORDER BY COUNT(attrition) DESC


-- Atrition By AGE GROUP 
SELECT age_band, gender, COUNT(attrition) as attrition,
ROUND((CAST(COUNT(attrition) AS numeric) / 
(SELECT COUNT(attrition) FROM hrdata WHERE attrition ='Yes')) *100, 2) as pct
FROM hrdata
WHERE attrition ='Yes'
GROUP BY age_band, gender
ORDER BY age_band


--Job Satisfaction Rating using Crosstab
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT *
FROM crosstab(
  'SELECT job_role, job_satisfaction, sum(employee_count)
   FROM hrdata
   GROUP BY job_role, job_satisfaction
   ORDER BY job_role, job_satisfaction'
	) AS ct(job_role varchar(50), one numeric, two numeric, three numeric, four numeric)
ORDER BY job_role;


SELECT age_band, gender, COUNT(attrition)
FROM hrdata
GROUP BY age_band, gender
ORDER BY age_band, gender




