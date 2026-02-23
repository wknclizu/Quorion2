create or replace TEMP view aggView3581088143993279087 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin5264340910174165881 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView3581088143993279087 where t.id=aggView3581088143993279087.v12 and (production_year > 2010);
create or replace TEMP view aggView8333653435971116454 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin5264340910174165881 group by v12;
create or replace TEMP view aggJoin3561099086756490795 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView8333653435971116454 where mk.movie_id=aggView8333653435971116454.v12;
create or replace TEMP view aggView2889269690748142264 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin3049780897383283594 as select v24, annot from aggJoin3561099086756490795 join aggView2889269690748142264 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin3049780897383283594;
select sum(v24) from res;