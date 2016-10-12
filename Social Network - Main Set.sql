/* MAIN SET QUESTIONS - SOCIAL NETWORK EXERCISE - LAGUNITA STANFORD SQL COURSE */

/*Q.1. 'Lagunita Stanford SQL Course' */
/* Find the names of all students who are friends with someone named Gabriel.  */

select H2.name
from highschooler H1, highschooler H2, friend
where H1.ID = 	friend.ID1 and H2.ID = friend.ID2
	and H1.name = 'Gabriel';		
	
								
/*Q.2. 'Lagunita Stanford SQL Course' */
/* For every student who likes someone 2 or more grades younger than themselves, 
return that student's name and grade, and the name and grade of the student they like.   */

select H1.name, H1.grade, H2.name, H2.grade
from highschooler H1, highschooler H2, likes
where H1.ID = likes.ID1 and H2.ID = likes.ID2
	and H1.grade - H2.grade >= 2;
	
/*Q.3. 'Lagunita Stanford SQL Course' */
/*  For every pair of students who both like each other, return the name and grade of both students. 
Include each pair only once, with the two names in alphabetical order.   */

select distinct H1.name, H1.grade, H2.name, H2.grade
from highschooler H1, highschooler H2, highschooler H3, Highschooler H4, likes L1, likes L2
where H1.ID = L1.ID1 and H2.ID = L1.ID2
	and H3.ID = L2.ID1 and H4.ID = L2.ID2
	and L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1
	and H1.name < H2.name;

/*Q.4. 'Lagunita Stanford SQL Course' */
/* Find all students who do not appear in the Likes table (as a student who likes or is liked)
 and return their names and grades. Sort by grade, then by name within each grade.    */
 
select name, grade
from highschooler
where ID not in (select ID1 from likes
							union
							select ID2 from likes )
order by grade, name;



/*Q.5. 'Lagunita Stanford SQL Course' */
/*  For every situation where student A likes student B, but we have no information about whom B likes
 (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.   */
 
select H1.name, H1.grade, H2.name, H2.grade
from highschooler H1, highschooler H2, (select ID1, ID2
														from likes
														where ID2 not in (select ID1 from likes)) C													
where H1.ID = C.ID1 and H2.ID = C.ID2; 			

/*Q.6. 'Lagunita Stanford SQL Course' */
/* Find names and grades of students who only have friends in the same grade. 
Return the result sorted by grade, then by name within each grade.   */				

select name, grade
from highschooler, (select distinct ID1 from friend
							where ID1 not in
							(select distinct ID1
							from highschooler H1, highschooler H2, friend
							where H1.ID = friend.ID1 and H2.ID = friend.ID2
							and H1.grade <> H2. grade)) C
where highschooler.ID = C.ID1
order by grade, name;

/*Q.7. 'Lagunita Stanford SQL Course' */
/* For each student A who likes a student B where the two are not friends, find if they have a 
friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.   */		

/* like each other but not friends */

select ID1, ID2
from likes
except
select likes.ID1, likes.ID2
from likes, friend
where likes.ID1 = friend.ID1 and likes.ID2 = friend.ID2

/*like each other but not friends and have a common friend */

select F1.ID2
from friend F1, friend F2, (select ID1, ID2
					from likes
					except
					select likes.ID1, likes.ID2
					from likes, friend
					where likes.ID1 = friend.ID1 and likes.ID2 = friend.ID2) likeNotFriend
where likeNotFriend.ID1 = F1.ID1 and likeNotFriend.ID2 = F2.ID1 and F1.ID2 = F2.ID2; 

/*the whole damn thing*/

select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from highschooler H1, highschooler H2, highschooler H3, friend F1, friend F2, (select ID1, ID2
					from likes
					except
					select likes.ID1, likes.ID2
					from likes, friend
					where likes.ID1 = friend.ID1 and likes.ID2 = friend.ID2) likeNotFriend
where likeNotFriend.ID1 = F1.ID1 and likeNotFriend.ID2 = F2.ID1 and F1.ID2 = F2.ID2
	and H1.ID = likeNotFriend.ID1 and H2.ID = likeNotFriend.ID2 and H3.ID = F1.ID2; 

/*Q.8. 'Lagunita Stanford SQL Course' */
/* Find the difference between the number of students in the school and the number of different first names.  */	

select count(name)-count(distinct name)
from highschooler;

/*Q.9. 'Lagunita Stanford SQL Course' */
/* Find the name and grade of all students who are liked by more than one other student.  */

/* liked by more than 1 person */

select ID2, count(ID1)
from likes
group by ID2
having count(ID1)>1;

/* the whole thing */

select name, grade
from highschooler, (select ID2, count(ID1)
							from likes
							group by ID2
							having count(ID1)>1) likedByMoreThanOne
where ID=likedByMoreThanOne.ID2;

