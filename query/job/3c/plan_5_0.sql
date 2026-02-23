create or replace TEMP view aggView845608034374864767 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin1605681870209839498 as select movie_id as v12 from movie_keyword as mk, aggView845608034374864767 where mk.keyword_id=aggView845608034374864767.v1;
create or replace TEMP view aggView8261964998172320102 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin1896410174137744278 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView8261964998172320102 where mi.movie_id=aggView8261964998172320102.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view aggView7316558121556016827 as select v12, COUNT(*) as annot from aggJoin1605681870209839498 group by v12;
create or replace TEMP view aggJoin3794844048290772804 as select v7, v24 as v24, annot from aggJoin1896410174137744278 join aggView7316558121556016827 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin3794844048290772804;
select sum(v24) from res;