create or replace TEMP view aggView2241859547709128498 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin8739674683633221899 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView2241859547709128498 where mi.movie_id=aggView2241859547709128498.v12 and (info = 'Bulgaria');
create or replace TEMP view aggView8890183515775574371 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin8739674683633221899 group by v12;
create or replace TEMP view aggJoin2603587225741190050 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView8890183515775574371 where mk.movie_id=aggView8890183515775574371.v12;
create or replace TEMP view aggView4423074367854882083 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin2603587225741190050 group by v1;
create or replace TEMP view aggJoin6904182358160804610 as select keyword as v2, v24, annot from keyword as k, aggView4423074367854882083 where k.id=aggView4423074367854882083.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin6904182358160804610;
select sum(v24) from res;