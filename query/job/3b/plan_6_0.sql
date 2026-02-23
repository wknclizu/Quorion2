create or replace TEMP view aggView8385484524410258012 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin7618313702267203345 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView8385484524410258012 where mi.movie_id=aggView8385484524410258012.v12 and (info = 'Bulgaria');
create or replace TEMP view aggView2216195340265582140 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin7618313702267203345 group by v12;
create or replace TEMP view aggJoin6618705279404779054 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView2216195340265582140 where mk.movie_id=aggView2216195340265582140.v12;
create or replace TEMP view aggView2574322499967223248 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin3754425212050798959 as select v24, annot from aggJoin6618705279404779054 join aggView2574322499967223248 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin3754425212050798959;
select sum(v24) from res;