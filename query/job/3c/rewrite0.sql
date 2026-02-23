create or replace TEMP view aggView7935339782517387629 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin5950998143229019718 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView7935339782517387629 where t.id=aggView7935339782517387629.v12 and (production_year > 1990);
create or replace TEMP view aggView574140381841438623 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin3185847331889266934 as select movie_id as v12 from movie_keyword as mk, aggView574140381841438623 where mk.keyword_id=aggView574140381841438623.v1;
create or replace TEMP view aggView2537921535506070935 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin5950998143229019718 group by v12;
create or replace TEMP view aggJoin4708426395972461159 as select v24, annot from aggJoin3185847331889266934 join aggView2537921535506070935 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin4708426395972461159;
select sum(v24) from res;