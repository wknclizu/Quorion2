create or replace TEMP view aggView2081970688353776154 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin3082870968369393267 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView2081970688353776154 where mk.movie_id=aggView2081970688353776154.v12;
create or replace TEMP view aggView2434098319373363396 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin4135179497007208362 as select v12, v24 from aggJoin3082870968369393267 join aggView2434098319373363396 using(v1);
create or replace TEMP view aggView2269250305963257618 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin4135179497007208362 group by v12;
create or replace TEMP view aggJoin9138992871362944055 as select info as v7, v24, annot from movie_info as mi, aggView2269250305963257618 where mi.movie_id=aggView2269250305963257618.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin9138992871362944055;
select sum(v24) from res;