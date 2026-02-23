create or replace TEMP view aggView8791496968591710985 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin7914565221351269776 as select movie_id as v12, keyword_id as v1, annot from movie_keyword as mk, aggView8791496968591710985 where mk.movie_id=aggView8791496968591710985.v12;
create or replace TEMP view aggView6841023574338572491 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin139487352573616994 as select v12, annot from aggJoin7914565221351269776 join aggView6841023574338572491 using(v1);
create or replace TEMP view aggView9200399964074968037 as select v12, SUM(annot) as annot from aggJoin139487352573616994 group by v12;
create or replace TEMP view aggJoin5597142935202424171 as select title as v13, production_year as v16, annot from title as t, aggView9200399964074968037 where t.id=aggView9200399964074968037.v12 and (production_year > 2010);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin5597142935202424171;
select sum(v24) from res;