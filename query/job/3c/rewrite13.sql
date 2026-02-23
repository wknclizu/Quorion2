create or replace TEMP view aggView761028696320534966 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin19083868914781160 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView761028696320534966 where mi.movie_id=aggView761028696320534966.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view aggView5053848032068258763 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin2861514099175098815 as select movie_id as v12 from movie_keyword as mk, aggView5053848032068258763 where mk.keyword_id=aggView5053848032068258763.v1;
create or replace TEMP view aggView3909306373123559527 as select v12, MIN(v24) as v24 from aggJoin19083868914781160 group by v12,v24;
create or replace TEMP view aggJoin5929679573083521175 as select v24 from aggJoin2861514099175098815 join aggView3909306373123559527 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin5929679573083521175;
select sum(v24) from res;