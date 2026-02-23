create or replace TEMP view aggView3727769110107869397 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin3579685470530575802 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView3727769110107869397 where mi.movie_id=aggView3727769110107869397.v12 and (info = 'Bulgaria');
create or replace TEMP view aggView1781050048719281948 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin349810776257104415 as select movie_id as v12 from movie_keyword as mk, aggView1781050048719281948 where mk.keyword_id=aggView1781050048719281948.v1;
create or replace TEMP view aggView8174758508384072410 as select v12, MIN(v24) as v24 from aggJoin3579685470530575802 group by v12,v24;
create or replace TEMP view aggJoin7374515941331111009 as select v24 from aggJoin349810776257104415 join aggView8174758508384072410 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin7374515941331111009;
select sum(v24) from res;