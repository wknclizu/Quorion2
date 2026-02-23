create or replace TEMP view semiUp6530708361623977094 as select o_orderkey as v10, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select l_orderkey from lineitem AS lineitem where (l_commitdate < l_receiptdate)) and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view semiDown1421888012288604837 as select l_orderkey as v10 from lineitem AS lineitem where (l_orderkey) in (select v10 from semiUp6530708361623977094) and (l_commitdate < l_receiptdate);
create or replace TEMP view aggView8231585232097581686 as select v10, COUNT(*) as annot from semiDown1421888012288604837 group by v10;
create or replace TEMP view aggJoin3503971059096248972 as select v6, annot from semiUp6530708361623977094 join aggView8231585232097581686 using(v10);
create or replace TEMP view res as select v6, SUM(annot) as v26 from aggJoin3503971059096248972 group by v6;
select sum(v6+v26) from res;
