create or replace TEMP view supplierAux35 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView1840325901744555965 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (supplier_no) in (select v1 from supplierAux35);
create or replace TEMP view semiJoinView2477698471232118550 as select distinct v1, v9 from semiJoinView1840325901744555965 where (v9) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiEnum1161765840914105388 as select distinct v9, v1 from semiJoinView2477698471232118550, q15_inner as q15_inner where q15_inner.max_tr=semiJoinView2477698471232118550.v9;
create or replace TEMP view semiEnum3442574787366151806 as select v1, v3, v9, v5, v2 from semiEnum1161765840914105388 join supplierAux35 using(v1);
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum3442574787366151806;
select sum(v1+v2+v3+v5+v9) from res;
