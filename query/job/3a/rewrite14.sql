create or replace TEMP view aggView1222278553756924976 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin5942297521001560296 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView1222278553756924976 where t.id=aggView1222278553756924976.v12 and (production_year > 2005);
create or replace TEMP view aggView5621525565574430055 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin8728745374798100332 as select movie_id as v12 from movie_keyword as mk, aggView5621525565574430055 where mk.keyword_id=aggView5621525565574430055.v1;
create or replace TEMP view aggView302474629287493790 as select v12, MIN(v13) as v24 from aggJoin5942297521001560296 group by v12;
create or replace TEMP view aggJoin6260333082725730817 as select v24 from aggJoin8728745374798100332 join aggView302474629287493790 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin6260333082725730817;
select sum(v24) from res;