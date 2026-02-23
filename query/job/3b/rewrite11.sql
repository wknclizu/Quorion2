create or replace TEMP view aggView4654864820500731874 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin2040618554965539257 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView4654864820500731874 where mi.movie_id=aggView4654864820500731874.v12 and (info = 'Bulgaria');
create or replace TEMP view aggView4063023329956776508 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin2752365647901903037 as select movie_id as v12 from movie_keyword as mk, aggView4063023329956776508 where mk.keyword_id=aggView4063023329956776508.v1;
create or replace TEMP view aggView2221556665001820256 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin2040618554965539257 group by v12;
create or replace TEMP view aggJoin5658047698961706915 as select v24, annot from aggJoin2752365647901903037 join aggView2221556665001820256 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin5658047698961706915;
select sum(v24) from res;