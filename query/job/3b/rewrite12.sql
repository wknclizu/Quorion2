create or replace TEMP view aggView2103845183889994423 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin4188480039059947627 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView2103845183889994423 where t.id=aggView2103845183889994423.v12 and (production_year > 2010);
create or replace TEMP view aggView3122762107033541146 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin1964450356771096324 as select movie_id as v12 from movie_keyword as mk, aggView3122762107033541146 where mk.keyword_id=aggView3122762107033541146.v1;
create or replace TEMP view aggView2319383689980824882 as select v12, MIN(v13) as v24 from aggJoin4188480039059947627 group by v12;
create or replace TEMP view aggJoin4360396319125004572 as select v24 from aggJoin1964450356771096324 join aggView2319383689980824882 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin4360396319125004572;
select sum(v24) from res;