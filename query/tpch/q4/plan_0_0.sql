create or replace TEMP view aggView1409073238611758541 as select l_orderkey as v10, COUNT(*) as annot from lineitem as lineitem where (l_commitdate < l_receiptdate) group by l_orderkey;
create or replace TEMP view aggJoin4551005261919149238 as select o_orderdate as v5, o_orderpriority as v6, annot from orders as orders, aggView1409073238611758541 where orders.o_orderkey=aggView1409073238611758541.v10 and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view aggView1036722058618854333 as select v6, SUM(annot) as annot from aggJoin4551005261919149238 group by v6;
create or replace TEMP view res as select v6, SUM(annot) as v26 from aggView1036722058618854333 group by v6;
select sum(v6+v26) from res;