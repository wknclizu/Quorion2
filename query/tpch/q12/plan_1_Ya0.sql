create or replace TEMP view semiUp6666151227091927688 as select l_orderkey as v1, l_shipmode as v24 from lineitem AS lineitem where (l_orderkey) in (select o_orderkey from orders AS orders) and (l_shipmode IN ('MAIL','SHIP')) and (l_receiptdate >= DATE '1993-12-31') and (l_shipdate < l_commitdate) and (l_receiptdate < DATE '1994-12-31') and (l_commitdate < l_receiptdate);
create or replace TEMP view lineitemAux95 as select v24 from semiUp6666151227091927688;
create or replace TEMP view semiDown8237585188126306792 as select v1, v24 from semiUp6666151227091927688 where (v24) in (select v24 from lineitemAux95);
create or replace TEMP view semiDown6421987588579387483 as select o_orderkey as v1, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select v1 from semiDown8237585188126306792);
create or replace TEMP view aggView132966233401399137 as select v1, CASE WHEN (v6 IN ('1-URGENT','2-HIGH')) THEN 1 ELSE 0 END as v28, CASE WHEN (v6 NOT IN ('1-URGENT','2-HIGH')) THEN 1 ELSE 0 END as v29 from semiDown6421987588579387483;
create or replace TEMP view aggJoin2268159846188187117 as select v24, v28, v29 from semiDown8237585188126306792 join aggView132966233401399137 using(v1);
create or replace TEMP view aggView7806622201332464148 as select v24, SUM(v28) as v28, SUM(v29) as v29, COUNT(*) as annot from aggJoin2268159846188187117 group by v24,v29,v28;
create or replace TEMP view res as select v24, SUM(v28) as v28, SUM(v29) as v29 from aggView7806622201332464148 group by v24;
select sum(v24+v28+v29) from res;
