create or replace TEMP view aggView4853517402352105994 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin2882761740845282743 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView4853517402352105994 where mi.movie_id=aggView4853517402352105994.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view aggView696281875743720308 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin8548780075894681738 as select movie_id as v12 from movie_keyword as mk, aggView696281875743720308 where mk.keyword_id=aggView696281875743720308.v1;
create or replace TEMP view aggView8915251614801395028 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin2882761740845282743 group by v12;
create or replace TEMP view aggJoin207218507300551329 as select v24, annot from aggJoin8548780075894681738 join aggView8915251614801395028 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin207218507300551329;
select sum(v24) from res;