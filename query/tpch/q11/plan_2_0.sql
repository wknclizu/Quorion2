create or replace TEMP view aggView1057210328161130137 as select n_nationkey as v9 from nation as nation where (n_name = 'GERMANY');
create or replace TEMP view aggJoin4386315648307277732 as select s_suppkey as v2 from supplier as supplier, aggView1057210328161130137 where supplier.s_nationkey=aggView1057210328161130137.v9;
create or replace TEMP view aggView4741406467449645017 as select v2, COUNT(*) as annot from aggJoin4386315648307277732 group by v2;
create or replace TEMP view aggJoin553758054607226227 as select ps_partkey as v1, ps_availqty as v3, ps_supplycost as v4, annot from partsupp as partsupp, aggView4741406467449645017 where partsupp.ps_suppkey=aggView4741406467449645017.v2;
create or replace TEMP view aggView8743282186738281272 as select v1, SUM((v4 * v3) * annot) as v18 from aggJoin553758054607226227 group by v1;
create or replace TEMP view res as select v1, SUM(v18) as v18 from aggView8743282186738281272 group by v1;
select sum(v1+v18) from res;