create or replace TEMP view aggView670446270246024820 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin1949860981765654861 as select movie_id as v12 from movie_keyword as mk, aggView670446270246024820 where mk.keyword_id=aggView670446270246024820.v1;
create or replace TEMP view aggView4884827936150401687 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin6306855238856670477 as select v12, annot from aggJoin1949860981765654861 join aggView4884827936150401687 using(v12);
create or replace TEMP view aggView5869552180686725579 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin1348940881221423547 as select v24 as v24 from aggJoin6306855238856670477 join aggView5869552180686725579 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin1348940881221423547;
select sum(v24) from res;