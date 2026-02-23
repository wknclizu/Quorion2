create or replace TEMP view aggView7360861067854427740 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin8686488396455603903 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView7360861067854427740 where t.id=aggView7360861067854427740.v12 and (production_year > 2005);
create or replace TEMP view aggView2506583226973522355 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin8686488396455603903 group by v12;
create or replace TEMP view aggJoin8166487157354607716 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView2506583226973522355 where mk.movie_id=aggView2506583226973522355.v12;
create or replace TEMP view aggView2516460422460280408 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin1485610420220272210 as select v24, annot from aggJoin8166487157354607716 join aggView2516460422460280408 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin1485610420220272210;
select sum(v24) from res;