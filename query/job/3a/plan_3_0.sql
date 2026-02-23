create or replace TEMP view aggView9155073136026835982 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin7178586352133257970 as select movie_id as v12 from movie_keyword as mk, aggView9155073136026835982 where mk.keyword_id=aggView9155073136026835982.v1;
create or replace TEMP view aggView6936697657775377918 as select v12, COUNT(*) as annot from aggJoin7178586352133257970 group by v12;
create or replace TEMP view aggJoin6766213753137716035 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView6936697657775377918 where t.id=aggView6936697657775377918.v12 and (production_year > 2005);
create or replace TEMP view aggView1961765666959671851 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin5149282772549693039 as select v13, v16, aggJoin6766213753137716035.annot * aggView1961765666959671851.annot as annot from aggJoin6766213753137716035 join aggView1961765666959671851 using(v12);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin5149282772549693039;
select sum(v24) from res;