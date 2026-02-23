create or replace TEMP view aggView2913529523487471275 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin578085170479949151 as select movie_id as v12 from movie_keyword as mk, aggView2913529523487471275 where mk.keyword_id=aggView2913529523487471275.v1;
create or replace TEMP view aggView8494507283908281261 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin2328739548777827066 as select v12, annot from aggJoin578085170479949151 join aggView8494507283908281261 using(v12);
create or replace TEMP view aggView8430433994693095479 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin6670057517665181610 as select v24 as v24 from aggJoin2328739548777827066 join aggView8430433994693095479 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin6670057517665181610;
select sum(v24) from res;