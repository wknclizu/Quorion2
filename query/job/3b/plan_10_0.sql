create or replace TEMP view aggView2827611236020325619 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin8677664132228137763 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView2827611236020325619 where mk.movie_id=aggView2827611236020325619.v12;
create or replace TEMP view aggView7103335075315881710 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin2912842048747372469 as select v1, v24 as v24, annot from aggJoin8677664132228137763 join aggView7103335075315881710 using(v12);
create or replace TEMP view aggView8795021615675169932 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin4127874680518260002 as select v24, annot from aggJoin2912842048747372469 join aggView8795021615675169932 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin4127874680518260002;
select sum(v24) from res;