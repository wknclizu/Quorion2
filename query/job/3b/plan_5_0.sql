create or replace TEMP view aggView8622045708667099172 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin512856567075015743 as select movie_id as v12 from movie_keyword as mk, aggView8622045708667099172 where mk.keyword_id=aggView8622045708667099172.v1;
create or replace TEMP view aggView7075317923754165352 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin7389181006608329181 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView7075317923754165352 where mi.movie_id=aggView7075317923754165352.v12 and (info = 'Bulgaria');
create or replace TEMP view aggView4767840795822081876 as select v12, COUNT(*) as annot from aggJoin512856567075015743 group by v12;
create or replace TEMP view aggJoin7611565692281917024 as select v7, v24 as v24, annot from aggJoin7389181006608329181 join aggView4767840795822081876 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin7611565692281917024;
select sum(v24) from res;