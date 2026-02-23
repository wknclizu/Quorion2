create or replace TEMP view aggView4304972818315193751 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin4053993099959700143 as select movie_id as v12 from movie_keyword as mk, aggView4304972818315193751 where mk.keyword_id=aggView4304972818315193751.v1;
create or replace TEMP view aggView7914089419413141591 as select v12, COUNT(*) as annot from aggJoin4053993099959700143 group by v12;
create or replace TEMP view aggJoin7556541663865245488 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView7914089419413141591 where t.id=aggView7914089419413141591.v12 and (production_year > 1990);
create or replace TEMP view aggView8561705238225128674 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin7556541663865245488 group by v12;
create or replace TEMP view aggJoin4990519762680907821 as select info as v7, v24, annot from movie_info as mi, aggView8561705238225128674 where mi.movie_id=aggView8561705238225128674.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin4990519762680907821;
select sum(v24) from res;