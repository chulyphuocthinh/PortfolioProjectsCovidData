Select location, population
From PorfolioProjects..CovidDeaths
Where continent is null
group by location, population
order by population desc

--Select *
--From PorfolioProjects..CovidVaccinations
--order by 3,4


Select location, date, total_cases, new_cases, total_deaths, population
From PorfolioProjects..CovidDeaths
Where continent is not null
order by 1,2

--Looking at total cases vs total deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PorfolioProjects..CovidDeaths
Where location like 'vietnam'
order by 1,2

--looking at total cases vs population
Select location, date, total_cases, population, (total_cases/population)*100 as CasesPercentage
From PorfolioProjects..CovidDeaths
--Where location like 'vietnam'
Where continent is not null
order by 1,2


--Looking at Couontries with Highest Infection Rate compated to Population
Select location, population, Max(Total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PorfolioProjects..CovidDeaths
Where continent is not null
Group by location, population
--Where location like 'vietnam'
order by PercentPopulationInfected desc;

-- Showing countries with highest  Death Count per Population

Select location, population, Max(Cast(total_deaths as bigint)) as DeathCounts, Max((Total_deaths/population))*100 as DeathCountPerPopulation
From PorfolioProjects..CovidDeaths
Where continent is not null
Group By location, population
Order by DeathCounts Desc;

--Showing deathcounts per continent

Select continent, Max(Cast(total_deaths as bigint)) as DeathCounts
From PorfolioProjects..CovidDeaths
Where continent is not null 
Group By continent
Order by DeathCounts Desc;

-- Showing continents with highest death count per population
Select continent, Max(Cast(total_deaths as bigint)) as DeathCounts
From PorfolioProjects..CovidDeaths
Where continent is not null 
Group By continent
Order by DeathCounts Desc;

--Global Numbers

Select Sum(new_cases) as TotalCases, Sum (Cast(New_deaths as bigint)) as TotalDeaths, Sum (Cast(New_deaths as bigint))/Sum(new_cases)*100 as DeathPercentage
From PorfolioProjects..CovidDeaths
Where continent is not null 
--Group By date
Order by 1,2 Desc;


--USE CTE
With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(Cast(vac.new_vaccinations as bigint)) Over (Partition by dea.location Order by dea.location, dea.date) as RollinngPeopleVaccinated
--,RollinngPeopleVaccinated/population*100
From PorfolioProjects..CovidDeaths dea
Join PorfolioProjects..CovidVaccinations vac
 ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--Creating View to store data later for visualiaztion

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(Cast(vac.new_vaccinations as bigint)) Over (Partition by dea.location Order by dea.location, dea.date) as RollinngPeopleVaccinated
--,RollinngPeopleVaccinated/population*100
From PorfolioProjects..CovidDeaths dea
Join PorfolioProjects..CovidVaccinations vac
 ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3

Select *
From PercentPopulationVaccinated
