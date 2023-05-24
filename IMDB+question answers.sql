USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables AND whether any column has null values.
 Further in this segment, you will take a look at 'movies' AND 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 'director_mapping_count', COUNT(*) AS director_mapping_count FROM director_mapping uniON all
SELECT 'genre_count', COUNT(*) AS genre_count FROM genre uniON all
SELECT 'movie_count', COUNT(*) AS movie_count FROM movie uniON all
SELECT 'names_count', COUNT(*) AS names_count FROM names uniON all
SELECT 'ratings_count', COUNT(*) AS ratings_count FROM ratings uniON all
SELECT 'role_mapping_count', COUNT(*) AS role_mapping_count FROM role_mapping;

director_mapping_count	3867
genre_count	14662
movie_count	7997
names_count	25735
ratings_count	7997
role_mapping_count	15615







-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT COUNT(*) - COUNT(id) id_null
,COUNT(*) - COUNT(title) title_null ,COUNT(year) -  COUNT(*) year_null ,COUNT(date_published) -  COUNT(*) date_published_null,
COUNT(duration) -  COUNT(*) duration_null ,COUNT(*) - COUNT(country)  country_null ,COUNT(*) - COUNT(worlwide_gross_income) worlwide_gross_income_null
, COUNT(*) - COUNT(languages)  languages_null , COUNT(*) - COUNT(production_company)   production_company_null
FROM movie; 

id_null, title_null, year_null, date_published_null, duration_null, country_null, worlwide_gross_income_null, languages_null, production_company_null
0	0	0	0	0	20	3724	194	528

Ans: 4 columns have null values

country
wordlwide_gross_income
languages
production_company




-- Now AS you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year, COUNT(*) AS number_of_movies FROM movie
GROUP BY year
ORDER BY year;

year, number_of_movies
2017	3052
2018	2944
2019	2001









/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA AND India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(*) number_of_movies_USA_INDIA 
FROM movie
WHERE country in ('USA','India')
AND year = 2019;

number_of_movies_USA_INDIA
887







/* USA AND India produced more than a thousAND movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/



-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:



SELECT DISTINCT genre 
FROM genre;

genre
-------
Drama
Fantasy
Thriller
Comedy
Horror
Family
Romance
Adventure
Action
Sci-Fi
Crime
Mystery
Others






/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie AND genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


SELECT g.genre, COUNT(distinct m.id) AS no_of_movies
FROM genre g
INNER JOIN movie m
ON m.id = g.movie_id
GROUP BY g.genre 
ORDER BY COUNT(*) desc;

genre, no_of_movies
----------------------------
Drama	4285
Comedy	2412
Thriller	1484
Action	1289
Horror	1208
Romance	906
Crime	813
Adventure	591
Mystery	555
Sci-Fi	375
Fantasy	342
Family	302
Others	100

Ans : Drama has highest nulmer of movies produced overall.





/* So, based ON the insight that you just drew, RSVP Movies should focus ON the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH qry1 AS (
SELECT m.title, COUNT(*) AS no_of_movies
FROM genre g
INNER JOIN movie m
ON m.id = g.movie_id
GROUP BY m.title HAVING COUNT(*) = 1)
SELECT COUNT(*) FROM qry1;

no_of_movies
------------------
3245



/* There are more than three thousAND movies which has only one genre associated WITH them.
So, this figure appears significant. 
Now, let's find out the possible duratiON of RSVP Movies’ next project.*/

-- Q8.What is the average duratiON of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre, ROUND(avg(m.duration) ,2) AS avg_duration
FROM genre g
INNER JOIN movie m
ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY avg(m.duration) ; 

genre, avg_duration
------------------------------
Horror	92.72
Sci-Fi	97.94
Others	100.16
Family	100.97
Thriller	101.58
Mystery	101.80
Adventure	101.87
Comedy	102.62
Fantasy	105.14
Drama	106.77
Crime	107.05
Romance	109.53
Action	112.88


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duratiON of 106.77 mins.
Lets find WHERE the movies of genre 'thriller' ON the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_rank_qry AS 
(
      SELECT genre, COUNT(movie_id) AS movie_count,
      Rank() over(ORDER BY COUNT(movie_id) desc) AS genre_rank
      FROM genre
      GROUP BY genre
)
SELECT *
FROM genre_rank_qry; 

