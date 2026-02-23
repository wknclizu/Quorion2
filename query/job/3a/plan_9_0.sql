create or replace TEMP view aggView1925137871964272842 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin9179102585942916703 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView1925137871964272842 where mk.movie_id=aggView1925137871964272842.v12;
create or replace TEMP view aggView6660212636178539484 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin4064573812876846037 as select v12, v24 from aggJoin9179102585942916703 join aggView6660212636178539484 using(v1);
create or replace TEMP view aggView2195234854199561963 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin4064573812876846037 group by v12;
create or replace TEMP view aggJoin4614205995243953825 as select info as v7, v24, annot from movie_info as mi, aggView2195234854199561963 where mi.movie_id=aggView2195234854199561963.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin4614205995243953825;
select sum(v24) from res;