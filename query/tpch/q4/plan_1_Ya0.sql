create or replace TEMP view semiUp8444344330509264957 as select o_orderkey as v10, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select l_orderkey from lineitem AS lineitem where (l_commitdate < l_receiptdate)) and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view ordersAux34 as select v6 from semiUp8444344330509264957;
create or replace TEMP view semiDown4499980206619983613 as select v10, v6 from semiUp8444344330509264957 where (v6) in (select v6 from ordersAux34);
create or replace TEMP view semiDown6607885936913700912 as select l_orderkey as v10 from lineitem AS lineitem where (l_orderkey) in (select v10 from semiDown4499980206619983613) and (l_commitdate < l_receiptdate);
create or replace TEMP view aggView5643558210214595076 as select v10, COUNT(*) as annot from semiDown6607885936913700912 group by v10;
create or replace TEMP view aggJoin7966337928465757921 as select v6, annot from semiDown4499980206619983613 join aggView5643558210214595076 using(v10);
create or replace TEMP view aggView3421567570031845272 as select v6, SUM(annot) as annot from aggJoin7966337928465757921 group by v6;
create or replace TEMP view res as select v6, SUM(annot) as v26 from aggView3421567570031845272 group by v6;
select sum(v6+v26) from res;
