create or replace TEMP view aggView5325776320926209177 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin1122776381542490534 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView5325776320926209177 where mi.movie_id=aggView5325776320926209177.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view aggView4110466731173713271 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin3810535556898564421 as select movie_id as v12 from movie_keyword as mk, aggView4110466731173713271 where mk.keyword_id=aggView4110466731173713271.v1;
create or replace TEMP view aggView9216590608185873445 as select v12, MIN(v24) as v24 from aggJoin1122776381542490534 group by v12,v24;
create or replace TEMP view aggJoin1446161465351474677 as select v24 from aggJoin3810535556898564421 join aggView9216590608185873445 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin1446161465351474677;
select sum(v24) from res;