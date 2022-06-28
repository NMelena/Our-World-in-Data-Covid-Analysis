
--Show entire table sorted by Country and Date
select *
From Portfolio_Project..CovidDeaths
Where location = 'United States'
order by 3,4


select  location, date, total_cases, new_cases, total_deaths, population
From Portfolio_Project..CovidDeaths
order by 1,2


--Total Cases Vs. Total Deaths
--Shows the rate at which people infected by Covid 19 die
select  continent, location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Rate 
From Portfolio_Project..CovidDeaths
Where continent is not null
--And location = 'United States'
order by 1,2


--Total Cases vs Population
--Shows what % of the Population has been infected by Covid 19
select  continent, location, date, total_cases, population, (total_cases/population)*100 as Level_of_Infection
From Portfolio_Project..CovidDeaths
Where continent Is not null
--And location = 'United States'
order by 1,2


-- Countries with Highest Infection Rate
select  continent, location, population, max (total_cases) as Highest_Infection_Count, (Max(total_cases/population)*100) as Level_of_Infection
From Portfolio_Project..CovidDeaths
Where continent Is not null
Group by population, continent, location
order by Level_of_Infection desc


-- Countries with Highest Death Count 
select  continent, location, Max(cast(total_deaths as int)) as Total_Death_Count
From Portfolio_Project..CovidDeaths
Where continent Is not null
Group by continent, location
order by Total_Death_Count desc


-- Countries with Highest Death Rate per million people
select  continent, location, Max(cast(total_deaths_per_million as decimal)) as total_deaths_per_million
From Portfolio_Project..CovidDeaths
Where continent Is not null
Group by location, continent
order by total_deaths_per_million desc


-- Continent + Income Level with Highest Death Count
select  location, Max(cast(total_deaths as int)) as Total_Death_Count
From Portfolio_Project..CovidDeaths
Where continent Is null
Group by location
order by Total_Death_Count desc


--Continent + Income Level with Highest Death Rate per million people
select  location, Max(cast(total_deaths as int)) as Total_Death_Count, population,  Max(cast(total_deaths as int))/population * 1000000 as death_rate_per_million
From Portfolio_Project..CovidDeaths
Where continent Is null 
and population is not null
Group by location, population
order by death_rate_per_million desc


--Total Cases Vs. Total Deaths for the entire World
--Shows the rate at which people infected by Covid 19 die
select  Sum( new_cases) as total_cases, Sum (cast(new_deaths as int)) as total_deaths, Sum (cast(new_deaths as int))/Sum( new_cases)*100 as death_rate
From Portfolio_Project..CovidDeaths
Where continent is not null
order by 1,2


-- Shows the running total of Vaccine does given 
select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert (bigint, vac.new_vaccinations)) Over (Partition by dea.location order by dea.location, dea.date) as rolling_vaccine_doeses
From Portfolio_Project..CovidDeaths dea
Join Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--and dea.location = 'United States'
order by 2,3


--Number of vaccine does given vs. Population
with PopvsVac (Continent, Location, Date, Population, new_vaccinations, rolling_people_vaccinated )
as
(
select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert (bigint, vac.new_vaccinations)) Over (Partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated 
From Portfolio_Project..CovidDeaths dea
Join Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null 
And dea.location = 'United States'
)
select *, (rolling_people_vaccinated/Population) as number_of_vaccines_per_person
From PopvsVac
