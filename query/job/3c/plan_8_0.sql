create or replace TEMP view aggView7829619444675050592 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin2337892149010105557 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView7829619444675050592 where mk.movie_id=aggView7829619444675050592.v12;
create or replace TEMP view aggView4034002134484525947 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin1103538822764826877 as select v1, v24 as v24, annot from aggJoin2337892149010105557 join aggView4034002134484525947 using(v12);
create or replace TEMP view aggView4748935660813711424 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin1103538822764826877 group by v1;
create or replace TEMP view aggJoin6741103761047866691 as select keyword as v2, v24, annot from keyword as k, aggView4748935660813711424 where k.id=aggView4748935660813711424.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin6741103761047866691;
select sum(v24) from res;