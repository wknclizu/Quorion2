create or replace TEMP view semiUp5467236374715153110 as select l_orderkey as v1, l_shipmode as v24 from lineitem AS lineitem where (l_orderkey) in (select o_orderkey from orders AS orders) and (l_shipmode IN ('MAIL','SHIP')) and (l_receiptdate >= DATE '1993-12-31') and (l_shipdate < l_commitdate) and (l_receiptdate < DATE '1994-12-31') and (l_commitdate < l_receiptdate);
create or replace TEMP view lineitemAux59 as select v24 from semiUp5467236374715153110;
create or replace TEMP view semiDown9120537123395947004 as select v1, v24 from semiUp5467236374715153110 where (v24) in (select v24 from lineitemAux59);
create or replace TEMP view semiDown8604848152593837252 as select o_orderkey as v1, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select v1 from semiDown9120537123395947004);
create or replace TEMP view aggView2497392915993222934 as select v1, CASE WHEN (v6 IN ('1-URGENT','2-HIGH')) THEN 1 ELSE 0 END as v28, CASE WHEN (v6 NOT IN ('1-URGENT','2-HIGH')) THEN 1 ELSE 0 END as v29 from semiDown8604848152593837252;
create or replace TEMP view aggJoin2928845196056291557 as select v24, v28, v29 from semiDown9120537123395947004 join aggView2497392915993222934 using(v1);
create or replace TEMP view aggView3977859481990417233 as select v24, SUM(v28) as v28, SUM(v29) as v29, COUNT(*) as annot from aggJoin2928845196056291557 group by v24,v29,v28;
create or replace TEMP view res as select v24, SUM(v28) as v28, SUM(v29) as v29 from aggView3977859481990417233 group by v24;
select sum(v24+v28+v29) from res;
