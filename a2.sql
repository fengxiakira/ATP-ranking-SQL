SET search_path TO A2;

drop view IF EXISTS pid1 CASCADE;
DROP VIEW if exists allPlayer CASCADE;
DROP VIEW IF EXISTS allPRank CASCADE;
DROP VIEW IF EXISTS p1p2 CASCADE;
DROP VIEW if exists maxP CASCADE;
DROP VIEW if exists maxP1 CASCADE;
DROP VIEW if exists champion1P CASCADE;
drop view if exists pidF CASCADE;
drop view if exists totalCa CASCADE;


-- Add below your SQL statements. 
-- For each of the queries below, your final statement should populate the respective answer table (queryX) with the correct tuples. It should look something like:
-- INSERT INTO queryX (SELECT … <complete your SQL query here> …)
-- where X is the correct index [1, …,10].
-- You can create intermediate views (as needed). Remember to drop these views after you have populated the result tables query1, query2, ...
-- You can use the "\i a2.sql" command in psql to execute the SQL commands in this file.
-- Good Luck!

--Query 1 statements

CREATE VIEW champion1P(pid,tid,cid,pname) AS
	SELECT champion.pid,champion.tid,player.cid,player.pname
	FROM champion,player
	WHERE champion.pid = player.pid;

INSERT INTO query1
(
select country.cname,cP.pname,tou.tname
from champion1P cP, country,tournament tou
where cP.tid = tou.tid and tou.cid = cP.cid and tou.cid = country.cid
order by pname asc
);

DROP VIEW champion1P;

--Query 2 statements
create view totalCa(tid,totalCapacity) as
	select tid,sum(capacity)as totalCapacity
	from court
	group by tid
	order by totalCapacity DESC;

INSERT INTO query2
(select tname,totalCapacity
from tournament tn, totalCa
where tn.tid = (select tid as tid1 from totalCa where totalCapacity = (select max(totalCapacity) from totalCa))
	and tn.tid = totalCa.tid
order by tname ASC);

DROP VIEW totalCa;

--Query 3 statements
create view allPlayer as
	select player.pid as p1id,event.lossid as p2id from event,player 
	where event.winid = player.pid
	UNION
	select player.pid as p1id,event.winid as p2id from event,player 
	where event.lossid = player.pid
	order by p1id;

create view allPRank as 
	select p1id,p2id,player.globalrank as p2rank
	from allplayer ap,player
	where ap.p2id = player.pid;

-- highest global rank
create view p1p2 as
	select p1id,player.pname as p1name, min(p2rank) as p2HRank
	from allPRank,player
	where p1id = player.pid
	group by p1id,player.pname;

INSERT INTO query3
(select p1id,p1name,player.pid as p2id,player.pname as p2name
from p1p2,player
where player.globalrank = p1p2.p2HRank
order by p1name asc);



-- DROP VIEW allPlayer;
-- DROP VIEW allPRank;
-- DROP VIEW p1p2;

--Query 4 statements
-- find pid
create view pidF as
	select pid from player
	except
	select pid
	from(select pid,tid from player,tournament
		except
		select pid,tid from champion)as foo;
INSERT INTO query4
(select player.pid,pname
from pidF,player
where pidF.pid = player.pid
order by pname asc);
DROP VIEW pidF;

--Query 5 statements
INSERT INTO query5
(select record.pid,pname,avg(wins) as avgwins
from record,player
where year>=2011 and year <=2014 and player.pid = record.pid
group by record.pid,pname
order by avgwins desc
limit 10);

--Query 6 statements
INSERT INTO query6
(select r1.pid,pname
from record r1,record r2,record r3,record r4, player
where r1.year=2011 and r2.year = 2012 and r3.year = 2013 and r4.year = 2014 and r1.wins<r2.wins and r2.wins<r3.wins 
		and r3.wins<r4.wins and r1.pid = r2.pid and r2.pid = r3.pid and r3.pid =r4.pid and r1.pid = player.pid 
		
group by r1.pid,pname
order by pname asc);

--Query 7 statements
-- Find players that have been champions at least twice in a single year. Report the name of
--each player and the year(s) that they achieved this (If a player has achieved this twice, the result
--should include 2 tuples related to this player).

INSERT INTO query7
--要加distinct 防止重复
(select distinct pname,cp1.year
from champion cp1,champion cp2,player
where player.pid = cp1.pid and cp1.year = cp2.year and cp1.tid <> cp2.tid and cp1.pid = cp2.pid
order by pname desc,cp1.year desc);

--Query 8 statements
INSERT INTO query8
(select p1.pname as p1name,p2.pname as p2name,cname
from event ev,player p1,player p2,country
where ev.winid = p1.pid and ev.lossid=p2.pid and p1.cid = p2.cid
	and country.cid = p1.cid
union
select p1.pname as p1name,p2.pname as p2name,cname
from event ev,player p1,player p2,country
where ev.lossid = p1.pid and ev.winid=p2.pid and p1.cid = p2.cid
	and country.cid = p1.cid
order by cname asc, p1name desc);

--Query 9 statements
drop view if exists maxP CASCADE; 
create view maxP as
	select pid,count(tid) as nums
	from champion
	group by pid;
	
-- max pid,nums
create view maxP1 as
	select pid,nums as champions from maxP where nums = (select max(nums)from maxP);

INSERT INTO query9
(select cname,champions
from maxP1,country,player
where maxP1.pid=player.pid and player.cid = country.cid
ORDER by cname desc);



--Query 10 statements

-- Find the player(s) that had more wins than losses in 2014 in all courts 
--and their participationtime was more than 200 minutes on average 
--in all games (not only in 2014)
create view pid1 as 
	SELECT pid FROM record where year = 2014 and wins > losses
	INTERSECT
	(select winid as pid from event group by winid having avg(duration)>200
	union
	select lossid as pid from event group by lossid having avg(duration)>200);

INSERT INTO query10(
select pname from player,pid1 where player.pid = pid1.pid 
order by pname desc);








