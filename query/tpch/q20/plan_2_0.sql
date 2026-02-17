create or replace TEMP view bag9310 as select partsupp.ps_partkey as v1, partsupp.ps_suppkey as v2, partsupp.ps_availqty as v3, partsupp.ps_supplycost as v4, partsupp.ps_comment as v5 from partsupp as partsupp, q20_inner1 as q20_inner1 where partsupp.ps_partkey=q20_inner1.v1_partkey;
create or replace TEMP view bag9310Aux65 as select v2, v3 from bag9310;
create or replace TEMP view minView2321799910407188438 as select v2_quantity_sum as mfR7142670422543382290 from q20_inner2;
create or replace TEMP view joinView1842930171797053655 as select distinct v2 from bag9310Aux65, minView2321799910407188438 where v3>mfR7142670422543382290;
create or replace TEMP view res as select distinct v2 from joinView1842930171797053655;
select sum(v2) from res;
