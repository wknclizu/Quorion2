create or replace TEMP view semiUp1644920159116927270 as select l_orderkey as v1, l_shipmode as v24 from lineitem AS lineitem where (l_orderkey) in (select o_orderkey from orders AS orders) and (l_shipmode IN ('MAIL','SHIP')) and (l_receiptdate >= DATE '1993-12-31') and (l_shipdate < l_commitdate) and (l_receiptdate < DATE '1994-12-31') and (l_commitdate < l_receiptdate);
create or replace TEMP view lineitemAux13 as select v24 from semiUp1644920159116927270;
create or replace TEMP view semiDown7411382276577383563 as select v1, v24 from semiUp1644920159116927270 where (v24) in (select v24 from lineitemAux13);
create or replace TEMP view semiDown5483989880571129839 as select o_orderkey as v1, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select v1 from semiDown7411382276577383563);
create or replace TEMP view aggView4628787699747382618 as select v1, CASE WHEN (v6 IN ('1-URGENT','2-HIGH')) THEN 1 ELSE 0 END as v28, CASE WHEN (v6 NOT IN ('1-URGENT','2-HIGH')) THEN 1 ELSE 0 END as v29 from semiDown5483989880571129839;
create or replace TEMP view aggJoin8647929960432204928 as select v24, v28, v29 from semiDown7411382276577383563 join aggView4628787699747382618 using(v1);
create or replace TEMP view aggView5756371452191193675 as select v24, SUM(v28) as v28, SUM(v29) as v29, COUNT(*) as annot from aggJoin8647929960432204928 group by v24,v29,v28;
create or replace TEMP view res as select v24, SUM(v28) as v28, SUM(v29) as v29 from aggView5756371452191193675 group by v24;
select sum(v24+v28+v29) from res;
