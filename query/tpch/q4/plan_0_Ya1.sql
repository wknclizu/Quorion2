create or replace TEMP view semiUp1453721782362165952 as select l_orderkey as v10 from lineitem AS lineitem where (l_orderkey) in (select o_orderkey from orders AS orders where (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30')) and (l_commitdate < l_receiptdate);
create or replace TEMP view semiDown2821625231811374074 as select o_orderkey as v10, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select v10 from semiUp1453721782362165952) and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view aggView5016643261810241245 as select v10, v6 from semiDown2821625231811374074;
create or replace TEMP view aggJoin4488627692833131296 as select v6 from semiUp1453721782362165952 join aggView5016643261810241245 using(v10);
create or replace TEMP view res as select v6, COUNT(*) as v26 from aggJoin4488627692833131296 group by v6;
select sum(v6+v26) from res;
