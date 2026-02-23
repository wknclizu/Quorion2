create or replace TEMP view aggView9002890611930089856 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin7267006739815816077 as select movie_id as v12 from movie_keyword as mk, aggView9002890611930089856 where mk.keyword_id=aggView9002890611930089856.v1;
create or replace TEMP view aggView7901251660480108770 as select id as v12, title as v24 from title as t where (production_year > 2005);
create or replace TEMP view aggJoin4653532852604147757 as select v12, v24 from aggJoin7267006739815816077 join aggView7901251660480108770 using(v12);
create or replace TEMP view aggView3772386215085564555 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin4653532852604147757 group by v12;
create or replace TEMP view aggJoin743218061154122791 as select info as v7, v24, annot from movie_info as mi, aggView3772386215085564555 where mi.movie_id=aggView3772386215085564555.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin743218061154122791;
select sum(v24) from res;