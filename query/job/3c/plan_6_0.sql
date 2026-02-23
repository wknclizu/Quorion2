create or replace TEMP view aggView3541104734685453194 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin4970875715605821220 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView3541104734685453194 where mi.movie_id=aggView3541104734685453194.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view aggView1623778757516891375 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin4970875715605821220 group by v12;
create or replace TEMP view aggJoin9168119017575548863 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView1623778757516891375 where mk.movie_id=aggView1623778757516891375.v12;
create or replace TEMP view aggView6033959867497613668 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin8914168106611911566 as select v24, annot from aggJoin9168119017575548863 join aggView6033959867497613668 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin8914168106611911566;
select sum(v24) from res;