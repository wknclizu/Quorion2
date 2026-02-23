create or replace TEMP view aggView8343243482393862071 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin146201276496925169 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView8343243482393862071 where mi.movie_id=aggView8343243482393862071.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view aggView4883824595697747017 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin146201276496925169 group by v12;
create or replace TEMP view aggJoin2034348195611445418 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView4883824595697747017 where mk.movie_id=aggView4883824595697747017.v12;
create or replace TEMP view aggView1565919472375938870 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin2034348195611445418 group by v1;
create or replace TEMP view aggJoin8133573015688182603 as select keyword as v2, v24, annot from keyword as k, aggView1565919472375938870 where k.id=aggView1565919472375938870.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin8133573015688182603;
select sum(v24) from res;