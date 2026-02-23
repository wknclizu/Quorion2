create or replace TEMP view aggView5106411233573992589 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin5869541106383900864 as select movie_id as v12 from movie_keyword as mk, aggView5106411233573992589 where mk.keyword_id=aggView5106411233573992589.v1;
create or replace TEMP view aggView6567977508900315823 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin3418704064663986363 as select v12, v24 from aggJoin5869541106383900864 join aggView6567977508900315823 using(v12);
create or replace TEMP view aggView4883421245658747693 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin3418704064663986363 group by v12;
create or replace TEMP view aggJoin6698441740933279228 as select info as v7, v24, annot from movie_info as mi, aggView4883421245658747693 where mi.movie_id=aggView4883421245658747693.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin6698441740933279228;
select sum(v24) from res;