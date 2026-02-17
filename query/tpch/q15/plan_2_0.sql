create or replace TEMP view supplierAux64 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView1752154411657129232 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView2018995391157648831 as select distinct v1, v2, v3, v5 from supplierAux64 where (v1) in (select v1 from semiJoinView1752154411657129232);
create or replace TEMP view semiEnum3822299412869871700 as select distinct v1, v3, v5, v9, v2 from semiJoinView2018995391157648831 join semiJoinView1752154411657129232 using(v1);
create or replace TEMP view semiEnum8109132208131671540 as select v1, v5, v3, v9, v2 from semiEnum3822299412869871700, q15_inner as q15_inner where q15_inner.max_tr=semiEnum3822299412869871700.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum8109132208131671540;
select sum(v1+v2+v3+v5+v9) from res;
