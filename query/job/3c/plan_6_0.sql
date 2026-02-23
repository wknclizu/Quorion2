create or replace TEMP view aggView6400994537062746842 as select id as v12, title as v24 from title as t where (production_year > 1990);
create or replace TEMP view aggJoin1329053983222401765 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView6400994537062746842 where mi.movie_id=aggView6400994537062746842.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German','USA','American'));
create or replace TEMP view aggView8583954240472420919 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin1329053983222401765 group by v12;
create or replace TEMP view aggJoin878560956449507127 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView8583954240472420919 where mk.movie_id=aggView8583954240472420919.v12;
create or replace TEMP view aggView1209140042261086806 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin4426062561597109985 as select v24, annot from aggJoin878560956449507127 join aggView1209140042261086806 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin4426062561597109985;
select sum(v24) from res;