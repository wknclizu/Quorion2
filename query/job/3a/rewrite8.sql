create or replace TEMP view aggView7427774395608345029 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin1394287058592835374 as select movie_id as v12 from movie_keyword as mk, aggView7427774395608345029 where mk.keyword_id=aggView7427774395608345029.v1;
create or replace TEMP view aggView1257133143166487706 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin4770094113631854606 as select v12, annot from aggJoin1394287058592835374 join aggView1257133143166487706 using(v12);
create or replace TEMP view aggView8794161577846427242 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin2812773876608591448 as select annot, v24 as v24 from aggJoin4770094113631854606 join aggView8794161577846427242 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin2812773876608591448;
select sum(v24) from res;