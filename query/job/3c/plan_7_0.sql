create or replace TEMP view aggView8542157048286851104 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin3582989743723254941 as select movie_id as v12 from movie_keyword as mk, aggView8542157048286851104 where mk.keyword_id=aggView8542157048286851104.v1;
create or replace TEMP view aggView5429854013722380031 as select v12, COUNT(*) as annot from aggJoin3582989743723254941 group by v12;
create or replace TEMP view aggJoin5931751212278365832 as select movie_id as v12, info as v7, annot from movie_info as mi, aggView5429854013722380031 where mi.movie_id=aggView5429854013722380031.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view aggView3682030965257579335 as select v12, SUM(annot) as annot from aggJoin5931751212278365832 group by v12;
create or replace TEMP view aggJoin6138931599040058199 as select title as v13, production_year as v16, annot from title as t, aggView3682030965257579335 where t.id=aggView3682030965257579335.v12 and (production_year > 1990);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin6138931599040058199;
select sum(v24) from res;