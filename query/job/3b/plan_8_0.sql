create or replace TEMP view aggView8452686190767535605 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin7203128386241470560 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView8452686190767535605 where mk.movie_id=aggView8452686190767535605.v12;
create or replace TEMP view aggView7582071726605144428 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin5099685233131495454 as select v1, v24 as v24, annot from aggJoin7203128386241470560 join aggView7582071726605144428 using(v12);
create or replace TEMP view aggView4317142429829231270 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin5099685233131495454 group by v1;
create or replace TEMP view aggJoin3067848771947059041 as select keyword as v2, v24, annot from keyword as k, aggView4317142429829231270 where k.id=aggView4317142429829231270.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin3067848771947059041;
select sum(v24) from res;