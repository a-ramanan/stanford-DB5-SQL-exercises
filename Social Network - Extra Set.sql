/* EXTRA SET QUESTIONS - SOCIAL NETWORK EXERCISE - LAGUNITA STANFORD SQL COURSE */

/*Q.1. 'Lagunita Stanford SQL Course' */
/* For every situation where student A likes student B, but student B likes a
 different student C, return the names and grades of A, B, and C.   */

/* student A like B, but B likes another C */
 
select L1.ID1, L1.ID2, L2.ID2
from likes L1, likes L2
where L1.ID2 = L2.ID1 and L2.ID2 <> L1.ID1;

/* the whole thing */

select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from highschooler H1, highschooler H2, highschooler H3, (select L1.ID1 A, L1.ID2 B, L2.ID2 C
														from likes L1, likes L2
														where L1.ID2 = L2.ID1 and L2.ID2 <> L1.ID1) AlikesBlikesC
where H1.ID = AlikesBlikesC.A and H2.ID = AlikesBlikesC.B and H3.ID = AlikesBlikesC.C;

/*Q.2. 'Lagunita Stanford SQL Course' */
/* Find those students for whom all of their friends are in different grades from themselves.
 Return the students' names and grades.    */
/* ID of student all of whose friends are in a different grade */

select ID1
from friend
except 
select ID1
from friend F, highschooler H1, highschooler H2
where H1.ID = F.ID1 and H2.ID = F.ID2
	and H1.grade = H2.grade;
	
/* the whole thing */

select name, grade
from highschooler, (select ID1
							from friend
							except 
							select ID1
							from friend F, highschooler H1, highschooler H2
							where H1.ID = F.ID1 and H2.ID = F.ID2
							and H1.grade = H2.grade) C
where ID = C.ID1;							

/*Q.3. 'Lagunita Stanford SQL Course' */
/* What is the average number of friends per student? (Your result should be just one number.)  */

/* Number of friends per student */

select ID1, count(ID2) friendsPerStudent
from friend
group by ID1;

/* avg friends per student */

select avg(C.friendsPerStudent)
from 	(select ID1, count(ID2) friendsPerStudent
			from friend
			group by ID1) C;			
			
/*Q.4. 'Lagunita Stanford SQL Course' */
/*Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. 
Do not count Cassandra, even though technically she is a friend of a friend.   */

/*No. students friends with Cassandra */

select count(H1.name)
from highschooler H1, highschooler H2, friend 
where H1.ID = friend.ID1 and H2.ID = friend.ID2
	and H2.name = 'Cassandra'
order by H1.name; 

/* No of friends of friends of Cassandra + No of friends of Cassandra */

select count(distinct friend.ID2) + count(distinct FwC.A)
from highschooler H1, friend, (select H1.ID A
					from highschooler H1, highschooler H2, friend 
					where H1.ID = friend.ID1 and H2.ID = friend.ID2
					and H2.name = 'Cassandra'
					order by H1.name) FwC
where FwC.A = friend.ID1 and H1.ID = friend.ID2
	and H1.name <> 'Cassandra' ;  
	
/*Q.5. 'Lagunita Stanford SQL Course' */
/* Find the name and grade of the student(s) with the greatest number of friends.  */

select name, grade
from highschooler, (select ID1 from friend
							except 

						  select A.ID1
							from (select ID1, count(ID2) NoF
										from friend
										group by ID1) A,

									(select ID1, count(ID2) NoF
										from friend
										group by ID1) B					
							where A.NoF < B.NoF) C
where highschooler.ID = C.ID1;							

				