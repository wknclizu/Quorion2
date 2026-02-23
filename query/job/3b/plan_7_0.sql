create or replace TEMP view aggView136751903822897243 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin175210609928659103 as select movie_id as v12 from movie_keyword as mk, aggView136751903822897243 where mk.keyword_id=aggView136751903822897243.v1;
create or replace TEMP view aggView2069170901955212498 as select v12, COUNT(*) as annot from aggJoin175210609928659103 group by v12;
create or replace TEMP view aggJoin5694810654737138865 as select movie_id as v12, info as v7, annot from movie_info as mi, aggView2069170901955212498 where mi.movie_id=aggView2069170901955212498.v12 and (info = 'Bulgaria');
create or replace TEMP view aggView3584632024089313410 as select v12, SUM(annot) as annot from aggJoin5694810654737138865 group by v12;
create or replace TEMP view aggJoin7320181934032738297 as select title as v13, production_year as v16, annot from title as t, aggView3584632024089313410 where t.id=aggView3584632024089313410.v12 and (production_year > 2010);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin7320181934032738297;
select sum(v24) from res;