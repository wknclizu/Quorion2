create or replace TEMP view aggView6861335684750550290 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin6414399758757797986 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView6861335684750550290 where mi.movie_id=aggView6861335684750550290.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view aggView1270850690248602724 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin6414399758757797986 group by v12;
create or replace TEMP view aggJoin8750460856957027975 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView1270850690248602724 where mk.movie_id=aggView1270850690248602724.v12;
create or replace TEMP view aggView589193269773774454 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin8750460856957027975 group by v1;
create or replace TEMP view aggJoin4190984171317858197 as select keyword as v2, v24, annot from keyword as k, aggView589193269773774454 where k.id=aggView589193269773774454.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin4190984171317858197;
select sum(v24) from res;