genre, movie_count, genre_rank
Drama	4285	1
Comedy	2412	2
Thriller	1484	3
Action	1289	4
Horror	1208	5
Romance	906	6
Crime	813	7
Adventure	591	8
Mystery	555	9
Sci-Fi	375	10
Fantasy	342	11
Family	302	12
Others	100	13


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies AND genres tables. 
 In this segment, you will analyse the ratings table AS well.
To start WITH lets get the min AND max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum AND maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(r.avg_rating) AS min_avg_rating, MAX(r.avg_rating) AS max_avg_rating, MIN(r.total_votes) AS min_total_votes, 
MAX(r.total_votes)	as max_total_votes, MIN(r.median_rating) AS min_median_rating,
MAX(r.median_rating) AS max_median_rating
FROM ratings r
INNER JOIN movie m
ON m.id = r.movie_id;

min_avg_rating, max_avg_rating, min_total_votes, max_total_votes, min_median_rating, max_median_rating
1.0	10.0	100	725138	1	10

    

/* So, the minimum AND maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based ON average rating.*/

-- Q11. Which are the top 10 movies based ON average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT m.title AS title, r.avg_rating AS min_avg_rating, rank() over(ORDER BY avg_rating desc) AS rating_rank
FROM ratings r
INNER JOIN movie m
ON m.id = r.movie_id
limit 10;

title, min_avg_rating, rating_rank
Kirket	10.0	1
Love in Kilnerry	10.0	1
Gini Helida Kathe	9.8	3
Runam	9.7	4
Fan	9.6	5
Android Kunjappan VersiON 5.25	9.6	5
Yeh Suhaagraat Impossible	9.5	7
Safe	9.5	7
The BrightON Miracle	9.5	7
Shibu	9.4	10






/* Do you find you favourite movie FAN in the top 10 movies WITH an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors AND filler actors can be FROM these movies?
Summarising the ratings table based ON the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based ON the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- ORDER BY is good to have

SELECT r.median_rating, COUNT(distinct m.id) movie_count
FROM ratings r
INNER JOIN movie m
ON m.id = r.movie_id
GROUP BY r.median_rating
ORDER BY COUNT(distinct m.id);

median_rating, movie_count
1	94
2	119
3	283
10	346
9	429
4	479
5	985
8	1030
6	1975
7	2257


/* Movies WITH a median rating of 7 is highest in number. 
Now, let's find out the productiON house WITH which RSVP Movies can partner for its next project.*/

-- Q13. Which productiON house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company, COUNT( m.id) AS movie_count, rank() over (ORDER BY COUNT(distinct m.id) GROUP BY m.production_company) AS prod_company_rank
FROM movie m 
INNER JOIN ratings r
ON m.id = r.movie_id
GROUP BY m.production_company
WHERE r.avg_rating > 8;

production_company, movie_count , prod_company_rank
Dream Warrior Pictures	3	1
National Theatre Live	3	1

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre, COUNT(g.movie_id) AS movie_count
FROM genre AS g 
INNER JOIN ratings AS r
ON g.movie_id = r.movie_id
INNER JOIN movie AS m 
ON m.id = g.movie_id
WHERE m.country = 'USA' AND r.total_votes > 1000 AND month(date_published) = 3 AND year = 2017
GROUP BY g.genre
ORDER BY movie_count desc;

genre, movie_count
Drama	16
Comedy	8
Crime	5
Horror	5
Action	4
Sci-Fi	4
Thriller	4
Romance	3
Fantasy	2
Mystery	2
Family	1



-- Lets try to analyse WITH a unique problem statement.
-- Q15. Find movies of each genre that start WITH the word ‘The’ AND which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title, avg_rating, genre
FROM genre AS g
INNER JOIN ratings AS r
ON g.movie_id = r.movie_id
INNER JOIN movie AS m
ON m.id = g.movie_id
WHERE title like 'The%' AND avg_rating > 8
ORDER BY avg_rating desc;

title, avg_rating, genre
The BrightON Miracle	9.5	Drama
The Colour of Darkness	9.1	Drama
The Blue Elephant 2	8.8	Drama
The Blue Elephant 2	8.8	Horror
The Blue Elephant 2	8.8	Mystery
The Irishman	8.7	Crime
The Irishman	8.7	Drama
The Mystery of Godliness: The Sequel	8.5	Drama
The Gambinos	8.4	Crime
The Gambinos	8.4	Drama
Theeran Adhigaaram Ondru	8.3	Action
Theeran Adhigaaram Ondru	8.3	Crime
Theeran Adhigaaram Ondru	8.3	Thriller
The King AND I	8.2	Drama
The King AND I	8.2	Romance







