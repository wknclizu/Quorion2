create or replace TEMP view aggView524848306579648803 as select n_nationkey as v9 from nation as nation where (n_name = 'GERMANY');
create or replace TEMP view aggJoin3676651980648521929 as select s_suppkey as v2 from supplier as supplier, aggView524848306579648803 where supplier.s_nationkey=aggView524848306579648803.v9;
create or replace TEMP view aggView5995687102420571391 as select v2, COUNT(*) as annot from aggJoin3676651980648521929 group by v2;
create or replace TEMP view aggJoin1555476600125556392 as select ps_partkey as v1, ps_availqty as v3, ps_supplycost as v4, annot from partsupp as partsupp, aggView5995687102420571391 where partsupp.ps_suppkey=aggView5995687102420571391.v2;
create or replace TEMP view aggView2329329740144809291 as select v1, SUM((v4 * v3) * annot) as v18 from aggJoin1555476600125556392 group by v1;
create or replace TEMP view res as select v1, SUM(v18) as v18 from aggView2329329740144809291 group by v1;
select sum(v1+v18) from res;