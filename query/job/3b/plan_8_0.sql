create or replace TEMP view aggView2912191340104113639 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin6491391802078301623 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView2912191340104113639 where mk.movie_id=aggView2912191340104113639.v12;
create or replace TEMP view aggView2286616913030998389 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin3116145504274014472 as select v1, v24 as v24, annot from aggJoin6491391802078301623 join aggView2286616913030998389 using(v12);
create or replace TEMP view aggView6598201945623073516 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin3116145504274014472 group by v1;
create or replace TEMP view aggJoin2848990237191492020 as select keyword as v2, v24, annot from keyword as k, aggView6598201945623073516 where k.id=aggView6598201945623073516.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin2848990237191492020;
select sum(v24) from res;