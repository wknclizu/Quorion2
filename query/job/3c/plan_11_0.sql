create or replace TEMP view aggView7568205037982906815 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin3876669155124289674 as select movie_id as v12, keyword_id as v1, annot from movie_keyword as mk, aggView7568205037982906815 where mk.movie_id=aggView7568205037982906815.v12;
create or replace TEMP view aggView2655268822143457268 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin7382396968351194765 as select v12, annot from aggJoin3876669155124289674 join aggView2655268822143457268 using(v1);
create or replace TEMP view aggView8038892146099817151 as select v12, SUM(annot) as annot from aggJoin7382396968351194765 group by v12;
create or replace TEMP view aggJoin4213434763904005102 as select title as v13, production_year as v16, annot from title as t, aggView8038892146099817151 where t.id=aggView8038892146099817151.v12 and (production_year > 1990);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin4213434763904005102;
select sum(v24) from res;