create or replace TEMP view aggView8265638968205789175 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin1988524750000078957 as select movie_id as v12 from movie_keyword as mk, aggView8265638968205789175 where mk.keyword_id=aggView8265638968205789175.v1;
create or replace TEMP view aggView4456169743550427454 as select v12, COUNT(*) as annot from aggJoin1988524750000078957 group by v12;
create or replace TEMP view aggJoin5382924965945827441 as select movie_id as v12, info as v7, annot from movie_info as mi, aggView4456169743550427454 where mi.movie_id=aggView4456169743550427454.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view aggView8377311775440960622 as select v12, SUM(annot) as annot from aggJoin5382924965945827441 group by v12;
create or replace TEMP view aggJoin4910112047621551097 as select title as v13, production_year as v16, annot from title as t, aggView8377311775440960622 where t.id=aggView8377311775440960622.v12 and (production_year > 1990);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin4910112047621551097;
select sum(v24) from res;