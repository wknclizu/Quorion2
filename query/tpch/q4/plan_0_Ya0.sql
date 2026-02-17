create or replace TEMP view semiUp3052484109802815495 as select o_orderkey as v10, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select l_orderkey from lineitem AS lineitem where (l_commitdate < l_receiptdate)) and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view ordersAux7 as select v6 from semiUp3052484109802815495;
create or replace TEMP view semiDown3123695267134543503 as select v10, v6 from semiUp3052484109802815495 where (v6) in (select v6 from ordersAux7);
create or replace TEMP view semiDown1429742853127837159 as select l_orderkey as v10 from lineitem AS lineitem where (l_orderkey) in (select v10 from semiDown3123695267134543503) and (l_commitdate < l_receiptdate);
create or replace TEMP view aggView6492454024721485410 as select v10, COUNT(*) as annot from semiDown1429742853127837159 group by v10;
create or replace TEMP view aggJoin9030288078696120114 as select v6, annot from semiDown3123695267134543503 join aggView6492454024721485410 using(v10);
create or replace TEMP view aggView8259435851915821046 as select v6, SUM(annot) as annot from aggJoin9030288078696120114 group by v6;
create or replace TEMP view res as select v6, SUM(annot) as v26 from aggView8259435851915821046 group by v6;
select sum(v6+v26) from res;
