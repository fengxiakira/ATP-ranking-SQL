DROP SCHEMA IF EXISTS A2 CASCADE;
CREATE SCHEMA A2;
SET search_path TO A2;

DROP TABLE IF EXISTS country CASCADE;
DROP TABLE IF EXISTS player CASCADE;
DROP TABLE IF EXISTS record CASCADE;
DROP TABLE IF EXISTS court CASCADE;
DROP TABLE IF EXISTS tournament CASCADE;
DROP TABLE IF EXISTS event CASCADE;
DROP TABLE IF EXISTS query1 CASCADE;
DROP TABLE IF EXISTS query2 CASCADE;
DROP TABLE IF EXISTS query3 CASCADE;
DROP TABLE IF EXISTS query4 CASCADE;
DROP TABLE IF EXISTS query5 CASCADE;
DROP TABLE IF EXISTS query6 CASCADE;
DROP TABLE IF EXISTS query7 CASCADE;
DROP TABLE IF EXISTS query8 CASCADE;
DROP TABLE IF EXISTS query9 CASCADE;
DROP TABLE IF EXISTS query10 CASCADE;


-- The country table contains some countries in the world.
-- 'cid' is the id of the country.
-- 'cname' is the name of the country.
CREATE TABLE country(
    cid         INTEGER     PRIMARY KEY,
    cname       VARCHAR     NOT NULL
    );
    
-- The player table contains information about some tennis players.
-- 'pid' is the id of the player.
-- 'pname' is the name of the player.
-- 'globalrank' is the global rank of the player.
-- 'cid' is the id of the country that the player belongs to.
CREATE TABLE player(
    pid         INTEGER     PRIMARY KEY,
    pname       VARCHAR     NOT NULL,
    globalrank  INTEGER     NOT NULL,
    cid         INTEGER     REFERENCES country(cid) ON DELETE RESTRICT
    );

-- The record table contains information about players performance in each year.
-- 'pid' is the id of the player.
-- 'year' is the year.
-- 'wins' is the number of wins of the player in that year.
-- 'losses' is the the number of losses of the player in that year.
CREATE TABLE record(
    pid         INTEGER     REFERENCES player(pid) ON DELETE RESTRICT,
    year        INTEGER     NOT NULL,
    wins        INTEGER     NOT NULL,
    losses      INTEGER     NOT NULL,
    PRIMARY KEY(pid, year));

-- The tournament table contains information about a tournament.
-- 'tid' is the id of the tournament.
-- 'tname' is the name of the tournament.
-- 'cid' is the country where the tournament hold.
CREATE TABLE tournament(
    tid         INTEGER     PRIMARY KEY,
    tname       VARCHAR     NOT NULL,
    cid         INTEGER     REFERENCES country(cid) ON DELETE RESTRICT 
    );

-- The court table contains the information about tennis court
-- 'courtid' is the id of the court.
-- 'courtname' is the name of the court.
-- 'capacity' is the maximum number of audience the court can hold.
-- 'tid' is the tournament that this court is used for
--  Notice: only one tournament can happen on a given court.
CREATE TABLE court(
    courtid     INTEGER     PRIMARY KEY,
    courtname   VARCHAR     NOT NULL,
    capacity    INTEGER     NOT NULL,
    tid         INTEGER     REFERENCES tournament(tid) ON DELETE RESTRICT
    );

-- The champion table provides information about the champion of each tournament.
-- 'pid' refers to the id of the champion(player).
-- 'year' is the year when the tournament hold.
-- 'tid' is the tournament id.
CREATE TABLE champion(
    pid     INTEGER     REFERENCES player(pid) ON DELETE RESTRICT,
    year    INTEGER     NOT NULL, 
    tid     INTEGER     REFERENCES tournament(tid) ON DELETE RESTRICT,
    PRIMARY KEY(tid, year));

-- The event table provides information about certain tennis games.
-- 'eid' refers to the id of the event.
-- 'year' is the year when the event hold.
-- 'courtid' is the id of the court where the event hold.
-- 'pwinid' is the id of the player who win the game.
-- 'plossid' is the id of the player who loss the game.
-- 'duration' is duration of the event, in minutes.
CREATE TABLE event(
    eid        INTEGER     PRIMARY KEY,
    year       INTEGER     NOT NULL,
    courtid    INTEGER     REFERENCES court(courtid) ON DELETE RESTRICT,
    winid      INTEGER     REFERENCES player(pid) ON DELETE RESTRICT,
    lossid     INTEGER     REFERENCES player(pid) ON DELETE RESTRICT,
    duration   INTEGER     NOT NULL
    );


