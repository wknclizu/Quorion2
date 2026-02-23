create or replace TEMP view aggView3720701855471801683 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin3029022348502249357 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView3720701855471801683 where mi.movie_id=aggView3720701855471801683.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view aggView3351886796723847415 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin3029022348502249357 group by v12;
create or replace TEMP view aggJoin5808091810286959027 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView3351886796723847415 where mk.movie_id=aggView3351886796723847415.v12;
create or replace TEMP view aggView1508030218828445494 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin2136673416299002887 as select v24, annot from aggJoin5808091810286959027 join aggView1508030218828445494 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin2136673416299002887;
select sum(v24) from res;