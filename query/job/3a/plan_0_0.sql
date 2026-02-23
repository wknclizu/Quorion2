create or replace TEMP view aggView8269414683376363764 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin7400669533554079801 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView8269414683376363764 where t.id=aggView8269414683376363764.v12 and (production_year > 2005);
create or replace TEMP view aggView1433675118125856600 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin7400669533554079801 group by v12;
create or replace TEMP view aggJoin7301539616802263815 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView1433675118125856600 where mk.movie_id=aggView1433675118125856600.v12;
create or replace TEMP view aggView5047702885850506186 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin7301539616802263815 group by v1;
create or replace TEMP view aggJoin8270899649550736387 as select keyword as v2, v24, annot from keyword as k, aggView5047702885850506186 where k.id=aggView5047702885850506186.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin8270899649550736387;
select sum(v24) from res;