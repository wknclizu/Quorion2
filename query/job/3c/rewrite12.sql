create or replace TEMP view aggView7271689470338280839 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin712974393228401336 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView7271689470338280839 where t.id=aggView7271689470338280839.v12 and (production_year > 1990);
create or replace TEMP view aggView15552448498747164 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin7051147475583238002 as select movie_id as v12 from movie_keyword as mk, aggView15552448498747164 where mk.keyword_id=aggView15552448498747164.v1;
create or replace TEMP view aggView3210092005206033148 as select v12, MIN(v13) as v24 from aggJoin712974393228401336 group by v12;
create or replace TEMP view aggJoin7224577317107376042 as select v24 from aggJoin7051147475583238002 join aggView3210092005206033148 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin7224577317107376042;
select sum(v24) from res;