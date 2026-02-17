create or replace TEMP view supplierAux2 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView1370183648573512431 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (supplier_no) in (select v1 from supplierAux2);
create or replace TEMP view semiJoinView2853041373181137326 as select distinct v1, v9 from semiJoinView1370183648573512431 where (v9) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiEnum1259939410690477721 as select distinct v1, v9 from semiJoinView2853041373181137326, q15_inner as q15_inner where q15_inner.max_tr=semiJoinView2853041373181137326.v9;
create or replace TEMP view semiEnum3495111085888854830 as select v2, v1, v3, v9, v5 from semiEnum1259939410690477721 join supplierAux2 using(v1);
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum3495111085888854830;
select sum(v1+v2+v3+v5+v9) from res;
