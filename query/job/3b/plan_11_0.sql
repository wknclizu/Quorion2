create or replace TEMP view aggView6329081851123465800 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin7496685207666737306 as select movie_id as v12, keyword_id as v1, annot from movie_keyword as mk, aggView6329081851123465800 where mk.movie_id=aggView6329081851123465800.v12;
create or replace TEMP view aggView5735888939623422091 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin5877002324561912342 as select v12, annot from aggJoin7496685207666737306 join aggView5735888939623422091 using(v1);
create or replace TEMP view aggView5758234970311644808 as select v12, SUM(annot) as annot from aggJoin5877002324561912342 group by v12;
create or replace TEMP view aggJoin83414043653292754 as select title as v13, production_year as v16, annot from title as t, aggView5758234970311644808 where t.id=aggView5758234970311644808.v12 and (production_year > 2010);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin83414043653292754;
select sum(v24) from res;