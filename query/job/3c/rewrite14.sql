create or replace TEMP view aggView3964700241761106364 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin3176181941413454520 as select movie_id as v12 from movie_keyword as mk, aggView3964700241761106364 where mk.keyword_id=aggView3964700241761106364.v1;
create or replace TEMP view aggView6928667899739812830 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin4938114875138273572 as select v12, annot from aggJoin3176181941413454520 join aggView6928667899739812830 using(v12);
create or replace TEMP view aggView2868510849895759438 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin3030273500954569773 as select v24 as v24 from aggJoin4938114875138273572 join aggView2868510849895759438 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin3030273500954569773;
select sum(v24) from res;