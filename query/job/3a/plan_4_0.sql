create or replace TEMP view aggView236451047562851825 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin340813291746821016 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView236451047562851825 where mi.movie_id=aggView236451047562851825.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view aggView3900521188307376034 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin340813291746821016 group by v12;
create or replace TEMP view aggJoin1010414272830654997 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView3900521188307376034 where mk.movie_id=aggView3900521188307376034.v12;
create or replace TEMP view aggView8846328740432570247 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin1010414272830654997 group by v1;
create or replace TEMP view aggJoin2959354665755148154 as select keyword as v2, v24, annot from keyword as k, aggView8846328740432570247 where k.id=aggView8846328740432570247.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin2959354665755148154;
select sum(v24) from res;