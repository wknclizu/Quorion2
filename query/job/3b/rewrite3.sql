create or replace TEMP view aggView6738753431418479997 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin9044895455427573185 as select movie_id as v12 from movie_keyword as mk, aggView6738753431418479997 where mk.keyword_id=aggView6738753431418479997.v1;
create or replace TEMP view aggView7539963112914405661 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin9003664957761936035 as select v12, annot from aggJoin9044895455427573185 join aggView7539963112914405661 using(v12);
create or replace TEMP view aggView1752291365603934750 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin7938463591559527917 as select annot, v24 as v24 from aggJoin9003664957761936035 join aggView1752291365603934750 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin7938463591559527917;
select sum(v24) from res;