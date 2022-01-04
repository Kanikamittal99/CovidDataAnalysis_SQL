
Select *
From PortfolioProjects..CovidDeaths
where continent is not null
Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjects..CovidDeaths
Order by 1,2
 

 -- Modifying VARCHAR to FLOAT

ALTER TABLE PortfolioProjects..CovidDeaths
ALTER COLUMN total_deaths float


-- Countries with Highest Death Count per Population

Select Location, MAX(Total_deaths) as TotalDeathCount
From PortfolioProjects..CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc


-- Total Deaths vs total Cases

Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjects..CovidDeaths
Where location = 'India'
and continent is not null 
order by 1,2


-- Case fatality Rate
-- Shows likelihood of dying if you contract covid in your country 

Select location, MAX(total_cases) as HighestCasesCount, MAX(total_deaths) as HighestDeathCount, round((MAX(total_deaths)/MAX(total_cases))*100,2) as 'CaseFatalityRate(%)'
From PortfolioProjects..CovidDeaths
Where continent is not null 
group by location
order by [CaseFatalityRate(%)] desc


-- Mortality Rate

Select location, population, MAX(total_deaths) as HighestDeathCount, MAX(total_deaths/population)*100 as 'MortalityRate(%)'
From PortfolioProjects..CovidDeaths
Where continent is not null 
group by location, population
order by [MortalityRate(%)] desc
 
 
-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProjects..CovidDeaths
Where location = 'India'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProjects..CovidDeaths
Where continent is not null 
Group by Location, Population
order by PercentPopulationInfected desc


--Percentage of infected people died 

Select location, MAX(cast(total_deaths as int)) as HighestDeathCount, MAX(total_cases) , round(MAX(cast(total_deaths as int)/total_cases)*100,2) as PercentInfectedDied
From PortfolioProjects..CovidDeaths
where location = 'India'
and continent is not null
Group by location
Order by PercentInfectedDied desc


-- BREAKING THINGS DOWN BY CONTINENT
-- Showing continents with the highest death count per population

Select location, MAX(total_deaths) as TotalDeathCount 
From PortfolioProjects..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProjects..CovidDeaths
where continent is not null
order by 1,2

--By date

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProjects..CovidDeaths
where continent is not null
group by date
order by 1,2


-- Total Population vs Vaccinations
-- Shows percentage of population that has received at least one covid vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations AS int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths dea
join PortfolioProjects..CovidVaccinations vac 
	on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations AS int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated

From PortfolioProjects..CovidDeaths dea
join PortfolioProjects..CovidVaccinations vac 
	on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
)
Select * , (RollingPeopleVaccinated/population)*100
From PopvsVac


-- Using TEMP TABLE to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths dea
join PortfolioProjects..CovidVaccinations vac 
	on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
order by 2,3

Select * , (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths dea
join PortfolioProjects..CovidVaccinations vac 
	on vac.location = dea.location
	and vac.date = dea.date
where dea.continent is not null
--order by 2,3

select * 
From PercentPopulationVaccinated