create or replace TEMP view aggView6391484636965623881 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin574042520776438193 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView6391484636965623881 where t.id=aggView6391484636965623881.v12 and (production_year > 2010);
create or replace TEMP view aggView8767726633507354996 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin6222997388784628829 as select movie_id as v12 from movie_keyword as mk, aggView8767726633507354996 where mk.keyword_id=aggView8767726633507354996.v1;
create or replace TEMP view aggView462145404629148435 as select v12, MIN(v13) as v24 from aggJoin574042520776438193 group by v12;
create or replace TEMP view aggJoin8872965994766110954 as select v24 from aggJoin6222997388784628829 join aggView462145404629148435 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin8872965994766110954;
select sum(v24) from res;