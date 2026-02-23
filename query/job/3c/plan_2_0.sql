create or replace TEMP view aggView436593687621807321 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin7562837475308280554 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView436593687621807321 where t.id=aggView436593687621807321.v12 and (production_year > 1990);
create or replace TEMP view aggView3740897460300777356 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin7562837475308280554 group by v12;
create or replace TEMP view aggJoin6139787588418425019 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView3740897460300777356 where mk.movie_id=aggView3740897460300777356.v12;
create or replace TEMP view aggView8477198310107945613 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin4364449056346761492 as select v24, annot from aggJoin6139787588418425019 join aggView8477198310107945613 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin4364449056346761492;
select sum(v24) from res;