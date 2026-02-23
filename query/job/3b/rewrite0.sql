create or replace TEMP view aggView8322159508196083469 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin4775913518898562438 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView8322159508196083469 where t.id=aggView8322159508196083469.v12 and (production_year > 2010);
create or replace TEMP view aggView8831877917545570430 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin6877722232366061635 as select movie_id as v12 from movie_keyword as mk, aggView8831877917545570430 where mk.keyword_id=aggView8831877917545570430.v1;
create or replace TEMP view aggView1287978577316938017 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin4775913518898562438 group by v12;
create or replace TEMP view aggJoin4447542382669734033 as select v24, annot from aggJoin6877722232366061635 join aggView1287978577316938017 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin4447542382669734033;
select sum(v24) from res;