create or replace TEMP view aggView2797151719132353493 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin6850310202051596168 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView2797151719132353493 where mk.movie_id=aggView2797151719132353493.v12;
create or replace TEMP view aggView1049534391407932983 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin2985782773272567988 as select v12, v24 from aggJoin6850310202051596168 join aggView1049534391407932983 using(v1);
create or replace TEMP view aggView7965120897842621196 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin2985782773272567988 group by v12;
create or replace TEMP view aggJoin2128524058186891271 as select info as v7, v24, annot from movie_info as mi, aggView7965120897842621196 where mi.movie_id=aggView7965120897842621196.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin2128524058186891271;
select sum(v24) from res;