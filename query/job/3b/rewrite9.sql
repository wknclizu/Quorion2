create or replace TEMP view aggView4532894882113451335 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin9209976056951509452 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView4532894882113451335 where mi.movie_id=aggView4532894882113451335.v12 and (info = 'Bulgaria');
create or replace TEMP view aggView3976458051211179938 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin4264297165896110215 as select movie_id as v12 from movie_keyword as mk, aggView3976458051211179938 where mk.keyword_id=aggView3976458051211179938.v1;
create or replace TEMP view aggView393876416454442821 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin9209976056951509452 group by v12;
create or replace TEMP view aggJoin3697251847716069622 as select v24, annot from aggJoin4264297165896110215 join aggView393876416454442821 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin3697251847716069622;
select sum(v24) from res;