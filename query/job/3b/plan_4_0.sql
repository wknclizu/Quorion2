create or replace TEMP view aggView978903181228790550 as select id as v12, title as v24 from title as t where (production_year > 2010);
create or replace TEMP view aggJoin6712479976427038565 as select movie_id as v12, info as v7, v24 from movie_info as mi, aggView978903181228790550 where mi.movie_id=aggView978903181228790550.v12 and (info = 'Bulgaria');
create or replace TEMP view aggView4551261338355323781 as select v12, MIN(v24) as v24, COUNT(*) as annot from aggJoin6712479976427038565 group by v12;
create or replace TEMP view aggJoin2503012513497527633 as select keyword_id as v1, v24, annot from movie_keyword as mk, aggView4551261338355323781 where mk.movie_id=aggView4551261338355323781.v12;
create or replace TEMP view aggView7929315931342641033 as select v1, MIN(v24) as v24, SUM(annot) as annot from aggJoin2503012513497527633 group by v1;
create or replace TEMP view aggJoin4394160485451940380 as select keyword as v2, v24, annot from keyword as k, aggView7929315931342641033 where k.id=aggView7929315931342641033.v1 and (keyword LIKE '%sequel%');
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin4394160485451940380;
select sum(v24) from res;