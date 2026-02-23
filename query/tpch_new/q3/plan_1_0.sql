create or replace TEMP view aggView6461330694804373098 as select c_custkey as v1 from customer as customer where (c_mktsegment = 'BUILDING');
create or replace TEMP view aggJoin24985345116077677 as select o_orderkey as v18, o_orderdate as v13, o_shippriority as v16 from orders as orders, aggView6461330694804373098 where orders.o_custkey=aggView6461330694804373098.v1 and (o_orderdate < DATE '1995-03-14');
create or replace TEMP view semiJoinView1756331069467713009 as select distinct l_orderkey as v18, l_extendedprice as v23, l_discount as v24, (l_extendedprice * (1 - l_discount)) as v35 from lineitem AS lineitem where (l_orderkey) in (select v18 from aggJoin24985345116077677) and (l_shipdate > DATE '1995-03-14');
create or replace TEMP view semiEnum2487243032728526624 as select v18, v35, v16, v13 from semiJoinView1756331069467713009 join aggJoin24985345116077677 using(v18);
create or replace TEMP view res as select v18, SUM(v35) as v35, v13, v16 from semiEnum2487243032728526624 group by v18, v13, v16;
select sum(v18+v35+v13+v16) from res;
