create or replace TEMP view aggView3915182740201656560 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin8182221958798065411 as select movie_id as v12 from movie_keyword as mk, aggView3915182740201656560 where mk.keyword_id=aggView3915182740201656560.v1;
create or replace TEMP view aggView1672918699654065477 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin1515152060749790755 as select v12, annot from aggJoin8182221958798065411 join aggView1672918699654065477 using(v12);
create or replace TEMP view aggView6727735099181416323 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin5739713140491555677 as select v24 as v24 from aggJoin1515152060749790755 join aggView6727735099181416323 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin5739713140491555677;
select sum(v24) from res;