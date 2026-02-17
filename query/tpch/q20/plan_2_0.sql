create or replace TEMP view bag1406 as select partsupp.ps_partkey as v1, partsupp.ps_suppkey as v2, partsupp.ps_availqty as v3, partsupp.ps_supplycost as v4, partsupp.ps_comment as v5 from partsupp as partsupp, q20_inner1 as q20_inner1 where partsupp.ps_partkey=q20_inner1.v1_partkey;
create or replace TEMP view bag1406Aux57 as select v2, v3 from bag1406;
create or replace TEMP view minView4415576321238080769 as select v2_quantity_sum as mfR8829358339356453458 from q20_inner2;
create or replace TEMP view joinView5233659716726930979 as select distinct v2 from bag1406Aux57, minView4415576321238080769 where v3>mfR8829358339356453458;
create or replace TEMP view res as select distinct v2 from joinView5233659716726930979;
select sum(v2) from res;
