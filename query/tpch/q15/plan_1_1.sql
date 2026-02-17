create or replace TEMP view supplierAux33 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView2069782370918109924 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView5571514580427965487 as select distinct v1, v9 from semiJoinView2069782370918109924 where (v1) in (select v1 from supplierAux33);
create or replace TEMP view semiEnum2708362165537661212 as select distinct v2, v5, v1, v3, v9 from semiJoinView5571514580427965487 join supplierAux33 using(v1);
create or replace TEMP view semiEnum7600103751685067224 as select v1, v3, v5, v2, v9 from semiEnum2708362165537661212, q15_inner as q15_inner where q15_inner.max_tr=semiEnum2708362165537661212.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum7600103751685067224;
select sum(v1+v2+v3+v5+v9) from res;
