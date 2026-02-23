create or replace TEMP view aggView5219207928420413949 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin591434268366514489 as select movie_id as v12 from movie_keyword as mk, aggView5219207928420413949 where mk.keyword_id=aggView5219207928420413949.v1;
create or replace TEMP view aggView6415860554847350379 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin7985149615010331670 as select v12, v24 from aggJoin591434268366514489 join aggView6415860554847350379 using(v12);
create or replace TEMP view aggView5517946999038869889 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin7985149615010331670 group by v12;
create or replace TEMP view aggJoin8384522348624177704 as select info as v7, v24, annot from movie_info as mi, aggView5517946999038869889 where mi.movie_id=aggView5517946999038869889.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin8384522348624177704;
select sum(v24) from res;