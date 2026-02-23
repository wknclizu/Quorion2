create or replace TEMP view bag1560 as select partsupp.ps_partkey as v1, partsupp.ps_suppkey as v2, partsupp.ps_availqty as v3, partsupp.ps_supplycost as v4, partsupp.ps_comment as v5 from partsupp as partsupp, q20_inner1 as q20_inner1 where partsupp.ps_partkey=q20_inner1.v1_partkey;
create or replace TEMP view bag1560Aux28 as select v2, v3 from bag1560;
create or replace TEMP view minView9193394433064994210 as select v2_quantity_sum as mfR5649822979418547407 from q20_inner2;
create or replace TEMP view joinView6568504141786881439 as select distinct v2 from bag1560Aux28, minView9193394433064994210 where v3>mfR5649822979418547407;
create or replace TEMP view res as select distinct v2 from joinView6568504141786881439;
select sum(v2) from res;