-- You should also try your hAND at median rating AND check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 AND 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT median_rating , COUNT(*) AS movie_count FROM movie m , ratings r  WHERE date_published between
 str_to_date("01-APR-2018","%d-%M-%Y") AND str_to_date("01-APR-2019","%d-%M-%Y")
 AND m.id = r.movie_id
 AND median_rating = 8 ;

 median_rating, movie_count
 8	361






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German AND Italian movies.
-- Type your code below:

SELECT SUM(CASE WHEN country like '%Germany%' then total_votes else 0 end ) AS germany_movie_votes_cnt ,
SUM(CASE WHEN country like '%Italy%' then total_votes else 0 end ) AS Italy_movie_votes_cnt 
FROM movie m , ratings r 
WHERE r.movie_id = m.id;

germany_movie_votes_cnt, Italy_movie_votes_cnt
2026223	703024

Answer : Yes




-- Answer is Yes

/* Now that you have analysed the movies, genres AND ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT COUNT(*) - COUNT(id) id_nulls ,
COUNT(*) - COUNT(name)  name_nulls ,
COUNT(*) - COUNT(height)  height_nulls ,
COUNT(*) - COUNT(date_of_birth)  date_of_birth_nulls ,
COUNT(*) - COUNT(known_for_movies)  known_for_movies_nulls 
FROM names;

id_nulls, name_nulls, height_nulls, date_of_birth_nulls, known_for_movies_nulls
0	0	17335	13431	15226



/* There are no Null value in the column 'name'.
The director is the most important persON in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies WITH an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT name director_name , COUNT(*) movie_count FROM genre g , director_mapping dm , names m
, (SELECT genre  FROM genre g , director_mapping dm , ratings r 
WHERE g.movie_id = dm.movie_id  AND g.movie_id = r.movie_id AND avg_rating > 8
GROUP BY genre  ORDER BY COUNT(*) desc limit 3 ) tg 
WHERE g.genre = tg.genre AND dm.movie_id = g.movie_id
AND dm.name_id = m.id
GROUP BY name 
ORDER BY COUNT(*) desc
limit 3;

director_name, movie_count
Steven Soderbergh	6
Siddique	5
Tigmanshu Dhulia	5


/* James Mangold can be hired AS the director for RSVP's next project. Do you remeber his movies, 'Logan' AND 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT name actor_name , COUNT(*)  movie_count FROM names n , role_mapping rm , ratings r
WHERE n.id = rm.name_id AND rm.movie_id = r.movie_id
AND rm.category = 'actor'
AND median_rating >= 8
GROUP BY id 
ORDER BY COUNT(*) desc
limit 2;

actor_name, movie_count
Mammootty	8
Mohanlal	5






/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner WITH other global productiON houses. 
Let’s find out the top three productiON houses in the world.*/

-- Q21. Which are the top three productiON houses based ON the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT production_company, SUM(total_votes)as vote_count,
        DENSE_RANK() over(ORDER BY SUM(total_votes) desc) AS prod_comp_rank
FROM movie AS m
INNER JOIN ratings AS r 
ON m.id = r.movie_id
GROUP BY production_company
limit 3;


production_company, vote_count, prod_comp_rank
Marvel Studios	2656967	1
Twentieth Century Fox	2411163	2
Warner Bros.	2396057	3



