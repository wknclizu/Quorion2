create or replace TEMP view aggView8559692558915398179 as select movie_id as v12, COUNT(*) as annot from movie_info as mi where (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German')) group by movie_id;
create or replace TEMP view aggJoin3208902701351854586 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView8559692558915398179 where t.id=aggView8559692558915398179.v12 and (production_year > 2005);
create or replace TEMP view aggView2978914313025393189 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin2925926486105992602 as select movie_id as v12 from movie_keyword as mk, aggView2978914313025393189 where mk.keyword_id=aggView2978914313025393189.v1;
create or replace TEMP view aggView3009826294751049369 as select v12, MIN(v13) as v24 from aggJoin3208902701351854586 group by v12;
create or replace TEMP view aggJoin3489097599623562021 as select v24 from aggJoin2925926486105992602 join aggView3009826294751049369 using(v12);
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin3489097599623562021;
select sum(v24) from res;