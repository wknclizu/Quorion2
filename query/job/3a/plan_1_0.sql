create or replace TEMP view aggView457238578375838748 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin4348289980843073347 as select movie_id as v12 from movie_keyword as mk, aggView457238578375838748 where mk.keyword_id=aggView457238578375838748.v1;
create or replace TEMP view aggView5076116173442041409 as select v12, COUNT(*) as annot from aggJoin4348289980843073347 group by v12;
create or replace TEMP view aggJoin3062932777472852029 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView5076116173442041409 where t.id=aggView5076116173442041409.v12 and (production_year > 2005);
create or replace TEMP view aggView7676342280794671478 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin3062932777472852029 group by v12;
create or replace TEMP view aggJoin7984548829620346609 as select info as v7, v24, annot from movie_info as mi, aggView7676342280794671478 where mi.movie_id=aggView7676342280794671478.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin7984548829620346609;
select sum(v24) from res;