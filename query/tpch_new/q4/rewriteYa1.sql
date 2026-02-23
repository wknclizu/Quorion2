create or replace TEMP view semiUp4052695936775391969 as select l_orderkey as v10 from lineitem AS lineitem where (l_orderkey) in (select o_orderkey from orders AS orders where (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30')) and (l_commitdate < l_receiptdate);
create or replace TEMP view semiDown9064220980077823763 as select o_orderkey as v10, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select v10 from semiUp4052695936775391969) and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view aggView8479246026577600501 as select v10, v6 from semiDown9064220980077823763;
create or replace TEMP view aggJoin8461643395730300613 as select v6 from semiUp4052695936775391969 join aggView8479246026577600501 using(v10);
create or replace TEMP view res as select v6, COUNT(*) as v26 from aggJoin8461643395730300613 group by v6;
select sum(v6+v26) from res;
