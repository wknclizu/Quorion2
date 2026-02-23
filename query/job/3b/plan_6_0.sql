create or replace TEMP view aggView9168847123314937909 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin7711677031416415884 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView9168847123314937909 where mi.movie_id=aggView9168847123314937909.v12 and (info = 'Bulgaria');
create or replace TEMP view aggView7662679066537084915 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin7711677031416415884 group by v12;
create or replace TEMP view aggJoin4272191951408258043 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView7662679066537084915 where mk.movie_id=aggView7662679066537084915.v12;
create or replace TEMP view aggView7351880451788028596 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin2456441171728393985 as select v24, annot from aggJoin4272191951408258043 join aggView7351880451788028596 using(v1);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin2456441171728393985;
select sum(v24) from res;