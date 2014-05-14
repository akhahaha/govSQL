/* CS 143 Spring 2014, Homework 3 - Federal Government Shutdown Edition */

/*******************************************************************************
 For each of the queries below, put your SQL in the place indicated by the
 comment.  Be sure to have all the requested columns in your answer, in the
 order they are listed in the question - and be sure to sort things where the
 question requires them to be sorted, and eliminate duplicates where the
 question requires that.  We will grade the assignment by running the queries on
 a test database and eyeballing the SQL queries where necessary.  We won't grade
 on SQL style, but we also won't give partial credit for any individual question
 - so you should be confident that your query works. In particular, your output
 should match our example output in hw3trace.txt.
********************************************************************************/

/*******************************************************************************
 Q1 - Return the statecode, county name and 2010 population of all counties who
 had a population of over 2,000,000 in 2010. Return the rows in descending order
 from most populated to least.
 ******************************************************************************/

SELECT
	statecode, name, population_2010
FROM
	counties
WHERE
	population_2010 > 2000000
ORDER BY
	population_2010 DESC;

/*******************************************************************************
 Q2 - Return a list of statecodes and the number of counties in that state,
 ordered from the least number of counties to the most.
*******************************************************************************/

SELECT
	statecode, COUNT(*)
FROM
	counties
GROUP BY
	statecode
ORDER BY
	COUNT(*);

/*******************************************************************************
 Q3 - On average how many counties are there per state (return a single real
 number).
*******************************************************************************/

SELECT
	AVG(s.counts)
FROM
	(SELECT
		COUNT(*) AS counts
	FROM
		counties
	GROUP BY
		statecode) s;

/*******************************************************************************
 Q4 - Return a count of how many states have more than the average number of
 counties.
*******************************************************************************/

SELECT
	COUNT(*)
FROM
	(SELECT
		statecode, COUNT(*) AS counts
	FROM
		counties
	GROUP BY
		statecode) s
WHERE
	s.counts > (SELECT
					AVG(t.counts)
				FROM	(SELECT
							COUNT(*) AS counts
						FROM
							counties
						GROUP BY
							statecode) t);

/*******************************************************************************
 Q5 - Data Cleaning - return the statecodes of states whose 2010 population does
 not equal the sum of the 2010 populations of their counties.
*******************************************************************************/

SELECT
	s.statecode
FROM
	states AS s,
	(SELECT
		statecode, SUM(population_2010) AS total
	FROM
		counties
	GROUP BY
		statecode) c
WHERE
	s.statecode = c.statecode AND s.population_2010 <> c.total;

/*******************************************************************************
 Q6 - How many states have at least one senator whose first name is John,
 Johnny, or Jon? Return a single integer.
*******************************************************************************/

SELECT
	COUNT(DISTINCT s.statecode)
FROM
	(SELECT
		name, statecode
	FROM
		senators
	WHERE
		name LIKE "John%" OR name LIKE "Johnny%" OR name LIKE "Jon%"
	ORDER by
		statecode) s;

/*******************************************************************************
Q7 - Find all the senators who were born in a year before the year their state
was admitted to the union.	For each, output the statecode, year the state was
admitted to the union, senator name, and year the senator was born.	 Note: in
SQLite you can extract the year as an integer using the following:
"cast(strftime('%Y',admitted_to_union) as integer)."
*******************************************************************************/

SELECT
	st.statecode,
	EXTRACT(Year FROM st.admitted_to_union) AS admitted_to_union,
	sen.name,
	sen.born
FROM
	states st, senators sen
WHERE
	st.statecode = sen.statecode AND
	born < EXTRACT(Year FROM st.admitted_to_union);

/*******************************************************************************
Q8 - Find all the counties of West Virginia (statecode WV) whose population
shrunk between 1950 and 2010, and for each, return the name of the county and
the number of people who left during that time (as a positive number).
*******************************************************************************/

SELECT
	name, ABS(population_2010 - population_1950) AS leaving_population
FROM
	counties
WHERE
	statecode LIKE "WV" AND population_2010 < population_1950;

/*******************************************************************************
Q9 - Return the statecode of the state(s) that is (are) home to the most
committee chairmen.
*******************************************************************************/

SELECT
	sc1.statecode
FROM
	(SELECT
		s.statecode, COUNT(*) AS ct
	FROM
		senators s,
		committees c
	WHERE
		s.name = c.chairman
	GROUP BY
		s.statecode) sc1
WHERE
	sc1.ct = (SELECT
				MAX(sc2.ct)
			FROM
				(SELECT
					COUNT(*) AS ct
				FROM
					senators s,
					committees c
				WHERE
					s.name = c.chairman
				GROUP BY
					s.statecode) sc2);

/*******************************************************************************
Q10 - Return the statecode of the state(s) that are not the home of any
committee chairmen.
*******************************************************************************/

SELECT
	st.statecode
FROM
	states st
WHERE
	st.statecode
NOT IN (SELECT
			s.statecode
		FROM
			senators s,
			committees c
		WHERE
			s.name = c.chairman
		GROUP BY
			s.statecode);

/*******************************************************************************
Q11 Find all subcommittees whose chairman is the same as the chairman of its
parent committee.  For each, return the id of the parent committee, the name of
the parent committee's chairman, the id of the subcommittee, and name of that
subcommittee's chairman.
*******************************************************************************/

/*Put your SQL for Q11 here */

/*******************************************************************************
Q12 - For each subcommittee where the subcommittee’s chairman was born in an
earlier year than the chairman of its parent committee, Return the id of the
parent committee, its chairman, the year the chairman was born, the id of the
subcommittee, it’s chairman and the year the subcommittee chairman was born.
********************************************************************************/

/* Put your SQL for Q12 here */
