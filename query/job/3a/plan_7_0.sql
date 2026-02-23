create or replace TEMP view aggView2008530262249930210 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin3263095346751493594 as select movie_id as v12 from movie_keyword as mk, aggView2008530262249930210 where mk.keyword_id=aggView2008530262249930210.v1;
create or replace TEMP view aggView8746110589605224228 as select v12, COUNT(*) as annot from aggJoin3263095346751493594 group by v12;
create or replace TEMP view aggJoin1197145752150546074 as select movie_id as v12, info as v7, annot from movie_info as mi, aggView8746110589605224228 where mi.movie_id=aggView8746110589605224228.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view aggView264839779605864373 as select v12, SUM(annot) as annot from aggJoin1197145752150546074 group by v12;
create or replace TEMP view aggJoin33806626350281054 as select title as v13, production_year as v16, annot from title as t, aggView264839779605864373 where t.id=aggView264839779605864373.v12 and (production_year > 2005);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin33806626350281054;
select sum(v24) from res;