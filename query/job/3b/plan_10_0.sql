create or replace TEMP view aggView4288162452625458610 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin864234030144881655 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView4288162452625458610 where mk.movie_id=aggView4288162452625458610.v12;
create or replace TEMP view aggView8132533383874811911 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin5273225897955775636 as select v1, v24 as v24, annot from aggJoin864234030144881655 join aggView8132533383874811911 using(v12);
create or replace TEMP view aggView1620299758745028221 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin584688044784628738 as select v24, annot from aggJoin5273225897955775636 join aggView1620299758745028221 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin584688044784628738;
select sum(v24) from res;