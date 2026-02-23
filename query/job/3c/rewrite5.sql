create or replace TEMP view aggView8651568937205660970 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin6699976107430052769 as select movie_id as v12 from movie_keyword as mk, aggView8651568937205660970 where mk.keyword_id=aggView8651568937205660970.v1;
create or replace TEMP view aggView2592845503064573715 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin2614356603832510938 as select v12, annot from aggJoin6699976107430052769 join aggView2592845503064573715 using(v12);
create or replace TEMP view aggView83036321595984579 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin8848969358746621758 as select annot, v24 as v24 from aggJoin2614356603832510938 join aggView83036321595984579 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin8848969358746621758;
select sum(v24) from res;