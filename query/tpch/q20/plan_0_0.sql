create or replace TEMP view bag9282 as select partsupp.ps_partkey as v1, partsupp.ps_suppkey as v2, partsupp.ps_availqty as v3, partsupp.ps_supplycost as v4, partsupp.ps_comment as v5 from partsupp as partsupp, q20_inner1 as q20_inner1 where partsupp.ps_partkey=q20_inner1.v1_partkey;
create or replace TEMP view bag9282Aux45 as select v2, v3 from bag9282;
create or replace TEMP view minView5967264306291191780 as select v2_quantity_sum as mfR2856622700207360056 from q20_inner2;
create or replace TEMP view joinView4184401084541102844 as select distinct v2 from bag9282Aux45, minView5967264306291191780 where v3>mfR2856622700207360056;
create or replace TEMP view res as select distinct v2 from joinView4184401084541102844;
select sum(v2) from res;
