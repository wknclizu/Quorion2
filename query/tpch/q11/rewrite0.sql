create or replace TEMP view aggView585315129210927114 as select n_nationkey as v9 from nation as nation where (n_name = 'GERMANY');
create or replace TEMP view aggJoin9167032126022615259 as select s_suppkey as v2 from supplier as supplier, aggView585315129210927114 where supplier.s_nationkey=aggView585315129210927114.v9;
create or replace TEMP view aggView1439908445531228349 as select v2, COUNT(*) as annot from aggJoin9167032126022615259 group by v2;
create or replace TEMP view aggJoin4907661077950881051 as select ps_partkey as v1, ps_availqty as v3, ps_supplycost as v4, annot from partsupp as partsupp, aggView1439908445531228349 where partsupp.ps_suppkey=aggView1439908445531228349.v2;
create or replace TEMP view aggView5392946182062929567 as select v1, SUM((v4 * v3) * annot) as v18 from aggJoin4907661077950881051 group by v1;
create or replace TEMP view res as select v1, SUM(v18) as v18 from aggView5392946182062929567 group by v1;
select sum(v1+v18) from res;