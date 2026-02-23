create or replace TEMP view aggView2759343444490315433 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin3727865497665188152 as select movie_id as v12 from movie_keyword as mk, aggView2759343444490315433 where mk.keyword_id=aggView2759343444490315433.v1;
create or replace TEMP view aggView8054437072747045870 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin2083006839626613301 as select v12, annot from aggJoin3727865497665188152 join aggView8054437072747045870 using(v12);
create or replace TEMP view aggView3569428881581582776 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin2418695754662833723 as select v24 as v24 from aggJoin2083006839626613301 join aggView3569428881581582776 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin2418695754662833723;
select sum(v24) from res;