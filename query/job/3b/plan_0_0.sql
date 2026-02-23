create or replace TEMP view aggView7333691183048269240 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info = 'Bulgaria') group by movie_id;
create or replace TEMP view aggJoin4691927123074541608 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView7333691183048269240 where t.id=aggView7333691183048269240.v12 and (production_year > 2010);
create or replace TEMP view aggView3243636908068922965 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin4691927123074541608 group by v12;
create or replace TEMP view aggJoin5122972846023780704 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView3243636908068922965 where mk.movie_id=aggView3243636908068922965.v12;
create or replace TEMP view aggView2309563245377167917 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin5122972846023780704 group by v1;
create or replace TEMP view aggJoin9105442485289905505 as select keyword as v2, v24, annot from keyword as k, aggView2309563245377167917 where k.id=aggView2309563245377167917.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin9105442485289905505;
select sum(v24) from res;