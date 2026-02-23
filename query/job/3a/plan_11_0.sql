create or replace TEMP view aggView1771680713566038341 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin7369890184767332717 as select movie_id as v12, keyword_id as v1, annot from movie_keyword as mk, aggView1771680713566038341 where mk.movie_id=aggView1771680713566038341.v12;
create or replace TEMP view aggView7740456938280841316 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin4298684924153005921 as select v12, annot from aggJoin7369890184767332717 join aggView7740456938280841316 using(v1);
create or replace TEMP view aggView411591168480364270 as select v12, SUM(annot) as annot from aggJoin4298684924153005921 group by v12;
create or replace TEMP view aggJoin2426677549985796542 as select title as v13, production_year as v16, annot from title as t, aggView411591168480364270 where t.id=aggView411591168480364270.v12 and (production_year > 2005);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin2426677549985796542;
select sum(v24) from res;