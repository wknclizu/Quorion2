create or replace TEMP view aggView7797413184798105566 as select l_orderkey as v18, SUM(l_extendedprice * (1 - l_discount)) as v39, COUNT(*) as annot from lineitem as lineitem where (l_returnflag = 'R') group by l_orderkey;
create or replace TEMP view aggJoin8712002683082283102 as select o_custkey as v1, o_orderdate as v13, v39, annot from orders as orders, aggView7797413184798105566 where orders.o_orderkey=aggView7797413184798105566.v18 and (o_orderdate >= DATE '1993-09-30') and (o_orderdate < DATE '1993-12-31');
create or replace TEMP view aggView1908224826213966886 as select v1, SUM(v39) as v39, SUM(annot) as annot from aggJoin8712002683082283102 group by v1;
create or replace TEMP view aggJoin6487045957102931615 as select c_custkey as v1, c_name as v2, c_address as v3, c_nationkey as v4, c_phone as v5, c_acctbal as v6, c_comment as v8, v39, annot from customer as customer, aggView1908224826213966886 where customer.c_custkey=aggView1908224826213966886.v1;
create or replace TEMP view semiJoinView3043995229934112794 as select distinct n_nationkey as v4, n_name as v35 from nation AS nation where (n_nationkey) in (select v4 from aggJoin6487045957102931615);
create or replace TEMP view semiEnum5067528072514855520 as select annot, v2, v8, v35, v6, v5, v3, v39, v1 from semiJoinView3043995229934112794 join aggJoin6487045957102931615 using(v4);
create or replace TEMP view res as select v1, v2, SUM(v39) as v39, v6, v35, v3, v5, v8 from semiEnum5067528072514855520 group by v1, v2, v6, v5, v35, v3, v8;
select sum(v1+v2+v39+v6+v35+v3+v5+v8) from res;
