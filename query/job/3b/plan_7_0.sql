create or replace TEMP view aggView7198297959331252617 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin20022843842185559 as select movie_id as v12 from movie_keyword as mk, aggView7198297959331252617 where mk.keyword_id=aggView7198297959331252617.v1;
create or replace TEMP view aggView8095840997107598806 as select v12, COUNT(*) as annot from aggJoin20022843842185559 group by v12;
create or replace TEMP view aggJoin9177336026373788105 as select movie_id as v12, info as v7, annot from movie_info as mi, aggView8095840997107598806 where mi.movie_id=aggView8095840997107598806.v12 and (info = 'Bulgaria');
create or replace TEMP view aggView2776016503019716062 as select v12, SUM(annot) as annot from aggJoin9177336026373788105 group by v12;
create or replace TEMP view aggJoin1946533525186707859 as select title as v13, production_year as v16, annot from title as t, aggView2776016503019716062 where t.id=aggView2776016503019716062.v12 and (production_year > 2010);
create or replace TEMP view res as select MIN(v13) as v24 from aggJoin1946533525186707859;
select sum(v24) from res;