create or replace TEMP view aggView741563191913451599 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin4986266969547989058 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView741563191913451599 where mi.movie_id=aggView741563191913451599.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view aggView9187322720799756349 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin4986266969547989058 group by v12;
create or replace TEMP view aggJoin1889137263350256250 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView9187322720799756349 where mk.movie_id=aggView9187322720799756349.v12;
create or replace TEMP view aggView3644531525256008188 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin1780840996378408914 as select v24, annot from aggJoin1889137263350256250 join aggView3644531525256008188 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin1780840996378408914;
select sum(v24) from res;