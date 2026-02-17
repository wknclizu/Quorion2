create or replace TEMP view semiUp2337009986963297617 as select l_orderkey as v10 from lineitem AS lineitem where (l_orderkey) in (select o_orderkey from orders AS orders where (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30')) and (l_commitdate < l_receiptdate);
create or replace TEMP view semiDown8487148429368805808 as select o_orderkey as v10, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select v10 from semiUp2337009986963297617) and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view aggView1558266890653364257 as select v10, v6 from semiDown8487148429368805808;
create or replace TEMP view aggJoin696016626144677979 as select v6 from semiUp2337009986963297617 join aggView1558266890653364257 using(v10);
create or replace TEMP view res as select v6, COUNT(*) as v26 from aggJoin696016626144677979 group by v6;
select sum(v6+v26) from res;
