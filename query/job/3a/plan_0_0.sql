create or replace TEMP view aggView43711468611725001 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin3533222997213266777 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView43711468611725001 where t.id=aggView43711468611725001.v12 and (production_year > 2005);
create or replace TEMP view aggView4543039921237263917 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin3533222997213266777 group by v12;
create or replace TEMP view aggJoin3153351290472472315 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView4543039921237263917 where mk.movie_id=aggView4543039921237263917.v12;
create or replace TEMP view aggView7085702467329405547 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin3153351290472472315 group by v1;
create or replace TEMP view aggJoin334232393822629928 as select keyword as v2, v24, annot from keyword as k, aggView7085702467329405547 where k.id=aggView7085702467329405547.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin334232393822629928;
select sum(v24) from res;