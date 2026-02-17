create or replace TEMP view aggView471427071600798654 as select n_nationkey as v9 from nation as nation where (n_name = 'GERMANY');
create or replace TEMP view aggJoin6478852698942183475 as select s_suppkey as v2 from supplier as supplier, aggView471427071600798654 where supplier.s_nationkey=aggView471427071600798654.v9;
create or replace TEMP view aggView4720941615584044110 as select v2, COUNT(*) as annot from aggJoin6478852698942183475 group by v2;
create or replace TEMP view aggJoin3493058261583915628 as select ps_partkey as v1, ps_availqty as v3, ps_supplycost as v4, annot from partsupp as partsupp, aggView4720941615584044110 where partsupp.ps_suppkey=aggView4720941615584044110.v2;
create or replace TEMP view aggView941644770933743474 as select v1, SUM((v4 * v3) * annot) as v18 from aggJoin3493058261583915628 group by v1;
create or replace TEMP view res as select v1, SUM(v18) as v18 from aggView941644770933743474 group by v1;
select sum(v1+v18) from res;