create or replace TEMP view semiUp1180889446254414525 as select l_orderkey as v10 from lineitem AS lineitem where (l_orderkey) in (select o_orderkey from orders AS orders where (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30')) and (l_commitdate < l_receiptdate);
create or replace TEMP view semiDown4404252130864489135 as select o_orderkey as v10, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select v10 from semiUp1180889446254414525) and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view aggView3502101236747472824 as select v10, v6 from semiDown4404252130864489135;
create or replace TEMP view aggJoin5541556331005852457 as select v6 from semiUp1180889446254414525 join aggView3502101236747472824 using(v10);
create or replace TEMP view res as select v6, COUNT(*) as v26 from aggJoin5541556331005852457 group by v6;
select sum(v6+v26) from res;
