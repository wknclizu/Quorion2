create or replace TEMP view aggView5773193787377971660 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin7174356974832966949 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView5773193787377971660 where mi.movie_id=aggView5773193787377971660.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view aggView3605621189730568916 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin2071546045046812280 as select movie_id as v12 from movie_keyword as mk, aggView3605621189730568916 where mk.keyword_id=aggView3605621189730568916.v1;
create or replace TEMP view aggView1006438495491901030 as select v12, MIN(v24) as v24 from aggJoin7174356974832966949 group by v12,v24;
create or replace TEMP view aggJoin8187130082442778555 as select v24 from aggJoin2071546045046812280 join aggView1006438495491901030 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin8187130082442778555;
select sum(v24) from res;