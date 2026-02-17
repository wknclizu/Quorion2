create or replace TEMP view semiUp6169186905686029929 as select l_orderkey as v1, l_shipmode as v24 from lineitem AS lineitem where (l_orderkey) in (select o_orderkey from orders AS orders) and (l_shipmode IN ('MAIL','SHIP')) and (l_receiptdate >= DATE '1993-12-31') and (l_shipdate < l_commitdate) and (l_receiptdate < DATE '1994-12-31') and (l_commitdate < l_receiptdate);
create or replace TEMP view lineitemAux98 as select v24 from semiUp6169186905686029929;
create or replace TEMP view semiDown7538112111180056857 as select v1, v24 from semiUp6169186905686029929 where (v24) in (select v24 from lineitemAux98);
create or replace TEMP view semiDown2744329150523082431 as select o_orderkey as v1, o_orderpriority as v6 from orders AS orders where (o_orderkey) in (select v1 from semiDown7538112111180056857);
create or replace TEMP view aggView8136512757513005991 as select v1, CASE WHEN (v6 IN ('1-URGENT','2-HIGH')) THEN 1 ELSE 0 END as v28, CASE WHEN (v6 NOT IN ('1-URGENT','2-HIGH')) THEN 1 ELSE 0 END as v29 from semiDown2744329150523082431;
create or replace TEMP view aggJoin4060341656651531742 as select v24, v28, v29 from semiDown7538112111180056857 join aggView8136512757513005991 using(v1);
create or replace TEMP view aggView7252337784406722255 as select v24, SUM(v28) as v28, SUM(v29) as v29, COUNT(*) as annot from aggJoin4060341656651531742 group by v24,v29,v28;
create or replace TEMP view res as select v24, SUM(v28) as v28, SUM(v29) as v29 from aggView7252337784406722255 group by v24;
select sum(v24+v28+v29) from res;
