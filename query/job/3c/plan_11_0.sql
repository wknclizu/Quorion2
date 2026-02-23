create or replace TEMP view aggView596934123511324141 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin8630007359337735565 as select movie_id as v12, keyword_id as v1, annot from movie_keyword as mk, aggView596934123511324141 where mk.movie_id=aggView596934123511324141.v12;
create or replace TEMP view aggView1039804764553204184 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin244232372901120870 as select v12, annot from aggJoin8630007359337735565 join aggView1039804764553204184 using(v1);
create or replace TEMP view aggView1552501877763454842 as select v12, SUM(annot) as annot from aggJoin244232372901120870 group by v12;
create or replace TEMP view aggJoin610666402649059016 as select title as v13, production_year as v16, annot from title as t, aggView1552501877763454842 where t.id=aggView1552501877763454842.v12 and (production_year > 1990);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin610666402649059016;
select sum(v24) from res;