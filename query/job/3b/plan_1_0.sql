create or replace TEMP view aggView552868924119126329 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin7491065812510090733 as select movie_id as v12 from movie_keyword as mk, aggView552868924119126329 where mk.keyword_id=aggView552868924119126329.v1;
create or replace TEMP view aggView6941910672655221407 as select v12, COUNT(*) as annot from aggJoin7491065812510090733 group by v12;
create or replace TEMP view aggJoin1639415510430989853 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView6941910672655221407 where t.id=aggView6941910672655221407.v12 and (production_year > 2010);
create or replace TEMP view aggView3595308564501589066 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin1639415510430989853 group by v12;
create or replace TEMP view aggJoin261386462199207302 as select info as v7, v24, annot from movie_info as mi, aggView3595308564501589066 where mi.movie_id=aggView3595308564501589066.v12 and (info = 'Bulgaria');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin261386462199207302;
select sum(v24) from res;