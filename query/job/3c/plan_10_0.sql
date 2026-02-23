create or replace TEMP view aggView1352787798699191943 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin7008331212091730692 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView1352787798699191943 where mk.movie_id=aggView1352787798699191943.v12;
create or replace TEMP view aggView439658827198630223 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin5819539681185095762 as select v1, v24 as v24, annot from aggJoin7008331212091730692 join aggView439658827198630223 using(v12);
create or replace TEMP view aggView5126037230094513089 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin5532478173122427446 as select v24, annot from aggJoin5819539681185095762 join aggView5126037230094513089 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin5532478173122427446;
select sum(v24) from res;