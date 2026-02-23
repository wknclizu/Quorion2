create or replace TEMP view aggView4565508676901327697 as select n_nationkey as v9 from nation as nation where (n_name = 'GERMANY');
create or replace TEMP view aggJoin5800648788026044328 as select s_suppkey as v2 from supplier as supplier, aggView4565508676901327697 where supplier.s_nationkey=aggView4565508676901327697.v9;
create or replace TEMP view aggView815398277024786930 as select v2, COUNT(*) as annot from aggJoin5800648788026044328 group by v2;
create or replace TEMP view aggJoin86298617451708430 as select ps_partkey as v1, ps_availqty as v3, ps_supplycost as v4, annot from partsupp as partsupp, aggView815398277024786930 where partsupp.ps_suppkey=aggView815398277024786930.v2;
create or replace TEMP view aggView841758589154620384 as select v1, SUM((v4 * v3) * annot) as v18 from aggJoin86298617451708430 group by v1;
create or replace TEMP view res as select v1, SUM(v18) as v18 from aggView841758589154620384 group by v1;
select sum(v1+v18) from res;