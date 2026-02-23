create or replace TEMP view supplierAux23 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView3501644713743063694 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView5209719161817978097 as select distinct v1, v2, v3, v5 from supplierAux23 where (v1) in (select v1 from semiJoinView3501644713743063694);
create or replace TEMP view semiEnum3314926116455893391 as select distinct v1, v3, v9, v5, v2 from semiJoinView5209719161817978097 join semiJoinView3501644713743063694 using(v1);
create or replace TEMP view semiEnum1571728803493576337 as select v1, v5, v3, v9, v2 from semiEnum3314926116455893391, q15_inner as q15_inner where q15_inner.max_tr=semiEnum3314926116455893391.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum1571728803493576337;
select sum(v1+v2+v3+v5+v9) from res;
