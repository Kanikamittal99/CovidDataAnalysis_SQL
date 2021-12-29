
Select *
From PortfolioProjects..CovidDeaths
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
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjects..CovidDeaths
Where location = 'India'
Order by 1,2