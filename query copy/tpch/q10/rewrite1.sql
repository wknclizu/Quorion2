create or replace view aggView4840079136246107690 as select c_address as v3, c_comment as v8, c_nationkey as v4, c_acctbal as v6, c_custkey as v1, c_name as v2, c_phone as v5 from customer as customer;
create or replace view aggView3416599888015032352 as select n_nationkey as v4, n_name as v35 from nation as nation;
create or replace view aggView8175262441514664766 as select l_orderkey as v18, SUM(l_extendedprice * (1 - l_discount)) as v39, COUNT(*) as annot from lineitem as lineitem where l_returnflag= 'R' group by l_orderkey;
create or replace view aggJoin8243004025788744492 as select o_custkey as v1, o_orderdate as v13, v39, annot from orders as orders, aggView8175262441514664766 where orders.o_orderkey=aggView8175262441514664766.v18 and o_orderdate>=DATE '1993-10-01' and o_orderdate<DATE '1994-01-01';
create or replace view aggView1539735670091466488 as select v1, SUM(v39) as v39, SUM(annot) as annot from aggJoin8243004025788744492 group by v1;
create or replace view aggJoin3501110461956285943 as select v3, v8, v4, v6, v1, v2, v5, v39, annot from aggView4840079136246107690 join aggView1539735670091466488 using(v1);
create or replace view semiJoinView1453509704935606156 as select distinct v4, v35 from aggView3416599888015032352 where (v4) in (select v4 from aggJoin3501110461956285943);
create or replace view semiEnum8664842692820232778 as select v3, v8, v35, v6, v1, v2, v39, annot, v5 from semiJoinView1453509704935606156 join aggJoin3501110461956285943 using(v4);
select v1, v2, SUM(v39) as v39, v6, v35, v3, v5, v8 from semiEnum8664842692820232778 group by v1, v2, v6, v5, v35, v3, v8;

