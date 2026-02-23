create or replace TEMP view aggView852689246303549376 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin1250149306264602928 as select movie_id as v12 from movie_keyword as mk, aggView852689246303549376 where mk.keyword_id=aggView852689246303549376.v1;
create or replace TEMP view aggView5837928386366157411 as select v12, COUNT(*) as annot from aggJoin1250149306264602928 group by v12;
create or replace TEMP view aggJoin125262189160986315 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView5837928386366157411 where t.id=aggView5837928386366157411.v12 and (production_year > 2010);
create or replace TEMP view aggView4253745251605779772 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin1780187756421853553 as select v13, v16, aggJoin125262189160986315.annot * aggView4253745251605779772.annot as annot from aggJoin125262189160986315 join aggView4253745251605779772 using(v12);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin1780187756421853553;
select sum(v24) from res;