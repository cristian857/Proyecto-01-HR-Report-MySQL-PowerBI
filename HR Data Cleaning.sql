-- =================================================================================================================
--                                       PROYECTO 1 - HR EMPLOYEE REPORT            
-- =================================================================================================================

-- ----------------------------------------------------------------------------------------------------------------- 
/* En las siguientes consultas se realiza la limpieza y preparación de datos, detro de las operaciones 
que se realizan están: crear la base de datos "proyecto_1", importar los datos  desde el archivo Human Resources.csv 
con lo cual se crea la tabla "hr" que contiene la información, renombrar algunas columnas, 
actualizar valores en los registros y columnas, cambiar el tipo de dato de algunas columnas, modificar formatos, 
agregar nuevas columnas, cálculos con fechas. Se implementaron cláusulas como:
CREATE, SELECT, UPDATE, DESCRIBE, CASE, ALTER, WHERE y funciones como: MIN, MAX, COUNT, CURDATE, DATE_FORMAT, 
STR_TO_DATE, TIMESTAMPDIFF.
*/
-- -----------------------------------------------------------------------------------------------------------------

-- Crea base de datos "proyecto_1"
CREATE DATABASE proyecto_1;

-- Selecciona la base de datos a trabajar
USE proyecto_1;

-- Permite realizar modificaciones
-- -- Activa/Desactiva Modo Seguro - 0 desactivar - 1 activar
SET sql_mode = 'ALLOW_INVALID_DATES';

SET sql_safe_updates = 0;

-- Explora información de la tabla "hr"
SELECT * FROM hr;

-- Modifica columna a "emp_id"
ALTER TABLE hr CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

DESCRIBE hr;

-- Ajusta formato de fecha de columna "birthdate"
UPDATE hr 
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

SELECT birthdate FROM hr;

-- Ajusta columna "birthdate" a tipo de dato fecha 
ALTER TABLE hr MODIFY COLUMN birthdate DATE;

-- Ajusta formato de fecha de columna "hire_date"
UPDATE hr 
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

-- Ajusta columna "hire_date" a tipo de dato fecha 
ALTER TABLE hr MODIFY COLUMN hire_date DATE;

SELECT hire_date FROM hr;

-- Extrae fecha y ajusta columna "termdate"
UPDATE hr 
SET termdate = DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != '';

UPDATE IGNORE hr
SET termdate = '0000-00-00'
WHERE termdate IS NULL;

UPDATE IGNORE hr
SET termdate = STR_TO_DATE(termdate, '%Y-%m-%d');

ALTER TABLE hr MODIFY COLUMN termdate DATE;

SELECT termdate FROM hr;

-- Agrega columna "age"
ALTER TABLE hr ADD COLUMN age INT;

-- Calcula y actualiza valores de la columna "age"
UPDATE hr
SET age = TIMESTAMPDIFF(year, birthdate, CURDATE());

SELECT birthdate, age FROM hr;

-- Explora columna "age"
SELECT
	MIN(age) AS youngest,
    MAX(age) AS oldest
FROM hr;

SELECT COUNT(*) 
FROM hr 
WHERE age < 18;