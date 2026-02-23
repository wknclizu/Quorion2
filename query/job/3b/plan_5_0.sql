create or replace TEMP view aggView4988122391538070532 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin6824713120815143234 as select movie_id as v12 from movie_keyword as mk, aggView4988122391538070532 where mk.keyword_id=aggView4988122391538070532.v1;
create or replace TEMP view aggView2932629016166890811 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin8208496785537898491 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView2932629016166890811 where mi.movie_id=aggView2932629016166890811.v12 and (info = 'Bulgaria');
create or replace TEMP view aggView8805300092798267157 as select v12, COUNT(*) as annot from aggJoin6824713120815143234 group by v12;
create or replace TEMP view aggJoin5059216654830837980 as select v7, v24 as v24, annot from aggJoin8208496785537898491 join aggView8805300092798267157 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin5059216654830837980;
select sum(v24) from res;