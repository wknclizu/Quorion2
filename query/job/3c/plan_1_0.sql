create or replace TEMP view aggView7709254700400417955 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin5959981938414186173 as select movie_id as v12 from movie_keyword as mk, aggView7709254700400417955 where mk.keyword_id=aggView7709254700400417955.v1;
create or replace TEMP view aggView8203124241485996336 as select v12, COUNT(*) as annot from aggJoin5959981938414186173 group by v12;
create or replace TEMP view aggJoin3231422255074494650 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView8203124241485996336 where t.id=aggView8203124241485996336.v12 and (production_year > 1990);
create or replace TEMP view aggView3002944436525003233 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin3231422255074494650 group by v12;
create or replace TEMP view aggJoin6544428152514326185 as select info as v7, v24, annot from movie_info as mi, aggView3002944436525003233 where mi.movie_id=aggView3002944436525003233.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin6544428152514326185;
select sum(v24) from res;