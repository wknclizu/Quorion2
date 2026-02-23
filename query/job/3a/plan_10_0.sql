create or replace TEMP view aggView7935299954832559972 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin5527266705353817122 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView7935299954832559972 where mk.movie_id=aggView7935299954832559972.v12;
create or replace TEMP view aggView3340103565304536310 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin7745807862616522502 as select v1, v24 as v24, annot from aggJoin5527266705353817122 join aggView3340103565304536310 using(v12);
create or replace TEMP view aggView8275745462629408908 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin9202016255171197431 as select v24, annot from aggJoin7745807862616522502 join aggView8275745462629408908 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin9202016255171197431;
select sum(v24) from res;