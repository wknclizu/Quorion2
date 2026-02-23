create or replace TEMP view semiUp8821041040547655418 as select l_orderkey as v10 from lineitem AS lineitem where (l_orderkey) in (select o_orderkey from orders AS orders where (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30')) and (l_commitdate < l_receiptdate);
create or replace TEMP view semiDown957168123715093695 as select o_orderkey as v10, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select v10 from semiUp8821041040547655418) and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view aggView7087417523214061853 as select v10, v6 from semiDown957168123715093695;
create or replace TEMP view aggJoin5591268047466853077 as select v6 from semiUp8821041040547655418 join aggView7087417523214061853 using(v10);
create or replace TEMP view res as select v6, COUNT(*) as v26 from aggJoin5591268047466853077 group by v6;
select sum(v6+v26) from res;
