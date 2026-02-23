create or replace TEMP view aggView572809121946588244 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin2402465705026819319 as select movie_id as v12, keyword_id as v1, v24 from movie_keyword as mk, aggView572809121946588244 where mk.movie_id=aggView572809121946588244.v12;
create or replace TEMP view aggView7582265150435408571 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin3218162321439306443 as select v12, v24 from aggJoin2402465705026819319 join aggView7582265150435408571 using(v1);
create or replace TEMP view aggView6967580106752979637 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin3218162321439306443 group by v12;
create or replace TEMP view aggJoin2068435526596394321 as select info as v7, v24, annot from movie_info as mi, aggView6967580106752979637 where mi.movie_id=aggView6967580106752979637.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin2068435526596394321;
select sum(v24) from res;