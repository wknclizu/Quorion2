create or replace TEMP view aggView3813618112098681562 as select l_orderkey as v18, SUM(l_extendedprice * (1 - l_discount)) as v39, COUNT(*) as annot from lineitem as lineitem where (l_returnflag = 'R') group by l_orderkey;
create or replace TEMP view aggJoin577121415106010719 as select o_custkey as v1, o_orderdate as v13, v39, annot from orders as orders, aggView3813618112098681562 where orders.o_orderkey=aggView3813618112098681562.v18 and (o_orderdate >= DATE '1993-09-30') and (o_orderdate < DATE '1993-12-31');
create or replace TEMP view aggView345919513917025291 as select v1, SUM(v39) as v39, SUM(annot) as annot from aggJoin577121415106010719 group by v1;
create or replace TEMP view aggJoin8176793105824126507 as select c_custkey as v1, c_name as v2, c_address as v3, c_nationkey as v4, c_phone as v5, c_acctbal as v6, c_comment as v8, v39, annot from customer as customer, aggView345919513917025291 where customer.c_custkey=aggView345919513917025291.v1;
create or replace TEMP view semiJoinView2072170432169980592 as select distinct n_nationkey as v4, n_name as v35 from nation AS nation where (n_nationkey) in (select v4 from aggJoin8176793105824126507);
create or replace TEMP view semiEnum929061968155618702 as select v2, annot, v3, v6, v39, v5, v35, v1, v8 from semiJoinView2072170432169980592 join aggJoin8176793105824126507 using(v4);
create or replace TEMP view res as select v1, v2, SUM(v39) as v39, v6, v35, v3, v5, v8 from semiEnum929061968155618702 group by v1, v2, v6, v5, v35, v3, v8;
select sum(v1+v2+v39+v6+v35+v3+v5+v8) from res;
