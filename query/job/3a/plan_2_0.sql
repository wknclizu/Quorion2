create or replace TEMP view aggView8336712919307149229 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin6391429350300624177 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView8336712919307149229 where t.id=aggView8336712919307149229.v12 and (production_year > 2005);
create or replace TEMP view aggView7086492050663968887 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin6391429350300624177 group by v12;
create or replace TEMP view aggJoin1958577038232063418 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView7086492050663968887 where mk.movie_id=aggView7086492050663968887.v12;
create or replace TEMP view aggView485978372199420059 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin8762929117311146095 as select v24, annot from aggJoin1958577038232063418 join aggView485978372199420059 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin8762929117311146095;
select sum(v24) from res;