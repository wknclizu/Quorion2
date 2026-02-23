create or replace TEMP view aggView8226695332573052780 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin1919731348734776007 as select movie_id as v12 from movie_keyword as mk, aggView8226695332573052780 where mk.keyword_id=aggView8226695332573052780.v1;
create or replace TEMP view aggView6809265179111486860 as select v12, COUNT(*) as annot from aggJoin1919731348734776007 group by v12;
create or replace TEMP view aggJoin663868757395870295 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView6809265179111486860 where t.id=aggView6809265179111486860.v12 and (production_year > 2005);
create or replace TEMP view aggView763501483912259784 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin3005749726503880255 as select v13, v16, aggJoin663868757395870295.annot * aggView763501483912259784.annot as annot from aggJoin663868757395870295 join aggView763501483912259784 using(v12);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin3005749726503880255;
select sum(v24) from res;