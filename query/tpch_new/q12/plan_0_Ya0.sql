create or replace TEMP view semiUp7674196095775672084 as select l_orderkey as v1, l_shipmode as v24 from lineitem AS lineitem where (l_orderkey) in (select o_orderkey from orders AS orders) and (l_shipmode IN ('MAIL','SHIP')) and (l_receiptdate >= DATE '1993-12-31') and (l_shipdate < l_commitdate) and (l_receiptdate < DATE '1994-12-31') and (l_commitdate < l_receiptdate);
create or replace TEMP view semiDown7833962832677813036 as select o_orderkey as v1, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select v1 from semiUp7674196095775672084);
create or replace TEMP view aggView2151017621113873726 as select v1, CASE WHEN (v6 IN ('1-URGENT','2-HIGH')) THEN 1 ELSE 0 END as v28, CASE WHEN (v6 NOT IN ('1-URGENT','2-HIGH')) THEN 1 ELSE 0 END as v29 from semiDown7833962832677813036;
create or replace TEMP view aggJoin4664053350168520816 as select v24, v28, v29 from semiUp7674196095775672084 join aggView2151017621113873726 using(v1);
create or replace TEMP view res as select v24, SUM(v28) as v28, SUM(v29) as v29 from aggJoin4664053350168520816 group by v24;
select sum(v24+v28+v29) from res;
