create or replace TEMP view aggView1820322496372080313 as select c_custkey as v1 from customer as customer where (c_mktsegment = 'BUILDING');
create or replace TEMP view aggJoin4253743419602935844 as select o_orderkey as v18, o_orderdate as v13, o_shippriority as v16 from orders as orders, aggView1820322496372080313 where orders.o_custkey=aggView1820322496372080313.v1 and (o_orderdate < DATE '1995-03-14');
create or replace TEMP view semiJoinView1788890078346309104 as select distinct l_orderkey as v18, l_extendedprice as v23, l_discount as v24, (l_extendedprice * (1 - l_discount)) as v35 from lineitem AS lineitem where (l_orderkey) in (select v18 from aggJoin4253743419602935844) and (l_shipdate > DATE '1995-03-14');
create or replace TEMP view semiEnum4063335882784554302 as select v18, v16, v35, v13 from semiJoinView1788890078346309104 join aggJoin4253743419602935844 using(v18);
create or replace TEMP view res as select v18, SUM(v35) as v35, v13, v16 from semiEnum4063335882784554302 group by v18, v13, v16;
select sum(v18+v35+v13+v16) from res;
