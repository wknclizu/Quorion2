create or replace TEMP view aggView1947125963989126482 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin7227165620770738882 as select movie_id as v12 from movie_keyword as mk, aggView1947125963989126482 where mk.keyword_id=aggView1947125963989126482.v1;
create or replace TEMP view aggView716586538090228610 as select v12, COUNT(*) as annot from aggJoin7227165620770738882 group by v12;
create or replace TEMP view aggJoin7345355740207588662 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView716586538090228610 where t.id=aggView716586538090228610.v12 and (production_year > 1990);
create or replace TEMP view aggView4279763967993218134 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin4319602776907346495 as select v13, v16, aggJoin7345355740207588662.annot * aggView4279763967993218134.annot as annot from aggJoin7345355740207588662 join aggView4279763967993218134 using(v12);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin4319602776907346495;
select sum(v24) from res;