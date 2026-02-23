create or replace TEMP view aggView6190522620968241221 as select n_nationkey as v9 from nation as nation where (n_name = 'GERMANY');
create or replace TEMP view aggJoin1396183667161645063 as select s_suppkey as v2 from supplier as supplier, aggView6190522620968241221 where supplier.s_nationkey=aggView6190522620968241221.v9;
create or replace TEMP view aggView5517510545877188967 as select v2, COUNT(*) as annot from aggJoin1396183667161645063 group by v2;
create or replace TEMP view aggJoin8724281525256484991 as select ps_partkey as v1, ps_availqty as v3, ps_supplycost as v4, annot from partsupp as partsupp, aggView5517510545877188967 where partsupp.ps_suppkey=aggView5517510545877188967.v2;
create or replace TEMP view aggView1948742978532974614 as select v1, SUM((v4 * v3) * annot) as v18 from aggJoin8724281525256484991 group by v1;
create or replace TEMP view res as select v1, SUM(v18) as v18 from aggView1948742978532974614 group by v1;
select sum(v1+v18) from res;