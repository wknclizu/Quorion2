create or replace TEMP view supplierAux38 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView8002949626070263396 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView2234321146448376391 as select distinct v1, v9 from semiJoinView8002949626070263396 where (v1) in (select v1 from supplierAux38);
create or replace TEMP view semiEnum1891246815406541903 as select distinct v9, v2, v1, v3, v5 from semiJoinView2234321146448376391 join supplierAux38 using(v1);
create or replace TEMP view semiEnum1757246803669600194 as select v2, v1, v9, v3, v5 from semiEnum1891246815406541903, q15_inner as q15_inner where q15_inner.max_tr=semiEnum1891246815406541903.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum1757246803669600194;
select sum(v1+v2+v3+v5+v9) from res;