/*Yes Marvel Studios rules the movie world.
So, these are the top three productiON houses based ON the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors WITH movies released in India based ON their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based ON votes. If the ratings clash, then the total number of votes should act AS the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH qry1 as 
(SELECT name AS actor_name, total_votes,
                COUNT(m.id) AS movie_count,
                ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating,
                RANK() over(order by(SUM(avg_rating*total_votes)/SUM(total_votes)) desc) AS actor_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
INNER JOIN role_mapping AS rm
ON m.id = rm.movie_id
INNER JOIN names AS nm 
ON rm.name_id = nm.id
WHERE category = 'actor' AND country = 'india'
GROUP BY name 
HAVING COUNT(m.id) >=5)
SELECT * from qry1
ORDER BY actor_avg_rating desc; 


actor_name, total_votes, movie_count, actor_avg_rating, actor_rank
Vijay Sethupathi	20364	5	8.42	1
Fahadh Faasil	3684	5	7.99	2
Yogi Babu	223	11	7.83	3
Joju George	413	5	7.58	4
Ammy Virk	169	6	7.55	5

Ans : Vijay Sethupathi


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based ON their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based ON votes. If the ratings clash, then the total number of votes should act AS the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT name AS actress_name, total_votes,
                COUNT(m.id) AS movie_count,
                ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
                RANK() over(ORDER BY avg_rating desc) AS actress_rank
                
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
INNER JOIN role_mapping AS rm
ON m.id = rm.movie_id
INNER JOIN names AS nm 
ON rm.name_id = nm.id
WHERE category = 'actress' AND country = 'India'
GROUP BY name
HAVING COUNT(m.id) >=5
limit 5;

actress_name, total_votes, movie_count, actress_avg_rating, actress_rank
Taapsee Pannu	2269	5	7.70	1
Raashi Khanna	3746	5	7.01	2
Manju Warrier	5471	5	6.76	3
Nayanthara	654	6	6.68	4
Sonam Bajwa	540	5	6.44	5



/* Taapsee Pannu tops WITH average rating 7.74. 
Now let us divide all the thriller movies in the following categories AND find out their numbers.*/


