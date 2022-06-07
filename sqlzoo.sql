//section 1
Q.Modify it to show the population of Germany
SELECT population FROM world
  WHERE name = 'Germany'

Q.Show the name and the population for 'Sweden', 'Norway' and 'Denmark'

SELECT name, population FROM world
  WHERE name IN ('Sweden', 'Norway', 'Denmark');

Q.Which countries are not too small and not too big? 
BETWEEN allows range checking (range specified is inclusive 
of boundary values). The example below shows countries with an area of 250,000-300,000 sq. km. Modify it to show the country and the area for 
countries with an area between 200,000 and 250,000

SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000

// section 2
Q.Show the name for the countries that have a population of at least 200 million. 200 million is 200000000, there are eight zeros

SELECT name FROM world
WHERE population > 200000000

Q.Give the name and the per capita GDP for those countries with a population of at least 200 million.

SELECT name, GDP/population
from world
WHERE population > 200000000

Q.Show the name and population in millions for the countries of the continent 'South America'. Divide the population by 1000000 to get population in millions

SELECT name, population/1000000
from world 
where continent like 'South America'

Q. Show the name and population for France, Germany, Italy

SELECT name, population
FROM world 
WHERE name IN ('France','Germany','Italy')

Q. Show the countries which have a name that includes the word 'United'

SELECT name
FROM world
WHERE name like 'United%'

Q. Show the countries that are big by area or big by population. Show name, population and area

SELECT name, population, area
FROM world
WHERE population > 250000000 OR area > 3000000

Q.Exclusive OR (XOR). Show the countries that are big by area (more than 3 million) or big by population (more than 250 million) but not both. Show name, population and area.

SELECT name, population, area
FROM world
WHERE area > 3000000 AND population < 250000000
OR area < 3000000 AND  population > 250000000

Q. For South America show population in millions and GDP in billions both to 2 decimal places.

SELECT name, ROUND(population/1000000, 2), ROUND(gdp/1000000000, 2) 
FROM world 
WHERE continent = 'South America'

Q. Show per-capita GDP for the trillion dollar countries to the nearest $1000

SELECT name, ROUND(gdp/population, -3) 
FROM world 
WHERE gdp > 1000000000000

Q. Find the country that has all the vowels and no spaces in its name
SELECT name
FROM world 
WHERE name LIKE '%a%' AND name LIKE '%e%' AND name LIKE '%i%' AND name LIKE '%o%' AND name LIKE '%u%' AND name NOT LIKE '% %'


//SECTION 3

Q.Change the query shown so that it displays Nobel prizes for 1950
SELECT yr, subject, winner
  FROM nobel
 WHERE yr = 1950

Q.Show who won the 1962 prize for literature

SELECT winner
  FROM nobel
 WHERE yr = 1962
   AND subject = 'literature'

Q.Show the year and subject that won 'Albert Einstein' his prize

Select yr, subject 
from nobel
where winner = 'Albert Einstein'

Q.Give the name of the 'peace' winners since the year 2000, including 2000.

select winner
from nobel 
where yr >= 2000 AND subject = 'peace'

Q.Show all details (yr, subject, winner) of the literature prize winners for 1980 to 1989 inclusive.

select *
from nobel
where subject = 'literature' AND yr
between 1980 and 1989

Q.Show all details of the presidential winners:

Theodore Roosevelt
Thomas Woodrow Wilson
Jimmy Carter
Barack Obama

SELECT * FROM nobel
 WHERE winner in ('Theodore Roosevelt','Woodrow Wilson','Jimmy Carter','Barack Obama')

Q.Show the winners with first name John
select winner 
from nobel 
where winner like 'John%'

Q.Show the year, subject, and name of physics winners for 1980 together with the chemistry winners for 1984.

select * 
from nobel
where subject = 'physics' and yr = 1980 
OR subject = 'chemistry' and yr = 1984

Q. Show the year, subject, and name of winners for 1980 excluding chemistry and medicine

select *
from nobel
where yr = 1980 AND
subject not like 'chemistry' 

Q.Show year, subject, and name of people who won a 'Medicine' prize in an early year (before 1910, not including 1910) together with winners of a 'Literature' prize in a later year (after 2004, including 2004)

select * 
from nobel
where subject = 'Medicine' AND yr < 1910
OR
 subject = 'Literature' AND yr >= 2004

Q.Find all details of the prize won by PETER GRÜNBERG

select *
from nobel
where winner = 'PETER GRÜNBERG'

Q.Find all details of the prize won by EUGENE O'NEILL

select * from nobel
 where winner = 'EUGENE O''NEILL'

Q.List the winners, year and subject where the winner starts with Sir. Show the the most recent first, then by name order.

select winner,yr,subject
from nobel
where winner like 'Sir%'
order by yr desc, winner

Q.Show the 1984 winners and subject ordered by subject and winner name; but list chemistry and physics last.
SELECT winner, subject, subject IN ('physics','chemistry')
  FROM nobel
 WHERE yr=1984
 ORDER BY subject,winner


//SECTION 4

Q.List each country name where the population is larger than that of 'Russia'

select name 
from world
where population >
(select population from world where name = 'Russia')



