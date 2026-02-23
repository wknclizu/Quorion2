create or replace TEMP view aggView2107853388020675316 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin5305722342205358620 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView2107853388020675316 where mk.movie_id=aggView2107853388020675316.v12;
create or replace TEMP view aggView2635474124646057572 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin2222280215042498308 as select v1, v24 as v24, annot from aggJoin5305722342205358620 join aggView2635474124646057572 using(v12);
create or replace TEMP view aggView7065499955958657574 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin2222280215042498308 group by v1;
create or replace TEMP view aggJoin3322183420320105470 as select keyword as v2, v24, annot from keyword as k, aggView7065499955958657574 where k.id=aggView7065499955958657574.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin3322183420320105470;
select sum(v24) from res;