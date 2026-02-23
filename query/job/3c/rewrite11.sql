create or replace TEMP view aggView3510075321232303974 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin8967301608445762243 as select movie_id as v12 from movie_keyword as mk, aggView3510075321232303974 where mk.keyword_id=aggView3510075321232303974.v1;
create or replace TEMP view aggView2980033193034856969 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin1667769602662963125 as select v12, annot from aggJoin8967301608445762243 join aggView2980033193034856969 using(v12);
create or replace TEMP view aggView5575854429223956289 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin7489010424435818035 as select annot, v24 as v24 from aggJoin1667769602662963125 join aggView5575854429223956289 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin7489010424435818035;
select sum(v24) from res;