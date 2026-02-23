create or replace TEMP view aggView1518985098184658617 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin6997269077452631282 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView1518985098184658617 where mi.movie_id=aggView1518985098184658617.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view aggView379485103468503245 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin5128971731219394178 as select movie_id as v12 from movie_keyword as mk, aggView379485103468503245 where mk.keyword_id=aggView379485103468503245.v1;
create or replace TEMP view aggView1599023929399536953 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin6997269077452631282 group by v12;
create or replace TEMP view aggJoin3028116418638252851 as select v24, annot from aggJoin5128971731219394178 join aggView1599023929399536953 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin3028116418638252851;
select sum(v24) from res;