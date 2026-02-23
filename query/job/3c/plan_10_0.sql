create or replace TEMP view aggView6759199190769110773 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin4910247771727913903 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView6759199190769110773 where mk.movie_id=aggView6759199190769110773.v12;
create or replace TEMP view aggView7003592250557732438 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin8835078176280192625 as select v1, v24 as v24, annot from aggJoin4910247771727913903 join aggView7003592250557732438 using(v12);
create or replace TEMP view aggView3135728068490389481 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin4681184973645522160 as select v24, annot from aggJoin8835078176280192625 join aggView3135728068490389481 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin4681184973645522160;
select sum(v24) from res;