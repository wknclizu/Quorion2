create or replace TEMP view aggView2042666017279647161 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin1893612909296444052 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView2042666017279647161 where mi.movie_id=aggView2042666017279647161.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view aggView1836030607431387197 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin1893612909296444052 group by v12;
create or replace TEMP view aggJoin3696373408116690868 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView1836030607431387197 where mk.movie_id=aggView1836030607431387197.v12;
create or replace TEMP view aggView2443335538576864537 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin3696373408116690868 group by v1;
create or replace TEMP view aggJoin4595708083366404113 as select keyword as v2, v24, annot from keyword as k, aggView2443335538576864537 where k.id=aggView2443335538576864537.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin4595708083366404113;
select sum(v24) from res;