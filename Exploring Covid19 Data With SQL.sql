Select *
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER by 3,4

--Select *
--FROM PortfolioProject..CovidVacs
--ORDER by 3,4

Select location, date, total_cases,new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER by 1,2

-- Show the likelihood of dying of you contract covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%switzerland%'
ORDER by 1,2

-- Shows what percentage of population got covid
Select location, date, population, total_cases, (total_cases/population)*100 as CovidPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%switzerland%'
ORDER by 1,2

--Looking at countries with the highest infection rate compared to population
Select location, population, MAX(total_cases) AS  HighestInfectionCount,
MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location like '%switzerland%'
GROUP BY location, population
ORDER BY PercentPopulationInfected desc

-- Showing countries with the highest death percentage
Select location, population, MAX(total_deaths) AS  HighestDeath,
MAX((total_deaths/population))*100 as PercentPopulationDeath
FROM PortfolioProject..CovidDeaths
--WHERE location like '%switzerland%'
GROUP BY location, population
ORDER BY PercentPopulationDeath desc

-- Showing countries with the highest death count
Select location, MAX(cast(total_deaths as INT)) AS  TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%switzerland%'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

--Breaking things down by continent
Select location, MAX(cast(total_deaths as INT)) AS  TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%switzerland%'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

-- Global Numbers
Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as INT)) as total_deaths, SUM(cast(new_deaths as INT))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%switzerland%'
WHERE continent is not null
--GROUP BY date
ORDER by 1,2

--Looking at total population vs vaccinations
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location Order by dea.location, dea.date ) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVacs vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
--ORDER by 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

-- Temp Table
DROP Table if exists #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
( Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated

SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location Order by dea.location, dea.date ) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVacs vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
--ORDER by 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

--Creating view to store data for later visualisations

Create View PercentPopulationVaccinated as
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location Order by dea.location, dea.date ) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVacs vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
--ORDER by 2,3

SELECT *
From PercentPopulationVaccinated