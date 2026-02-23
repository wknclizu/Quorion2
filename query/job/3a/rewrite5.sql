create or replace TEMP view aggView8945944258313019082 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin7325229967643712060 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView8945944258313019082 where t.id=aggView8945944258313019082.v12 and (production_year > 2005);
create or replace TEMP view aggView3548286974815104381 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin649573069449687949 as select movie_id as v12 from movie_keyword as mk, aggView3548286974815104381 where mk.keyword_id=aggView3548286974815104381.v1;
create or replace TEMP view aggView6379427541340505795 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin7325229967643712060 group by v12;
create or replace TEMP view aggJoin2580893577575460370 as select v24, annot from aggJoin649573069449687949 join aggView6379427541340505795 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin2580893577575460370;
select sum(v24) from res;