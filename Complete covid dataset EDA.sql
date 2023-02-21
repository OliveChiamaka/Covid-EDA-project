SELECT *
FROM portfolio_project..['Covid-data Death newest$'] 
WHERE continent IS NOT NULL
ORDER BY 3,4

SELECT *
FROM portfolio_project..['Covid-data Vaccination new$'] 
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM portfolio_project..['Covid-data Death newest$']
ORDER BY 1,2


SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_percentage
FROM portfolio_project..['Covid-data Death newest$']
WHERE location LIKE 'Nigeria'
ORDER BY 1,2


SELECT location, date, total_cases, population , (total_cases /population )*100 AS infected_population_percentage
FROM portfolio_project..['Covid-data Death newest$']
WHERE location LIKE 'Nigeria'
ORDER BY 1,2


SELECT location, MAX(total_cases) AS highest_infection_count, population , MAX((total_cases /population ))*100 AS infected_population_percentage
FROM portfolio_project..['Covid-data Death newest$']
GROUP BY location, population 
ORDER BY infected_population_percentage DESC

SELECT location, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM portfolio_project ..['Covid-data Death newest$'] 
WHERE continent IS NOT NULL
GROUP BY location 
ORDER BY total_death_count DESC


SELECT continent , MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM portfolio_project ..['Covid-data Death newest$'] 
WHERE continent IS NOT NULL
GROUP BY continent  
ORDER BY total_death_count DESC


SELECT location , MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM portfolio_project ..['Covid-data Death newest$'] 
WHERE continent IS NOT NULL
GROUP BY location  
ORDER BY total_death_count DESC


SELECT date,SUM(new_cases) AS newest_cases, SUM(CAST(new_deaths AS INT)) AS newest_deaths, SUM(CAST(new_deaths AS INT))
/ SUM(new_cases)*100 AS new_death_percentage
FROM portfolio_project ..['Covid-data Death newest$'] 
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY new_death_percentage  DESC

SELECT SUM(new_cases) AS newest_cases, SUM(CAST(new_deaths AS INT)) AS newest_deaths, SUM(CAST(new_deaths AS INT))
/ SUM(new_cases)*100 AS new_death_percentage
FROM portfolio_project ..['Covid-data Death newest$'] 
WHERE continent IS NOT NULL
ORDER BY new_death_percentage  DESC

SELECT*
FROM portfolio_project ..['Covid-data Death newest$'] dea
JOIN portfolio_project ..['Covid-data Vaccination new$'] vac
	ON dea.location = vac.location 
	AND dea.date = vac.date


SELECT dea.continent, dea.location , dea.date , dea.population, vac.new_vaccinations 
FROM portfolio_project ..['Covid-data Death newest$'] dea
JOIN portfolio_project ..['Covid-data Vaccination new$'] vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


SELECT dea.continent, dea.location , dea.date , dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS rolling_peopele_vaccinated
FROM portfolio_project ..['Covid-data Death newest$'] dea
JOIN portfolio_project ..['Covid-data Vaccination new$'] vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
ORDER BY 2,3


WITH popvsvac(continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
AS
(
SELECT dea.continent, dea.location , dea.date , dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS rolling_peopele_vaccinated
FROM portfolio_project ..['Covid-data Death newest$'] dea
JOIN portfolio_project ..['Covid-data Vaccination new$'] vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
	WHERE dea.continent IS NOT NULl
)
SELECT*, (rolling_people_vaccinated/population)*100 AS percent_people_vaccinated
FROM popvsvac 


USE portfolio_project 
GO
CREATE VIEW percent_people_vaccinated AS
SELECT dea.continent, dea.location , dea.date , dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS rolling_peopele_vaccinated
FROM portfolio_project ..['Covid-data Death newest$'] dea
JOIN portfolio_project ..['Covid-data Vaccination new$'] vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL


USE portfolio_project 
GO
CREATE VIEW new_death_percentage AS
SELECT SUM(new_cases) AS newest_cases, SUM(CAST(new_deaths AS INT)) AS newest_deaths, SUM(CAST(new_deaths AS INT))
/ SUM(new_cases)*100 AS new_death_percentage
FROM portfolio_project ..['Covid-data Death newest$'] 
WHERE continent IS NOT NULL
--ORDER BY new_death_percentage  DESC


USE portfolio_project 
GO
CREATE VIEW total_death_count AS
SELECT location , MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM portfolio_project ..['Covid-data Death newest$'] 
WHERE continent IS NOT NULL
GROUP BY location  
--ORDER BY total_death_count DESC

USE portfolio_project 
GO
CREATE VIEW infected_population_percentage AS
SELECT location, MAX(total_cases) AS highest_infection_count, population , MAX((total_cases /population ))*100 AS infected_population_percentage
FROM portfolio_project..['Covid-data Death newest$']
GROUP BY location, population 
--ORDER BY infected_population_percentage DESC

USE portfolio_project 
GO
CREATE VIEW nigeria_death_percentage AS
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_percentage
FROM portfolio_project..['Covid-data Death newest$']
WHERE location LIKE 'Nigeria'
--ORDER BY 1,2


USE portfolio_project 
GO
CREATE VIEW portfolio AS
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM portfolio_project..['Covid-data Death newest$']
--ORDER BY 1,2


USE portfolio_project 
GO
CREATE VIEW nigeria_infected_population_percentage AS
SELECT location, date, total_cases, population , (total_cases /population )*100 AS infected_population_percentage
FROM portfolio_project..['Covid-data Death newest$']
WHERE location LIKE 'Nigeria'
