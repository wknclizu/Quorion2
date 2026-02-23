create or replace TEMP view aggView4790351064679504035 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin705739320682385730 as select movie_id as v12 from movie_keyword as mk, aggView4790351064679504035 where mk.keyword_id=aggView4790351064679504035.v1;
create or replace TEMP view aggView7668170224366154911 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin5218724131475885898 as select v12, v24 from aggJoin705739320682385730 join aggView7668170224366154911 using(v12);
create or replace TEMP view aggView8366060250933045938 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin5218724131475885898 group by v12;
create or replace TEMP view aggJoin7128690020559087400 as select info as v7, v24, annot from movie_info as mi, aggView8366060250933045938 where mi.movie_id=aggView8366060250933045938.v12 and (info = 'Bulgaria');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin7128690020559087400;
select sum(v24) from res;