/* Q24. SELECT thriller movies AS per avg rating AND classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 AND 8: Hit movies
			Rating between 5 AND 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT title,
          CASE WHEN avg_rating > 8 then 'superhit movies'
			    WHEN avg_rating between 7 AND 8 then 'hit movies'
                WHEN avg_rating between 5 AND 7 then 'one-time-watch movies'
                WHEN avg_rating < 5 then 'flop movies'
		   END AS  avg_rating_category
FROM movie AS m
INNER JOIN genre AS g
ON m.id = g.movie_id
INNER JOIN ratings AS r ON m.id = r.movie_id
WHERE genre = 'thriller'; 







/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total AND moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duratiON  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT genre,
        ROUND(avg(duration),2) AS avg_duration,
        SUM(ROUND(avg(duration),2)) over(ORDER BY genre rows unbounded preceding) AS running_total_duration,
        ROUND(avg(ROUND(avg(duration),2)) over(ORDER BY genre rows 10 preceding),2) AS movie_avg_duration
FROM movie AS m
INNER JOIN genre AS g
ON m.id = g.movie_id
GROUP BY genre
ORDER BY genre;



genre, avg_duration, running_total_duration, movie_avg_duration
Action	112.88	112.88	112.88
Adventure	101.87	214.75	107.38
Comedy	102.62	317.37	105.79
Crime	107.05	424.42	106.11
Drama	106.77	531.19	106.24
Family	100.97	632.16	105.36
Fantasy	105.14	737.30	105.33
Horror	92.72	830.02	103.75
Mystery	101.80	931.82	103.54
Others	100.16	1031.98	103.20
Romance	109.53	1141.51	103.77
Sci-Fi	97.94	1239.45	102.42
Thriller	101.58	1341.03	102.39




-- Round is good to have AND not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year WITH top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based ON most number of movies


WITH top_3_genre AS 
 (
      SELECT genre, COUNT(movie_id) AS number_of_movies
      FROM genre AS g
      INNER JOIN movie AS m
      ON g.movie_id = m.id
      GROUP BY genre
      ORDER BY COUNT(movie_id) desc 
      limit 3
 ),
 top_5 as
 (
      SELECT genre,
              year,
              title AS movie_name,
              worlwide_gross_income,
              DENSE_RANK() over(partitiON by year ORDER BY worlwide_gross_income desc) AS movie_rank
	   FROM movie AS m
       INNER JOIN genre AS g
       ON m.id = g.movie_id
       WHERE genre in (SELECT genre FROM top_3_genre)
 )
     SELECT *
     FROM top_5
     WHERE movie_rank <=5;
	 
genre, year, movie_name, worlwide_gross_income, movie_rank	 
Drama	2017	Shatamanam Bhavati	INR 530500000	1
Drama	2017	Winner	INR 250000000	2
Drama	2017	Thank You for Your Service	$ 9995692	3
Comedy	2017	The Healer	$ 9979800	4
Drama	2017	The Healer	$ 9979800	4
Thriller	2017	Gi-eok-ui bam	$ 9968972	5
Thriller	2018	The Villain	INR 1300000000	1
Drama	2018	Antony & Cleopatra	$ 998079	2
Comedy	2018	La fuitina sbagliata	$ 992070	3
Drama	2018	Zaba	$ 991	4
Comedy	2018	Gung-hab	$ 9899017	5
Thriller	2019	Prescience	$ 9956	1
Thriller	2019	Joker	$ 995064593	2
Drama	2019	Joker	$ 995064593	2
Comedy	2019	Eaten by Lions	$ 99276	3
Comedy	2019	Friend Zone	$ 9894885	4
Drama	2019	Nur eine Frau	$ 9884	5







-- Finally, let’s find out the names of the top two productiON houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two productiON houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company , COUNT(*) movie_count, row_number() over(ORDER BY COUNT(*) desc) prod_comp_rank FROM movie m, ratings r WHERE languages like '%,%'
AND r.median_rating >=8
AND m.id = r.movie_id
AND m.production_company is not null
GROUP BY m.production_company
ORDER BY COUNT(*) desc
Limit 2;

production_company, movie_count, prod_comp_rank
Star Cinema	7	1
Twentieth Century Fox	4	2




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based ON number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT name actress_name, SUM(total_votes) total_votes , COUNT(*) movie_count, avg(avg_rating) actress_avg_rating , avg_rating  ,
row_number() over(ORDER BY COUNT(*) desc ,   avg(avg_rating)  desc ) actress_rank FROM genre g , role_mapping rm  , ratings r , names n
WHERE g.genre='Drama'
AND rm.movie_id = g.movie_id
AND rm.category = 'actress'
AND r.movie_id = rm.movie_id
AND r.avg_rating > 8
AND n.id = rm.name_id
GROUP BY name_id
ORDER BY COUNT(*) desc
limit 3;

actress_name, total_votes, movie_count, actress_avg_rating, avg_rating, actress_rank
Susan Brown	656	2	8.95000	8.9	1
Amanda Lawrence	656	2	8.95000	8.9	2
Denise Gough	656	2	8.95000	8.9	3



/* Q29. Get the following details for top 9 directors (based ON number of movies)
Director id
Name
Number of movies
Average inter movie duratiON in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duratiON |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH movie_Date_info AS 
(
SELECT d.name_id , name , d.movie_id ,
m.date_published, 
LEAD(date_published,1) over (partitiON by d.name_id ORDER BY date_published , d.movie_id) AS next_movie_Date
FROM director_mapping d 
JOIN names AS n
ON d.name_id = n.id
JOIN movie AS m 
ON d.movie_id = m.id
),
date_Difference AS 
( SELECT *, datediff(next_movie_Date , date_published) AS diff FROM movie_date_info) ,
avg_inter_days AS 
( SELECT name_id , avg(diff) AS avg_movie_days FROM date_Difference GROUP BY name_id ) ,
final_Result AS (
SELECT n.id director_id , n.name director_name, 
COUNT(*) number_of_movies ,
ROUND(avg_movie_days) AS avg_movie_days ,
ROUND(avg(avg_Rating)) AS avg_rating,
SUM(total_votes) total_votes ,
MIN(avg_Rating) min_rating,
MAX(avg_rating) max_ratings, 
SUM(m.duration) total_duration,
row_number() over(ORDER BY COUNT(*) desc) AS director_row_rank
FROM movie m , director_mapping dm , names n ,
ratings r , avg_inter_days aid
WHERE m.id = dm.movie_id AND n.id = dm.name_id
AND r.movie_id = m.id
AND aid.name_id = dm.name_id
GROUP BY n.id
ORDER BY COUNT(*) desc
) 
SELECT * FROM final_Result limit 9;

director_id, director_name, number_of_movies, avg_movie_days, avg_rating, total_votes, min_rating, max_ratings, total_duration, director_row_rank
nm2096009	Andrew Jones	5	191	3	1989	2.7	3.2	432	1
nm1777967	A.L. Vijay	5	177	5	1754	3.7	6.9	613	2
nm6356309	Özgür Bakar	4	112	4	1092	3.1	4.9	374	3
nm2691863	Justin Price	4	315	5	5343	3.0	5.8	346	4
nm0814469	SiON Sono	4	331	6	2972	5.4	6.4	502	5
nm0831321	Chris Stokes	4	198	4	3664	4.0	4.6	352	6
nm0425364	Jesse V. Johnson	4	299	5	14778	4.2	6.5	383	7
nm0001752	Steven Soderbergh	4	254	6	171684	6.2	7.0	401	8
nm0515005	Sam Liu	4	260	6	28557	5.8	6.7	312	9






