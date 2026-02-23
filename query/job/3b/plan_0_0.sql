create or replace TEMP view aggView3478774430139839709 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin2674735261152001213 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView3478774430139839709 where t.id=aggView3478774430139839709.v12 and (production_year > 2010);
create or replace TEMP view aggView2553896081347301880 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin2674735261152001213 group by v12;
create or replace TEMP view aggJoin2877871434539984594 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView2553896081347301880 where mk.movie_id=aggView2553896081347301880.v12;
create or replace TEMP view aggView2250597830707087670 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin2877871434539984594 group by v1;
create or replace TEMP view aggJoin7252314267425958607 as select keyword as v2, v24, annot from keyword as k, aggView2250597830707087670 where k.id=aggView2250597830707087670.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin7252314267425958607;
select sum(v24) from res;