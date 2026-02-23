create or replace TEMP view aggView1942624394853181084 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin684219650108057995 as select movie_id as v12 from movie_keyword as mk, aggView1942624394853181084 where mk.keyword_id=aggView1942624394853181084.v1;
create or replace TEMP view aggView1901189900120426758 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin1063343188563154178 as select v12, annot from aggJoin684219650108057995 join aggView1901189900120426758 using(v12);
create or replace TEMP view aggView8649410023552200908 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin2058451253545196465 as select annot, v24 as v24 from aggJoin1063343188563154178 join aggView8649410023552200908 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin2058451253545196465;
select sum(v24) from res;