/* Q.1. 'Lagunita Stanford SQL Course' */
/*Find the titles of all movies directed by Steven Spielberg. */
select title 
from movie 
where director = 'Steven Spielberg';

/* Q.2. 'Lagunita Stanford SQL Course' */
/*Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.  */
select distinct year
from movie M, rating R
where M.mID = R.mID and (R.stars = 4 or R.stars =5)
order by year asc;

/* Q.3. 'Lagunita Stanford SQL Course' */
/*Find the titles of all movies that have no ratings.   */
select title
from movie M
left join rating R
on M.mID = R.mID
where R.mID is null;

/* Q.4. 'Lagunita Stanford SQL Course' */
/*Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.   */
select name
from reviewer
inner join rating using (rID)
where ratingDate is null;

/* Q.5. 'Lagunita Stanford SQL Course' */
/*Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. 
Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.   */
select distinct Re.name as 'Reviewer Name', M.title as 'Movie Title', Ra.stars, Ra.ratingDate
from (movie M inner join rating Ra using (mID)) inner join reviewer Re using (rID)
order by Re.name, M.title, Ra.stars, Ra.ratingDate;

/* Q.6. 'Lagunita Stanford SQL Course' */
/*For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, 
return the reviewer's name and the title of the movie.   */
select name, title
from movie, reviewer,
	(select R1.rID, R1.mID
	from rating R1, rating R2
	where R1.rID = R2.rID and R1.mID = R2.mID
	and R1.stars < R2.stars and R1.ratingDate < R2.ratingDate) C
where movie.mID = C.mID and reviewer.rID = C.rID;

/* Q.7. 'Lagunita Stanford SQL Course' */
/*For each movie that has at least one rating, find the highest number of stars that movie received. 
Return the movie title and number of stars. Sort by movie title.  */
select title, max(stars)
from movie, rating
where movie.mID = rating.mID
group by rating.mID
order by title;

/* Q.8. 'Lagunita Stanford SQL Course' */
/*For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. 
Sort by rating spread from highest to lowest, then by movie title.   */
select title, abs(max(stars)-min(stars)) as 'rating_spread'
from movie, rating
where movie.mID = rating.mID
group by rating.mID
order by rating_spread desc, title;

/* Q.9. 'Lagunita Stanford SQL Course' */
/*Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
Don't just calculate the overall average rating before and after 1980.)  
QUERY WORKS IN SQL LITE BUT NOT IN HEIDI!!!*/
select before80.avgbelow80 - after80.avgabove80
from     (select avg(avgtemp) as avgbelow80 
			from
				(select title, avg(stars) avgtemp
				from movie, rating
				where movie.mID = rating.mID and year < 1980
				group by title) 
			)  before80,
	
			(select avg(avgtemp) as avgabove80
			from
				(select title, avg(stars) avgtemp
				from movie, rating
				where movie.mID = rating.mID and year > 1980
				group by title) 
			)  after80;
			
