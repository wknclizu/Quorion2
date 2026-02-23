create or replace TEMP view aggView9008633291344915290 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin8168156409750600991 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView9008633291344915290 where mi.movie_id=aggView9008633291344915290.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view aggView2964715412967714099 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin7097856319545931408 as select movie_id as v12 from movie_keyword as mk, aggView2964715412967714099 where mk.keyword_id=aggView2964715412967714099.v1;
create or replace TEMP view aggView3566546557493660801 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin8168156409750600991 group by v12;
create or replace TEMP view aggJoin6251975190185477514 as select v24, annot from aggJoin7097856319545931408 join aggView3566546557493660801 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin6251975190185477514;
select sum(v24) from res;