create or replace TEMP view aggView8517304132125134743 as select id as v1 from keyword as k where (keyword LIKE '%sequel%');
create or replace TEMP view aggJoin6343481443178629798 as select movie_id as v12 from movie_keyword as mk, aggView8517304132125134743 where mk.keyword_id=aggView8517304132125134743.v1;
create or replace TEMP view aggView4108819858940659319 as select v12, COUNT(*) as annot from aggJoin6343481443178629798 group by v12;
create or replace TEMP view aggJoin3185970669925645623 as select id as v12, title as v13, production_year as v16, annot from title as t, aggView4108819858940659319 where t.id=aggView4108819858940659319.v12 and (production_year > 2005);
create or replace TEMP view aggView8147482412858365677 as select v12, MIN(v13) as v24, SUM(annot) as annot from aggJoin3185970669925645623 group by v12;
create or replace TEMP view aggJoin868250673989274525 as select info as v7, v24, annot from movie_info as mi, aggView8147482412858365677 where mi.movie_id=aggView8147482412858365677.v12 and (info IN ('Sweden','Norway','Germany','Denmark','Swedish','Denish','Norwegian','German'));
create or replace TEMP view res as select MIN(v24) as v24 from aggJoin868250673989274525;
select sum(v24) from res;