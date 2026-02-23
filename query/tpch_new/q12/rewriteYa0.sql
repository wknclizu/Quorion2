create or replace TEMP view semiUp1662008072637902586 as select l_orderkey as v1, l_shipmode as v24 from lineitem AS lineitem where (l_orderkey) in (select o_orderkey from orders AS orders) and (l_shipmode IN ('MAIL','SHIP')) and (l_receiptdate >= DATE '1993-12-31') and (l_shipdate < l_commitdate) and (l_receiptdate < DATE '1994-12-31') and (l_commitdate < l_receiptdate);
create or replace TEMP view lineitemAux24 as select v24 from semiUp1662008072637902586;
create or replace TEMP view semiDown6320453594017499482 as select v1, v24 from semiUp1662008072637902586 where (v24) in (select v24 from lineitemAux24);
create or replace TEMP view semiDown2606845948879065094 as select o_orderkey as v1, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select v1 from semiDown6320453594017499482);
create or replace TEMP view aggView8436205280952818402 as select v1, CASE WHEN (v6 IN ('1-URGENT','2-HIGH')) THEN 1 ELSE 0 END as v28, CASE WHEN (v6 NOT IN ('1-URGENT','2-HIGH')) THEN 1 ELSE 0 END as v29 from semiDown2606845948879065094;
create or replace TEMP view aggJoin2717283709404187104 as select v24, v28, v29 from semiDown6320453594017499482 join aggView8436205280952818402 using(v1);
create or replace TEMP view aggView643464845754948016 as select v24, SUM(v28) as v28, SUM(v29) as v29, COUNT(*) as annot from aggJoin2717283709404187104 group by v24,v29,v28;
create or replace TEMP view res as select v24, SUM(v28) as v28, SUM(v29) as v29 from aggView643464845754948016 group by v24;
select sum(v24+v28+v29) from res;
