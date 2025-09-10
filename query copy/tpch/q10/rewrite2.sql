create or replace view aggView4217315249324112831 as select n_nationkey as v4, n_name as v35 from nation as nation;
create or replace view aggView7745075522710300182 as select c_address as v3, c_comment as v8, c_nationkey as v4, c_acctbal as v6, c_custkey as v1, c_name as v2, c_phone as v5 from customer as customer;
create or replace view aggView4214707713661313077 as select l_orderkey as v18, SUM(l_extendedprice * (1 - l_discount)) as v39, COUNT(*) as annot from lineitem as lineitem where l_returnflag= 'R' group by l_orderkey;
create or replace view aggJoin2154850233005856459 as select o_custkey as v1, o_orderdate as v13, v39, annot from orders as orders, aggView4214707713661313077 where orders.o_orderkey=aggView4214707713661313077.v18 and o_orderdate>=DATE '1993-10-01' and o_orderdate<DATE '1994-01-01';
create or replace view aggView6003635053204238696 as select v1, SUM(v39) as v39, SUM(annot) as annot from aggJoin2154850233005856459 group by v1;
create or replace view aggJoin5130504560482261579 as select v3, v8, v4, v6, v1, v2, v5, v39, annot from aggView7745075522710300182 join aggView6003635053204238696 using(v1);
create or replace view semiJoinView8322234118044169501 as select distinct v3, v8, v4, v6, v1, v2, v5, v39, annot from aggJoin5130504560482261579 where (v4) in (select v4 from aggView4217315249324112831);
create or replace view semiEnum2524439487800156604 as select v3, v8, v35, v6, v1, v2, v39, annot, v5 from semiJoinView8322234118044169501 join aggView4217315249324112831 using(v4);
select v1, v2, SUM(v39) as v39, v6, v35, v3, v5, v8 from semiEnum2524439487800156604 group by v1, v2, v6, v5, v35, v3, v8;

