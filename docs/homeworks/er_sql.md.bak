---
title: "Homework 2: ER Model and SQL"
date: "2018-02-20"
---

Practice making an ER diagram and writing SQL queries.

**DUE**: Tuesday Feb. 20, 11:59pm

<!--more-->

## Setting up: The Lahman baseball database

You will be using data from a very useful database on baseball teams, players and seasons curated by Sean Lahman available at [http://www.seanlahman.com/baseball-archive/statistics/](http://www.seanlahman.com/baseball-archive/statistics/). The database has been made available as a `sqlite` database [https://github.com/jknecht/baseball-archive-sqlite](https://github.com/jknecht/baseball-archive-sqlite). `sqlite` is a light-weight, file-based database management system that is well suited for small projects and prototypes.

You can read more about the dataset here: http://seanlahman.com/files/database/readme2016.txt

### Download Database

Create a directory for this homework and download the sqlite file into it.
Download the file here:

https://github.com/jknecht/baseball-archive-sqlite/raw/master/lahman2016.sqlite

### Setup R

Make sure the `RSQLite` package is installed, if not install it.

Check you can connect to the database from R by evaluating the following code:

```r
db <- DBI::dbConnect(RSQLite::SQLite(), "lahman2016.sqlite")
DBI::dbListTables(db)
DBI::dbDisconnect(db)
```

You should see the list of tables in the Lahman database. Note that this assumes the working directory in the R console contains the SQLite file. Otherwise, you need to provide the full path to the file.

### Download shell file

Download the Rmarkdown shell file here: [HW2 Rmarkdown shell](/misc/hw2_er-sql.Rmd) and fill in with your answers. 

### (Optional) SQLite Command Line Interface

You may find working with the SQLite command line interface useful as well. You can download here:
https://sqlite.org/download.html

## ER Diagram

Consider the following subset of tables from the Lahman dataset:

- _TeamFranchises_: these are the corporate team entities. Attributes: `franchID`, `franchName`, `active`. 
- _Teams_: specific teams fielded by a franchise in a given season. Attributes: `yearID`, `teamID`, `lgID`, `franchID`, `G`, `W`, `L`.
- _Master_: overall information about the people who play the game. Attributes: `playerID`, `birthYear`, `birthMonth`, `birthDay`, `birthCountry`, `birthState`, `birthCity`, `nameFirst`, `nameLast`, `nameGiven`, `weight`, `height`.
- _Batting_: statistics of player performance on offense. Attributes: `playerID`, `yearID`, `teamID`, `lgID`, `G`,`AB`, `H`, `2B`, `3B`, `HR`.
- _Salaries_: salary paid by team to player. Attributes: `yearID`, `teamID`, `lgID`, `playerID`, `salary`.

Draw an ER diagram describing this Schema. Indicate primary keys as appropriate.

## SQL Exercise

Write a SQL query to answer each of the following questions:

1) How many franchises are listed in the database (see [`count`](https://sqlite.org/lang_aggfunc.html#count))?

2) How many franchises are currently active?

3) Which teams won more than 100 games in one season between 2000 and 2015? Order result by descending number of wins. (Attribute `W` of the Teams table contains the number of wins)

4) What is the franchise name of the team with the most total wins in the database?

5) What is the franchise name of the team with the highest winning percentage in a season in the database? (Win percentage is `W/G`)

6) What is the franchise name of the team with the highest single-year payroll between 2000 and 2015?

7) (BONUS from [MDSR book](https://mdsr-book.github.io/)): Identify players (by first and last name) that have attained through their career either a) 500 or more HRs or b) 3000 or more hits (H) _and_ have not been inducted to the Hall of Fame (see `HallOfFame` table).

## Submitting

Enter your answers in the shell Rmarkdown file linked above. Knit to PDF and submit to ELMS.


