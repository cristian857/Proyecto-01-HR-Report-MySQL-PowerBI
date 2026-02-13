-- =================================================================================================================
--                                       PROYECTO 1 - HR EMPLOYEE REPORT            
-- =================================================================================================================
-- ----------------------------------------------------------------------------------------------------------------- 
/* En las siguientes consultas se resuelven preguntas acerca de la información requerida para el análisis del reporte, 
Se implementan subconsultas, al igual que cláusulas como: SELECT, WHERE, GROUP BY, ORDER BY, CASE 
y funciones como: COUNT, DATEDIFF, SUM, ROUND, CURDATE, DATE_FORMAT.
*/
-- ------------------------------------------------------------------------------------------------------------------

-- Selecciona la base de datos a trabajar
USE proyecto_1;

-- 1. ¿Cuál es la distribución por género de los empleados en la empresa?
--    What is the gender breakdown of employees in the company?

SELECT gender, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY gender;

-- 2. ¿Cuál es la distribución racial/etnicidad de los empleados en la empresa?
--    What is the race/ethnicity breakdown of employees in the company?

SELECT race, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY COUNT(*) DESC;   

-- 3. ¿Cuál es la distribución por edad de los empleados en la empresa?
--    What is the age distribution of employees in the company?
SELECT MIN(age) AS youngest, MAX(age) AS oldest
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00';

SELECT
	CASE 
		WHEN age >= 18 AND age <= 24 THEN '18-24'
		WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
	END AS age_group,
    COUNT(*) AS count
FROM hr 
WHERE age>= 18 AND termdate = '0000-00-00'
GROUP BY age_group
ORDER BY age_group;

-- 3.1 ¿Cuál es la distribución por edad y género de los empleados en la empresa?
--     What is the age-gender distribution of employees in the company?

SELECT
	CASE 
		WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
	END AS age_group, gender,
    COUNT(*) AS count
FROM hr 
WHERE age>= 18 AND termdate = '0000-00-00'
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. ¿Cuántos empleados trabajan en la sede central frente a ubicaciones remotas?
--    How many employees work at headquarters versus remote locations?

SELECT location, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location;

-- 5. ¿Cuál es la duración promedio del empleo de los colaboradores que han sido despedidos?
-- 	  What is the average length of employment for employees who have been terminated?

SELECT
	ROUND(AVG(DATEDIFF(termdate, hire_date))/365, 0) AS avg_length_employment
FROM hr
WHERE termdate <= CURDATE() AND termdate <> '0000-00-00' AND age >= 18; 
    
-- 6. ¿Cómo varía la distribución de género entre los departamentos de la empresa?
--    How does the gender distribution vary across departments?

SELECT department, gender, COUNT(*) AS count
FROM hr
WHERE age >=18 AND termdate = '0000-00-00'
GROUP BY department, gender
ORDER BY department;

-- 7. ¿Cuál es la distribución de los puestos de trabajo en la empresa?
--    What is the distribution of jobs titles across the company?

SELECT jobtitle, COUNT(*) AS COUNT
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. ¿Qué departamento tiene la tasa de rotación más alta?
--    Which department has the highest turnover rate?

SELECT department, 
	total_count,
    terminated_count,
    terminated_count/total_count as termination_rate
FROM (
	SELECT department, 
    COUNT(*) AS total_count,
    SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr 
    WHERE age >= 18
    GROUP BY department
    ) AS subquery
ORDER BY termination_rate DESC;

-- 9. ¿Cuál es la distribución de empleados en las distintas ubicaciones por estado?
--    What is the distribution of employees across locations by state?

SELECT location_state, COUNT(*) AS count
FROM hr 
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY count DESC;

-- 10. ¿Cómo ha cambiado el número de empleados de la empresa a lo largo del tiempo 
--     en función de las fechas de contratación y de salida?
--     How has the company's employee count changed over time based on hire and term dates?

SELECT 
	YEAR,
    hires,
    terminations,
    hires - terminations AS net_change,
    ROUND((hires - terminations)/hires*100, 2) AS net_change_percent
FROM(
	SELECT 
		YEAR(hire_date) AS YEAR,
        COUNT(*) AS hires,
        SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
	FROM hr
	WHERE age >= 18
	GROUP BY YEAR(hire_date)
	) AS subquery
ORDER BY YEAR ASC;
        
-- 11. ¿Cuál es la distribución de la permanencia por cada departamento de la empresa?
--     What is the tenure distribution for each department?

SELECT department, ROUND(AVG(DATEDIFF(termdate, hire_date)/365),0) AS avg_tenure
FROM hr
WHERE termdate <= CURDATE() AND termdate <> '0000-00-00' AND age >= 18
GROUP BY department
ORDER BY avg_tenure DESC;
