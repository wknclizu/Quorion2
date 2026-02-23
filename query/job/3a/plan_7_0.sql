create or replace TEMP view aggView1616365516662575172 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin3613095164144913957 as select movie_id as v12 from movie_keyword as mk, aggView1616365516662575172 where mk.keyword_id=aggView1616365516662575172.v1;
create or replace TEMP view aggView4448948073595150713 as select v12, COUNT(*) as annot from aggJoin3613095164144913957 group by v12;
create or replace TEMP view aggJoin6518888274595426666 as select movie_id as v12, info as v7, annot from movie_info as mi, aggView4448948073595150713 where mi.movie_id=aggView4448948073595150713.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view aggView2289049391844396531 as select v12, SUM(annot) as annot from aggJoin6518888274595426666 group by v12;
create or replace TEMP view aggJoin3169845789664182898 as select title as v13, production_year as v16, annot from title as t, aggView2289049391844396531 where t.id=aggView2289049391844396531.v12 and (production_year > 2005);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin3169845789664182898;
select sum(v24) from res;