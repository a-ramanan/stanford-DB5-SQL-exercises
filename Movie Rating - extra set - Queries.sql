/* EXTRA SET QUESTIONS - MOVIE RATING EXERCISE - LAGUNITA STANFORD SQL COURSE */

/*Q.1. 'Lagunita Stanford SQL Course' */
/* Find the names of all reviewers who rated Gone with the Wind. */

select distinct name
from reviewer, 
	( select rID, title
		from rating, movie
		where rating.mID = movie.mID and movie.title = 'Gone with the Wind'
	) C
where reviewer.rID = C.rID;

select distinct name
from movie, rating, reviewer
where rating.rID = reviewer.rID and rating.mID = movie.mID
	and movie.title = 'Gone with the Wind';


/*Q.2. 'Lagunita Stanford SQL Course' */
/*  For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. */

select name, title, stars
from movie, rating, reviewer
where rating.rID = reviewer.rID and rating.mID = movie.mID
	and reviewer.name = movie.director;
	
/*Q.3. 'Lagunita Stanford SQL Course' */
/* Return all reviewer names and movie names together in a single list, alphabetized. 
(Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)   */
select name
from
	(select name from reviewer
	union 
	select title from movie) as Name
order by name;

/*Q.4. 'Lagunita Stanford SQL Course' */
/*  Find the titles of all movies not reviewed by Chris Jackson. */
/* This doesn't work in Heidi, but in SQLLite  ('except' doesnt't) */
select title
from movie
except
select title
from movie, rating, reviewer
where movie.mID = rating.mID and rating.rID = reviewer.rID
	and reviewer.name = 'Chris Jackson';
	
/*Query without using 'except' - using 'not in' */	
select title 
from movie
where title not in (select title
							from movie, rating, reviewer
							where movie.mID = rating.mID and rating.rID = reviewer.rID
							and reviewer.name = 'Chris Jackson')
order by title;

/*Q.5. 'Lagunita Stanford SQL Course' */
/* For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers.
Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. 
For each pair, return the names in the pair in alphabetical order.  */

select distinct R1.name, R2.name
from (reviewer natural join rating) R1, (reviewer natural join rating) R2
where R1.mID = R2.mID and R1.name < R2.name;

/*Q.6. 'Lagunita Stanford SQL Course' */
/* For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.  */

select distinct name, title, stars
from movie, reviewer, rating
where movie.mID = rating.mID and rating.rID = reviewer.rID
		and stars not in (select max(stars) 
							from rating
							group by mID);
							
/*Q.7. 'Lagunita Stanford SQL Course' */
/* List movie titles and average ratings, from highest-rated to lowest-rated. 
If two or more movies have the same average rating, list them in alphabetical order.   */

select title, avg(stars)
from (movie inner join rating using (mID))
group by title
order by avg(stars) desc, title;

/*Q.8. 'Lagunita Stanford SQL Course' */
/* Find the names of all reviewers who have contributed three or more ratings.
 (As an extra challenge, try writing the query without HAVING or without COUNT.)  */

select name
from reviewer, (select rID, count(stars)
						from rating
						group by rID
						having count(stars) >= 3) C
where reviewer.rID = C.rID
order by name;
						 
/*Q.9. 'Lagunita Stanford SQL Course' */
/*  Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, 
along with the director name. Sort by director name, then movie title. 
(As an extra challenge, try writing the query both with and without COUNT.) */						 

select M1.title, M1.director
from movie M1, movie M2
where M1.director = M2.director and M1.title <> M2.title
order by M1.director, M1.title;

/*Q.10. 'Lagunita Stanford SQL Course' INCORRECT - COME BACK TO THIS LATER */
/*  Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. 
(Hint: This query is more difficult to write in SQLite than other systems; you might think of it as 
finding the highest average rating and then choosing the movie(s) with that average rating.)  */						 
select C.title, max(C.Average)
from (select title, avg(stars) Average
		from (movie natural join rating)
		group by title) C;
		
/*Q.11. 'Lagunita Stanford SQL Course' COME BACK LATER TO THIS*/
/*  Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. 
(Hint: This query may be more difficult to write in SQLite than other systems; you might think of it 
as finding the lowest average rating and then choosing the movie(s) with that average rating.)   */	
select C.title, min(C.Average)
from (select mID, title, avg(stars) Average
		from (movie inner join rating using (mID))
		group by mID) C;
		
/*Q.12. 'Lagunita Stanford SQL Course' COME BACK LATER TO THIS*/
/* For each director, return the director's name together with the title(s) of the movie(s) they 
directed that received the highest rating among all of their movies, and the value of that rating. 
Ignore movies whose director is NULL.    */		

select director, title, max(stars)
from (movie inner join rating using (mID))
group by director
having director is not null;

