create or replace TEMP view aggView1701338900132044058 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin7516635550894836576 as select movie_id as v12, keyword_id as v1, annot from movie_keyword as mk, aggView1701338900132044058 where mk.movie_id=aggView1701338900132044058.v12;
create or replace TEMP view aggView7913325705586884203 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin1644124096605374606 as select v12, annot from aggJoin7516635550894836576 join aggView7913325705586884203 using(v1);
create or replace TEMP view aggView869970199886590523 as select v12, SUM(annot) as annot from aggJoin1644124096605374606 group by v12;
create or replace TEMP view aggJoin153623318532049187 as select title as v13, production_year as v16, annot from title as t, aggView869970199886590523 where t.id=aggView869970199886590523.v12 and (production_year > 2005);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin153623318532049187;
select sum(v24) from res;