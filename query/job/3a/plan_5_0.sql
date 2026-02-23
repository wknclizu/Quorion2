create or replace TEMP view aggView7202574557437190319 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin6615237187425435028 as select movie_id as v12 from movie_keyword as mk, aggView7202574557437190319 where mk.keyword_id=aggView7202574557437190319.v1;
create or replace TEMP view aggView4945339506284953216 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin5437689738570847881 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView4945339506284953216 where mi.movie_id=aggView4945339506284953216.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view aggView8778227054655664961 as select v12, COUNT(*) as annot from aggJoin6615237187425435028 group by v12;
create or replace TEMP view aggJoin8446125225411981353 as select v7, v24 as v24, annot from aggJoin5437689738570847881 join aggView8778227054655664961 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin8446125225411981353;
select sum(v24) from res;