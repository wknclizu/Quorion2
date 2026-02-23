create or replace TEMP view aggView6551816742834577994 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin5288621867894230453 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView6551816742834577994 where t.id=aggView6551816742834577994.v12 and (production_year > 1990);
create or replace TEMP view aggView1937554377022503930 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin2681031299176030237 as select movie_id as v12 from movie_keyword as mk, aggView1937554377022503930 where mk.keyword_id=aggView1937554377022503930.v1;
create or replace TEMP view aggView5884754826816279500 as select v12, MIN(v13) as v24 from aggJoin5288621867894230453 group by v12;
create or replace TEMP view aggJoin3659412253372267476 as select v24 from aggJoin2681031299176030237 join aggView5884754826816279500 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin3659412253372267476;
select sum(v24) from res;