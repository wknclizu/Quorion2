create or replace view o_new as select o_orderkey, o_orderdate, o_shippriority from orders where o_custkey in (select c_custkey from customer where c_mktsegment = 'BUILDING') and o_orderdate < DATE '1995-03-15';
create or replace view l_agg as select l_orderkey, SUM(l_extendedprice * (1 - l_discount)) AS revenue from lineitem where l_shipdate > DATE '1995-03-15' group by l_orderkey;
select l_orderkey, sum(revenue) as revenue, o_orderdate, o_shippriority from o_new, l_agg where l_orderkey = o_orderkey group by l_orderkey, o_orderdate, o_shippriority;
