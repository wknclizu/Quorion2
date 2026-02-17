create or replace TEMP view semiUp3171797993148828930 as select l_orderkey as v10 from lineitem AS lineitem where (l_orderkey) in (select o_orderkey from orders AS orders where (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30')) and (l_commitdate < l_receiptdate);
create or replace TEMP view semiDown2237141043600923968 as select o_orderkey as v10, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select v10 from semiUp3171797993148828930) and (o_orderdate >= DATE '1993-06-30') and (o_orderdate < DATE '1993-09-30');
create or replace TEMP view aggView7727767766880391718 as select v10, v6 from semiDown2237141043600923968;
create or replace TEMP view aggJoin9221177355514486948 as select v6 from semiUp3171797993148828930 join aggView7727767766880391718 using(v10);
create or replace TEMP view res as select v6, COUNT(*) as v26 from aggJoin9221177355514486948 group by v6;
select sum(v6+v26) from res;
