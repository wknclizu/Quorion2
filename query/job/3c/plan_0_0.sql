create or replace TEMP view aggView5596720513845419096 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin4526096706561801137 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView5596720513845419096 where t.id=aggView5596720513845419096.v12 and (production_year > 1990);
create or replace TEMP view aggView8051673856372283687 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin4526096706561801137 group by v12;
create or replace TEMP view aggJoin5740529843251855578 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView8051673856372283687 where mk.movie_id=aggView8051673856372283687.v12;
create or replace TEMP view aggView9058707000467976648 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin5740529843251855578 group by v1;
create or replace TEMP view aggJoin7124161764012055707 as select keyword as v2, v24, annot from keyword as k, aggView9058707000467976648 where k.id=aggView9058707000467976648.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin7124161764012055707;
select sum(v24) from res;