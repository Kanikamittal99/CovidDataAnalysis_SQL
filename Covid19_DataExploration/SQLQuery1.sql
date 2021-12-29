
Select *
From PortfolioProjects..CovidDeaths
where continent is not null
Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjects..CovidDeaths
Order by 1,2
 
 --Total cases vs Total Deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjects..CovidDeaths
Where location = 'India'
Order by 1,2

 --Total cases vs Population
Select location, date, population,total_cases, round((total_cases/population)*100,2) as DeathPercentage
From PortfolioProjects..CovidDeaths
-- Where location = 'India' or location like '%states%'
Order by 1,2

-- Countries with Highest Infection Rate compared to their population
Select location, population, MAX(total_cases) as HighestInfectionCount, round(MAX((total_cases/population))*100,2) as PercentPopulationInfected
From PortfolioProjects..CovidDeaths
where location = 'India'
Group by location,population
Order by PercentPopulationInfected desc


--How much percentage of infected died 
Select location, SUM(cast(total_deaths as int)) as TotalDeathCount, round((SUM(cast(total_deaths as int))/SUM(total_cases))*100,2) as PercentInfectedDied
From PortfolioProjects..CovidDeaths
where location = 'India'
and continent is not null
Group by location
Order by PercentInfectedDied desc


-- Countries with highest death count per population
Select location, MAX(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProjects..CovidDeaths
where continent is not null
Group by location
Order by HighestDeathCount desc



