create or replace TEMP view aggView6041271458328146917 as select l_orderkey as v18, SUM(l_extendedprice * (1 - l_discount)) as v35, COUNT(*) as annot from lineitem as lineitem where (l_shipdate > DATE '1995-03-14') group by l_orderkey;
create or replace TEMP view aggJoin1621358236456403501 as select o_orderkey as v18, o_custkey as v1, o_orderdate as v13, o_shippriority as v16, v35, annot from orders as orders, aggView6041271458328146917 where orders.o_orderkey=aggView6041271458328146917.v18 and (o_orderdate < DATE '1995-03-14');
create or replace TEMP view semiJoinView3223014007891604554 as select distinct c_custkey as v1 from customer AS customer where (c_custkey) in (select v1 from aggJoin1621358236456403501) and (c_mktsegment = 'BUILDING');
create or replace TEMP view semiEnum9022436022099862352 as select v13, annot, v35, v18, v16 from semiJoinView3223014007891604554 join aggJoin1621358236456403501 using(v1);
create or replace TEMP view res as select v18, SUM(v35) as v35, v13, v16 from semiEnum9022436022099862352 group by v18, v13, v16;
select sum(v18+v35+v13+v16) from res;
