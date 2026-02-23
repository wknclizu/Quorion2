create or replace TEMP view aggView8242242102409726538 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin3867847327265531549 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView8242242102409726538 where mk.movie_id=aggView8242242102409726538.v12;
create or replace TEMP view aggView4954434470812638059 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin6437460789277080121 as select v12, v24 from aggJoin3867847327265531549 join aggView4954434470812638059 using(v1);
create or replace TEMP view aggView7144804373455674314 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin6437460789277080121 group by v12;
create or replace TEMP view aggJoin499546607588048170 as select info as v7, v24, annot from movie_info as mi, aggView7144804373455674314 where mi.movie_id=aggView7144804373455674314.v12 and (info = 'Bulgaria');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin499546607588048170;
select sum(v24) from res;