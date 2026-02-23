create or replace TEMP view aggView8819626789222351928 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin7817805872669832077 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView8819626789222351928 where mk.movie_id=aggView8819626789222351928.v12;
create or replace TEMP view aggView2144867669045679406 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin6029042134398747269 as select v12, v24 from aggJoin7817805872669832077 join aggView2144867669045679406 using(v1);
create or replace TEMP view aggView2244533892556033675 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin6029042134398747269 group by v12;
create or replace TEMP view aggJoin4457897358288024569 as select info as v7, v24, annot from movie_info as mi, aggView2244533892556033675 where mi.movie_id=aggView2244533892556033675.v12 and (info = 'Bulgaria');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin4457897358288024569;
select sum(v24) from res;