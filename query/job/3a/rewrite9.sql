create or replace TEMP view aggView7943977603252813379 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin8591561762674857590 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView7943977603252813379 where mi.movie_id=aggView7943977603252813379.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view aggView4706177028042976739 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin4311263338721496671 as select movie_id as v12 from movie_keyword as mk, aggView4706177028042976739 where mk.keyword_id=aggView4706177028042976739.v1;
create or replace TEMP view aggView7821736245020107325 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin8591561762674857590 group by v12;
create or replace TEMP view aggJoin2334957876285990498 as select v24, annot from aggJoin4311263338721496671 join aggView7821736245020107325 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin2334957876285990498;
select sum(v24) from res;