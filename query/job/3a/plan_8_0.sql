create or replace TEMP view aggView6575871390778864597 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin5656520782692549248 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView6575871390778864597 where mk.movie_id=aggView6575871390778864597.v12;
create or replace TEMP view aggView4598904483576694316 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin7727869774348151396 as select v1, v24 as v24, annot from aggJoin5656520782692549248 join aggView4598904483576694316 using(v12);
create or replace TEMP view aggView716667455156473726 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin7727869774348151396 group by v1;
create or replace TEMP view aggJoin1872537030490688023 as select keyword as v2, v24, annot from keyword as k, aggView716667455156473726 where k.id=aggView716667455156473726.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin1872537030490688023;
select sum(v24) from res;