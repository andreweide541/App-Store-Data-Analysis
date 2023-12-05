CREATE TABLE applestore_description_combined AS

SELECT * from appleStore_description1

union ALL

select * from appleStore_description2

union ALL

select * from appleStore_description3

union ALL

SELECT * from appleStore_description4

**Exloratory Data Analysis**AppleStore

--check the number of unique apps in both tables

SELECT count(distinct id) as uniqueID
from AppleStore

SELECT count(distinct id) as uniqueID
from applestore_description_combined

--check for missing values in key fields

select count(*) as MissingValues
from AppleStore
where track_name is null or user_rating is null or prime_genre is null

SELECT count(*) as MissingValues
from applestore_description_combined
Where app_desc is null

--count the number of apps in each genre

Select prime_genre, count(*) as NumApps
from AppleStore
group by prime_genre
order by NumApps desc

--get an overview of the apps' ratings

SELECT min(user_rating) as MinRating,
	   max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
from AppleStore

--determine whether paid apps are higher rated than free apps

SELECT CASE
			when price > 0 then 'Paid'
            Else 'Free'
		End as AppType,
        avg(user_rating) as AvgRating,
        count(*) as NumRatings
from AppleStore
group by AppType

--check if apps with more supported languages have higher ratings

SELECT CASE
			when lang_num < 10 then 'Less than 10 languages'
            when lang_num between 10 and 30 then '10 to 30 languages'
            Else 'More than 30 languages'
		End as NumLanguages,
        avg(user_rating) as AvgRating,
        count(*) as NumRatings
From AppleStore
group by NumLanguages
order by AvgRating desc

--check the apps with the lowest ratings

select prime_genre,
	   avg(user_rating) as AvgRating,
       count(*) as NumRatings
from AppleStore
GROUP by prime_genre
order by AvgRating asc
limit 10

--check if app description length affects average user rating

select CASE
			when length(ADC.app_desc) < 500 Then 'Short'	
			when length(ADC.app_desc) between 500 and 1000 Then 'Medium'
            else 'Long'
		end as DescLength,
        avg(user_rating) as AvgRating,
        count(*) as NumRatings

from 
	AppleStore A
JOIN
	applestore_description_combined as ADC
on 
	A.id = ADC.id
Group by DescLength
Order by AvgRating DESC

--check the top apps in each genre

SELECT
	prime_genre,
    track_name,
    user_rating
from (
		SELECT
 		prime_genre,
  		track_name,
  		user_rating,
  		RANK () OVER(Partition by prime_genre order by user_rating desc, rating_count_tot DESC) as Rank
  		from AppleStore
	)   AS a
WHERE
a.Rank = 1



