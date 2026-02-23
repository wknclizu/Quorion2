create or replace TEMP view aggView3917982443141104823 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin2263045370837575097 as select movie_id as v12 from movie_keyword as mk, aggView3917982443141104823 where mk.keyword_id=aggView3917982443141104823.v1;
create or replace TEMP view aggView7663924319131632495 as select v12, COUNT(*) as annot from aggJoin2263045370837575097 group by v12;
create or replace TEMP view aggJoin1355387649916319039 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView7663924319131632495 where t.id=aggView7663924319131632495.v12 and (production_year > 1990);
create or replace TEMP view aggView1354396489317416533 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin2192497582645490119 as select v13, v16, aggJoin1355387649916319039.annot * aggView1354396489317416533.annot as annot from aggJoin1355387649916319039 join aggView1354396489317416533 using(v12);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin2192497582645490119;
select sum(v24) from res;