create or replace TEMP view aggView472117104841350743 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin691882944919090526 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView472117104841350743 where mi.movie_id=aggView472117104841350743.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view aggView7834846084998197111 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin2619471464054956816 as select movie_id as v12 from movie_keyword as mk, aggView7834846084998197111 where mk.keyword_id=aggView7834846084998197111.v1;
create or replace TEMP view aggView526518638787719940 as select v12, MIN(v24) as v24 from aggJoin691882944919090526 group by v12,v24;
create or replace TEMP view aggJoin1915570530404471621 as select v24 from aggJoin2619471464054956816 join aggView526518638787719940 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin1915570530404471621;
select sum(v24) from res;