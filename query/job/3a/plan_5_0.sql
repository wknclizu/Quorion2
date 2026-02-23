create or replace TEMP view aggView1058469787411198334 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin4207706136184572276 as select movie_id as v12 from movie_keyword as mk, aggView1058469787411198334 where mk.keyword_id=aggView1058469787411198334.v1;
create or replace TEMP view aggView2156892001951051202 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin3576674823607546687 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView2156892001951051202 where mi.movie_id=aggView2156892001951051202.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view aggView302791766406732652 as select v12, COUNT(*) as annot from aggJoin4207706136184572276 group by v12;
create or replace TEMP view aggJoin5753353428669263266 as select v7, v24 as v24, annot from aggJoin3576674823607546687 join aggView302791766406732652 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin5753353428669263266;
select sum(v24) from res;