-- The following tables will be used to store the results of your queries. 
-- Each of them should be populated by your last SQL statement that looks like:
-- "INSERT INTO QueryX (SELECT ...<complete your SQL query here> ... )"

CREATE TABLE query1(
    pname    VARCHAR,
    cname    VARCHAR,
    tname    VARCHAR    
);

CREATE TABLE query2(
    tname   VARCHAR,
    totalCapacity INTEGER    
);

CREATE TABLE query3(
    p1id    INTEGER,
    p1name  VARCHAR,
    p2id    INTEGER,
    p2name  VARCHAR    
);

CREATE TABLE query4(
    pid     INTEGER,
    pname   VARCHAR    
);

CREATE TABLE query5(
    pid      INTEGER,
    pname    VARCHAR,
    avgwins  REAL
);

CREATE TABLE query6(
    pid     INTEGER,
    pname   VARCHAR    
);

CREATE TABLE query7(
    pname    VARCHAR,
    year     INTEGER
);

CREATE TABLE query8(
    p1name  VARCHAR,
    p2name  VARCHAR,
    cname   VARCHAR    
);

CREATE TABLE query9(
    cname       VARCHAR,
    champions   INTEGER
);

CREATE TABLE query10(
    pname       VARCHAR
);


INSERT INTO country
VALUES('1','France');

INSERT INTO country
VALUES('2','U.S.A');

INSERT INTO country
VALUES('3','UK');

INSERT INTO country
VALUES('4','Austrlia');

INSERT INTO country
VALUES('5','Spain');

INSERT INTO country
VALUES('6','SERBIA');

INSERT INTO country
VALUES('7','SWISS');

INSERT INTO country
VALUES('8','CHINA');


INSERT INTO tournament
VALUES('101','W',3);

INSERT INTO tournament
VALUES('102','AO',4);

INSERT INTO tournament
VALUES('103','FO',1);

INSERT INTO tournament
VALUES(104,'UO',2);

Insert into player(pid,pname,globalrank,cid) 
VALUES
(1,'Nadal',2,5),
(2,'DJOKOVIC',1,6),
(3, 'FEDERER',3 ,7),
(4,'THIEM', 4 , 4),
(5,'MONFILS', 13 ,1),
(6,'QIANG WANG',22,8),
(7,'ccc',21,7);

Insert into court(courtid,courtname,capacity,tid)
VALUES
(1,   'Wimbledon',1000,101),
(2,   'Syndey',  1500,    102),
(3,   'Paris',   2000,    103),
(4,   'NewY',    3000,    104),
(5,'aaa',2000,101),
(6,'bbb',5000,102),
(7,'ccc',500,103),
(8,'ddd',400,104);

INSERT INTO champion(pid,year,tid) 
VALUES
(1,   2011, 101),
(1,2011,102),
(3,   2012,104),
(3,2015,101),
(3,2016,102),
(3,2017,103),
(5,   2013,103),
(4,   2014, 102);

INSERT INTO record(pid,year,wins,losses)
VALUES
(1,2011,20,20),
(1,2012,30,10),
(1,2013,40,20),
(1,2014,50,40),
(2,2011,70,20),
(2,2012,50,10),
(2,2013,30,20),
(2,2014,90,40),
(3,2011,70,20),
(3,2012,20,10),
(3,2013,30,20),
(3,2014,40,40),
(4,2011,70,20),
(4,2012,80,10),
(4,2014,10,20),
(4,2013,40,40),
(5,2011,70,20),
(5,2012,80,10),
(5,2014,30,20),
(5,2013,20,40),
(6,2011,30,20),
(6,2012,80,10),
(6,2014,30,20),
(6,2013,80,40);


INSERT INTO event(eid,year,courtid,winid,lossid,duration)
VALUES
(201, 2011, 1,   1,   2,   180),
(202, 2012, 2,   3,   4,   180),
(203, 2013, 3,   5,   1,   180),
(204 ,2014,	4,   3,   1,   200),
(205, 2011,	2,	 6,	  2,   180),
(206, 2016,	2,	 3,	  6,   180),
(207, 2015, 3,   3,   7,   180),
(208, 2017, 2,   2,   3,   180),
(209, 2015, 4,   4,   5,   180),
(210, 2018, 1,   5,   3,   180),
(211, 2018, 1,   2,   1,   180),
(212, 2014, 3,	 5,	  2,   300),
(213, 2014, 3,	 5,	  2,   500),
(214, 2017, 3,	 1,	  2,   400),
(215, 2017, 3,	 6,	  2,   400); 