create or replace TEMP view aggView7882248228303258385 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin8203904282427103396 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView7882248228303258385 where t.id=aggView7882248228303258385.v12 and (production_year > 2010);
create or replace TEMP view aggView6531351994955446557 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin46540911257939042 as select movie_id as v12 from movie_keyword as mk, aggView6531351994955446557 where mk.keyword_id=aggView6531351994955446557.v1;
create or replace TEMP view aggView1500727391236106780 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin8203904282427103396 group by v12;
create or replace TEMP view aggJoin919537808998511940 as select v24, annot from aggJoin46540911257939042 join aggView1500727391236106780 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin919537808998511940;
select sum(v24) from res;