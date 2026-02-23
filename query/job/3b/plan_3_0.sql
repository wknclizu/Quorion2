create or replace TEMP view aggView8799234795166794024 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin1826036774359184700 as select movie_id as v12 from movie_keyword as mk, aggView8799234795166794024 where mk.keyword_id=aggView8799234795166794024.v1;
create or replace TEMP view aggView7121524670574042207 as select v12, COUNT(*) as annot from aggJoin1826036774359184700 group by v12;
create or replace TEMP view aggJoin9151294792604104237 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView7121524670574042207 where t.id=aggView7121524670574042207.v12 and (production_year > 2010);
create or replace TEMP view aggView4388016759935551596 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin4876930989875319052 as select v13, v16, aggJoin9151294792604104237.annot * aggView4388016759935551596.annot as annot from aggJoin9151294792604104237 join aggView4388016759935551596 using(v12);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin4876930989875319052;
select sum(v24) from res;