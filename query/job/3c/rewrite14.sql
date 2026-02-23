create or replace TEMP view aggView7819108648500459552 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin9040901773513483684 as select movie_id as v12 from movie_keyword as mk, aggView7819108648500459552 where mk.keyword_id=aggView7819108648500459552.v1;
create or replace TEMP view aggView9090726621277615501 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin120248514261600235 as select v12, annot from aggJoin9040901773513483684 join aggView9090726621277615501 using(v12);
create or replace TEMP view aggView8374994163087422395 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin7412794037567754980 as select v24 as v24 from aggJoin120248514261600235 join aggView8374994163087422395 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin7412794037567754980;
select sum(v24) from res;