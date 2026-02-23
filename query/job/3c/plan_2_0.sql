create or replace TEMP view aggView8642343797600142145 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin4909438426319395354 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView8642343797600142145 where t.id=aggView8642343797600142145.v12 and (production_year > 1990);
create or replace TEMP view aggView8236075339304685161 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin4909438426319395354 group by v12;
create or replace TEMP view aggJoin3859348728486391321 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView8236075339304685161 where mk.movie_id=aggView8236075339304685161.v12;
create or replace TEMP view aggView3939745300385197024 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin1414882254510665867 as select v24, annot from aggJoin3859348728486391321 join aggView3939745300385197024 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin1414882254510665867;
select sum(v24) from res;