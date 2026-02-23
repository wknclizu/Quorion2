create or replace TEMP view aggView8573591325431891131 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin4247777377385691237 as select movie_id as v12 from movie_keyword as mk, aggView8573591325431891131 where mk.keyword_id=aggView8573591325431891131.v1;
create or replace TEMP view aggView6506074123144397999 as select v12, COUNT(*) as annot from aggJoin4247777377385691237 group by v12;
create or replace TEMP view aggJoin8350997241846250622 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView6506074123144397999 where t.id=aggView6506074123144397999.v12 and (production_year > 2010);
create or replace TEMP view aggView8165136997988828481 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin8350997241846250622 group by v12;
create or replace TEMP view aggJoin8291239379472238977 as select info as v7, v24, annot from movie_info as mi, aggView8165136997988828481 where mi.movie_id=aggView8165136997988828481.v12 and (info = 'Bulgaria');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin8291239379472238977;
select sum(v24) from res;