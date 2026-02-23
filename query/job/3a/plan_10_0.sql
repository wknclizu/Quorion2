create or replace TEMP view aggView1595215240872576972 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin2161893148501637569 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView1595215240872576972 where mk.movie_id=aggView1595215240872576972.v12;
create or replace TEMP view aggView7235524434836911631 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin8873214550287696099 as select v1, v24 as v24, annot from aggJoin2161893148501637569 join aggView7235524434836911631 using(v12);
create or replace TEMP view aggView6141163155786293137 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin4142278081223578019 as select v24, annot from aggJoin8873214550287696099 join aggView6141163155786293137 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin4142278081223578019;
select sum(v24) from res;