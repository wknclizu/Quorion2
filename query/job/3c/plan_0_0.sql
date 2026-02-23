create or replace TEMP view aggView3377276411402050116 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American')) group by movie_id;
create or replace TEMP view aggJoin3150075168490002208 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView3377276411402050116 where t.id=aggView3377276411402050116.v12 and (production_year > 1990);
create or replace TEMP view aggView8063521753955062055 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin3150075168490002208 group by v12;
create or replace TEMP view aggJoin3021117465268240098 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView8063521753955062055 where mk.movie_id=aggView8063521753955062055.v12;
create or replace TEMP view aggView1686102800655915200 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin3021117465268240098 group by v1;
create or replace TEMP view aggJoin1291397294015236945 as select keyword as v2, v24, annot from keyword as k, aggView1686102800655915200 where k.id=aggView1686102800655915200.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin1291397294015236945;
select sum(v24) from res;