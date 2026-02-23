create or replace TEMP view aggView4747985123807831004 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin7878299989834843869 as select movie_id as v12 from movie_keyword as mk, aggView4747985123807831004 where mk.keyword_id=aggView4747985123807831004.v1;
create or replace TEMP view aggView1482365625839134180 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin6203954371737296544 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView1482365625839134180 where mi.movie_id=aggView1482365625839134180.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view aggView7562496155591331929 as select v12, COUNT(*) as annot from aggJoin7878299989834843869 group by v12;
create or replace TEMP view aggJoin5869181590067469608 as select v7, v24 as v24, annot from aggJoin6203954371737296544 join aggView7562496155591331929 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin5869181590067469608;
select sum(v24) from res;