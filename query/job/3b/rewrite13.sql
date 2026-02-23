create or replace TEMP view aggView1842142778269578492 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin4170666291397537641 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView1842142778269578492 where mi.movie_id=aggView1842142778269578492.v12 and (info = 'Bulgaria');
create or replace TEMP view aggView8227868379055149565 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin7707775816957077817 as select movie_id as v12 from movie_keyword as mk, aggView8227868379055149565 where mk.keyword_id=aggView8227868379055149565.v1;
create or replace TEMP view aggView6233173839575191659 as select v12, MIN(v24) as v24 from aggJoin4170666291397537641 group by v12,v24;
create or replace TEMP view aggJoin7591165869030873317 as select v24 from aggJoin7707775816957077817 join aggView6233173839575191659 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin7591165869030873317;
select sum(v24) from res;