Q.Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.

select name
from world
where continent = 'Europe' and GDP/population >
(select GDP/population from world where name = 'United Kingdom')

Q.List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.

select name, continent
from world
where continent in
(select continent from world where name = 'Argentina' or name = 'Australia')

Q.Which country has a population that is more than United Kingom but less than Germany? Show the name and the population.

select name, population
from world 
where population > (select population from world where name = 'United Kingdom') AND
population <(select population from world where name = 'Germany')

Q.Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.

select name, CONCAT(ROUND(population/(select population from world where name = 'Germany')*100,0),'%')
from world
where continent = 'Europe'

Q.Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)

select name
from world
where GDP > all(select GDP from world where GDP in (select GDP from world where continent = 'Europe'))

Q.Find the largest country (by area) in each continent, show the continent, the name and the area

select continent, name, area
from world x
where area >= all (select area from world y where area>0 and x.continent =y.continent)

Q.List each continent and the name of the country that comes first alphabetically.

select continent, name
from world x 
where name <= all (select name from world y where x.continent = y.continent)

Q.Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.

select name, continent, population 
from world
where continent in
(select continent from world x where 25000000 >= (select max(population) from world y where x.continent = y.continent) )


Q.Some countries have populations more than three times that of all of their neighbours (in the same continent). Give the countries and continents.

select name, continent
from world x
where population > all(
  select population*3 from world y where x.continent = y.continent and x.name<>y.name
)

//SECTION 5

Q.Show the total population of the world.

SELECT SUM(population)
FROM world

Q.List all the continents - just once each.

select  distinct continent
from world

Q.Give the total GDP of Africa

select sum(gdp)
from world
where continent = 'Africa'

Q.How many countries have an area of at least 1000000

select count(name) as total_area
from world
where area >= 1000000

Q. What is the total population of ('Estonia', 'Latvia', 'Lithuania')

select sum(population)
from world
where name in ('Estonia','Latvia','Lithuania')

Q. For each continent show the continent and number of countries.

select continent, count(name) as total_countries
from world
group by continent

Q.For each continent show the continent and number of countries with populations of at least 10 million

select continent,count(name)
from world
where population > 10000000
group by continent

Q. List the continents that have a total population of at least 100 million.

select continent
from world x
where (select sum(population) from world y where x.continent = y.continent) >= 100000000
group by continent

//SECTION 6

Q.Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'


select matchid, player 
from goal
where teamid = 'GER'

Q.Show id, stadium, team1, team2 for just game 1012

SELECT id,stadium,team1,team2
  FROM game
where id = 1012


Q.Modify it to show the player, teamid, stadium and mdate for every German goal
SELECT player,teamid,stadium,mdate
  FROM game JOIN goal ON (id=matchid)
where teamid = 'GER'


Q.Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
select team1, team2, player
from game join goal on (id=matchid)
where player like 'Mario%'

Q. Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10

select player, teamid, coach, gtime
from eteam
join goal on teamid=id
where gtime<=10

Q.List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.

SELECT mdate,teamname
FROM game 
JOIN eteam on team1=eteam.id
where coach = 'Fernando Santos'

Q. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'

SELECT player 
FROM game
JOIN goal on id=matchid
WHERE stadium = 'National Stadium, Warsaw'


Q.Instead show the name of all players who scored a goal against Germany.

select distinct player 
from goal
join game on matchid = id
where (team1 = 'GER' or team2 = 'GER') and teamid <> 'GER'

Q.Show teamname and the total number of goals scored
select teamname,count(teamid)
from eteam 
join goal on id=teamid
group by teamname

Q. Show the stadium and the number of goals scored in each stadium.

select stadium, count(matchid)
from game 
join goal on matchid = id 
group by stadium

Q.For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid,mdate, count(player)
  FROM game JOIN goal ON matchid = id 
 WHERE (team1 = 'POL' OR team2 = 'POL')
group by goal.matchid

Q.For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
select matchid, mdate, count(player)
from game
join goal on id = matchid
where teamid = 'GER'
group by id

//SECTION 7

Q.Give year of 'Citizen Kane'

SELECT yr
FROM movie
WHERE title = 'Citizen Kane'

Q.List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.

SELECT id,title,yr
FROM movie
WHERE title LIKE 'Star Trek%'
ORDER BY yr 

Q.What id number does the actor 'Glenn Close' have?

SELECT id 
FROM actor 
WHERE name = 'Glenn Close'


Q.What is the id of the film 'Casablanca'
SELECT id 
FROM movie
WHERE title = 'Casablanca'

Q.Obtain the cast list for 'Casablanca'.
SELECT name
FROM actor
JOIN casting
ON actorid = id
WHERE movieid = (SELECT id FROM movie WHERE title = 'Casablanca');

Q. Obtain the cast list for the film 'Alien'

SELECT name
FROM actor
JOIN casting
ON actorid = id
WHERE movieid = (SELECT id from movie WHERE title = 'Alien')

Q. List the films in which 'Harrison Ford' has appeared
SELECT movie.title
FROM movie
JOIN casting
ON casting.movieid = movie.id
JOIN actor
ON actor.id = casting.actorid
WHERE actor.name = 'Harrison Ford'