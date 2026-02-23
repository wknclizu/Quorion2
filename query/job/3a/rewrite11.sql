create or replace TEMP view aggView8522005045845876302 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin6952047517642390680 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView8522005045845876302 where t.id=aggView8522005045845876302.v12 and (production_year > 2005);
create or replace TEMP view aggView3240411709639907457 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin7264040688910503355 as select movie_id as v12 from movie_keyword as mk, aggView3240411709639907457 where mk.keyword_id=aggView3240411709639907457.v1;
create or replace TEMP view aggView7844438787763524781 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin6952047517642390680 group by v12;
create or replace TEMP view aggJoin4098421623583524905 as select v24, annot from aggJoin7264040688910503355 join aggView7844438787763524781 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin4098421623583524905;
select sum(v24) from res;