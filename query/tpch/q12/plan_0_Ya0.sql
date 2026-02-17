create or replace TEMP view semiUp4579897719209839834 as select l_orderkey as v1, l_shipmode as v24 from lineitem AS lineitem where (l_orderkey) in (select o_orderkey from orders AS orders) and (l_shipmode IN ('MAIL','SHIP')) and (l_receiptdate >= DATE '1993-12-31') and (l_shipdate < l_commitdate) and (l_receiptdate < DATE '1994-12-31') and (l_commitdate < l_receiptdate);
create or replace TEMP view lineitemAux98 as select v24 from semiUp4579897719209839834;
create or replace TEMP view semiDown8507352858524020726 as select v1, v24 from semiUp4579897719209839834 where (v24) in (select v24 from lineitemAux98);
create or replace TEMP view semiDown8764733796821820938 as select o_orderkey as v1, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select v1 from semiDown8507352858524020726);
create or replace TEMP view aggView3146138792411660640 as select v1, CASE WHEN (v6 IN ('1-URGENT','2-HIGH')) THEN 1 ELSE 0 END as v28, CASE WHEN (v6 NOT IN ('1-URGENT','2-HIGH')) THEN 1 ELSE 0 END as v29 from semiDown8764733796821820938;
create or replace TEMP view aggJoin8691664320901190112 as select v24, v28, v29 from semiDown8507352858524020726 join aggView3146138792411660640 using(v1);
create or replace TEMP view aggView4968226890750514236 as select v24, SUM(v28) as v28, SUM(v29) as v29, COUNT(*) as annot from aggJoin8691664320901190112 group by v24,v28,v29;
create or replace TEMP view res as select v24, SUM(v28) as v28, SUM(v29) as v29 from aggView4968226890750514236 group by v24;
select sum(v24+v28+v29) from res;
