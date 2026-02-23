create or replace TEMP view aggView1725893499119972880 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin3650890769852258718 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView1725893499119972880 where t.id=aggView1725893499119972880.v12 and (production_year > 1990);
create or replace TEMP view aggView6611511615018673413 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin8843641416658482249 as select movie_id as v12 from movie_keyword as mk, aggView6611511615018673413 where mk.keyword_id=aggView6611511615018673413.v1;
create or replace TEMP view aggView8682459620069799087 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin3650890769852258718 group by v12;
create or replace TEMP view aggJoin3222085038192289618 as select v24, annot from aggJoin8843641416658482249 join aggView8682459620069799087 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin3222085038192289618;
select sum(v24) from res;