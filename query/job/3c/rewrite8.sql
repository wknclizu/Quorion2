create or replace TEMP view aggView3936701120091077108 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin5413287475977850904 as select movie_id as v12 from movie_keyword as mk, aggView3936701120091077108 where mk.keyword_id=aggView3936701120091077108.v1;
create or replace TEMP view aggView6839901263507336388 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin1829713589627707306 as select v12, v24 from aggJoin5413287475977850904 join aggView6839901263507336388 using(v12);
create or replace TEMP view aggView538412471607099349 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin1829713589627707306 group by v12;
create or replace TEMP view aggJoin8810557101613843881 as select info as v7, v24, annot from movie_info as mi, aggView538412471607099349 where mi.movie_id=aggView538412471607099349.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin8810557101613843881;
select sum(v24) from res;