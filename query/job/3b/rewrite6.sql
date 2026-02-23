create or replace TEMP view aggView2118358471181630585 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin8828140405077560860 as select movie_id as v12 from movie_keyword as mk, aggView2118358471181630585 where mk.keyword_id=aggView2118358471181630585.v1;
create or replace TEMP view aggView7147211460813413605 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin7077548112899577539 as select v12, v24 from aggJoin8828140405077560860 join aggView7147211460813413605 using(v12);
create or replace TEMP view aggView5301973483243131330 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin7077548112899577539 group by v12;
create or replace TEMP view aggJoin3868460760342240856 as select info as v7, v24, annot from movie_info as mi, aggView5301973483243131330 where mi.movie_id=aggView5301973483243131330.v12 and (info = 'Bulgaria');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin3868460760342240856;
select sum(v24) from res;