create or replace TEMP view aggView8121150412614554935 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin6856437789556006646 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView8121150412614554935 where t.id=aggView8121150412614554935.v12 and (production_year > 2010);
create or replace TEMP view aggView6276355936027995555 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin6856437789556006646 group by v12;
create or replace TEMP view aggJoin8819706836440641496 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView6276355936027995555 where mk.movie_id=aggView6276355936027995555.v12;
create or replace TEMP view aggView7493742790516706585 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin688091437378764178 as select v24, annot from aggJoin8819706836440641496 join aggView7493742790516706585 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin688091437378764178;
select sum(v24) from res;