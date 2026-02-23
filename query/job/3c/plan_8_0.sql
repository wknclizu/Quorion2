create or replace TEMP view aggView6745387743719306039 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin2149367595596054243 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView6745387743719306039 where mk.movie_id=aggView6745387743719306039.v12;
create or replace TEMP view aggView1145406010375494004 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin4284592831878585933 as select v1, v24 as v24, annot from aggJoin2149367595596054243 join aggView1145406010375494004 using(v12);
create or replace TEMP view aggView3819444238884867235 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin4284592831878585933 group by v1;
create or replace TEMP view aggJoin4098935055620352934 as select keyword as v2, v24, annot from keyword as k, aggView3819444238884867235 where k.id=aggView3819444238884867235.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin4098935055620352934;
select sum(v24) from res;