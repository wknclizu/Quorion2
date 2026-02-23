create or replace TEMP view semiUp5471473931244893441 as select o_orderkey as v10, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select l_orderkey from lineitem AS lineitem where (l_commitdate < l_receiptdate)) and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view ordersAux81 as select v6 from semiUp5471473931244893441;
create or replace TEMP view semiDown8958974850213278670 as select v10, v6 from semiUp5471473931244893441 where (v6) in (select v6 from ordersAux81);
create or replace TEMP view semiDown1989298054212723354 as select l_orderkey as v10 from lineitem AS lineitem where (l_orderkey) in (select v10 from semiDown8958974850213278670) and (l_commitdate < l_receiptdate);
create or replace TEMP view aggView6192699855977736539 as select v10, COUNT(*) as annot from semiDown1989298054212723354 group by v10;
create or replace TEMP view aggJoin626844955350987761 as select v6, annot from semiDown8958974850213278670 join aggView6192699855977736539 using(v10);
create or replace TEMP view aggView8139998288130006398 as select v6, SUM(annot) as annot from aggJoin626844955350987761 group by v6;
create or replace TEMP view res as select v6, SUM(annot) as v26 from aggView8139998288130006398 group by v6;
select sum(v6+v26) from res;
