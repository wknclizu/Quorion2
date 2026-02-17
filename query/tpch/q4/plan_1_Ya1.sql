create or replace TEMP view semiUp5801500814349701203 as select l_orderkey as v10 from lineitem AS lineitem where (l_orderkey) in (select o_orderkey from orders AS orders where (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30')) and (l_commitdate < l_receiptdate);
create or replace TEMP view semiDown1134220303940055480 as select o_orderkey as v10, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select v10 from semiUp5801500814349701203) and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view aggView60293365623039440 as select v10, v6 from semiDown1134220303940055480;
create or replace TEMP view aggJoin2706702389164747594 as select v6 from semiUp5801500814349701203 join aggView60293365623039440 using(v10);
create or replace TEMP view res as select v6, COUNT(*) as v26 from aggJoin2706702389164747594 group by v6;
select sum(v6+v26) from res;
