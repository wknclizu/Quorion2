create or replace TEMP view semiUp4256570756287425040 as select o_orderkey as v10, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select l_orderkey from lineitem AS lineitem where (l_commitdate < l_receiptdate)) and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view ordersAux1 as select v6 from semiUp4256570756287425040;
create or replace TEMP view semiDown1831880746839442264 as select v10, v6 from semiUp4256570756287425040 where (v6) in (select v6 from ordersAux1);
create or replace TEMP view semiDown694240798664081836 as select l_orderkey as v10 from lineitem AS lineitem where (l_orderkey) in (select v10 from semiDown1831880746839442264) and (l_commitdate < l_receiptdate);
create or replace TEMP view aggView5793318036966187657 as select v10, COUNT(*) as annot from semiDown694240798664081836 group by v10;
create or replace TEMP view aggJoin5668336459221627658 as select v6, annot from semiDown1831880746839442264 join aggView5793318036966187657 using(v10);
create or replace TEMP view aggView3221245238268651471 as select v6, SUM(annot) as annot from aggJoin5668336459221627658 group by v6;
create or replace TEMP view res as select v6, SUM(annot) as v26 from aggView3221245238268651471 group by v6;
select sum(v6+v26) from res;
