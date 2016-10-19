/* MODIFICATION SET QUESTIONS - MOVIE RATING EXERCISE - LAGUNITA STANFORD SQL COURSE */

/*Q.1. 'Lagunita Stanford SQL Course' */
/* Add the reviewer Roger Ebert to your database, with an rID of 209 */

insert into reviewer values(209, 'Roger Ebert');

/*Q.2. 'Lagunita Stanford SQL Course' */
/* Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. */

/* movies directed by James Cameron */

insert into rating
select rating.rID, movie.mID, 5 as stars, null as ratingDate
from movie, reviewer, rating
where rating.rID = reviewer.rID
	and reviewer.name= 'James Cameron';

/* check */	

select * from rating;

/*Q.3. 'Lagunita Stanford SQL Course' */
/* For all movies that have an average rating of 4 stars or higher,
 add 25 to the release year. (Update the existing tuples; don't insert new tuples.)  */
 
update movie
set year = year + 25
where mID in (select movie.mID
					from movie, rating
					where movie.mID = rating.mID
					group by movie.mID
					having avg(stars) >= 4);
					
/*Q.4. 'Lagunita Stanford SQL Course' */
/* Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.  */				

delete from rating
where mID in (select movie.mID
					from movie, rating
					where movie.mID = rating.mID
						and (year < 1970 or year >2000))
	and stars < 4;
 