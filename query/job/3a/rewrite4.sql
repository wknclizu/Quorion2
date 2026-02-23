create or replace TEMP view aggView979279666761628008 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin8519341058440564897 as select movie_id as v12 from movie_keyword as mk, aggView979279666761628008 where mk.keyword_id=aggView979279666761628008.v1;
create or replace TEMP view aggView4696443167920246420 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin1720565665350080104 as select v12, annot from aggJoin8519341058440564897 join aggView4696443167920246420 using(v12);
create or replace TEMP view aggView3592588228484944799 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin2837599301377746292 as select annot, v24 as v24 from aggJoin1720565665350080104 join aggView3592588228484944799 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin2837599301377746292;
select sum(v24) from res;