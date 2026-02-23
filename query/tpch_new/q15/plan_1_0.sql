create or replace TEMP view supplierAux86 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView2347595675557110390 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView647609841258359535 as select distinct v1, v2, v3, v5 from supplierAux86 where (v1) in (select v1 from semiJoinView2347595675557110390);
create or replace TEMP view semiEnum8931844630456491713 as select distinct v2, v5, v3, v9, v1 from semiJoinView647609841258359535 join semiJoinView2347595675557110390 using(v1);
create or replace TEMP view semiEnum3723646347072041282 as select v2, v5, v3, v9, v1 from semiEnum8931844630456491713, q15_inner as q15_inner where q15_inner.max_tr=semiEnum8931844630456491713.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum3723646347072041282;
select sum(v1+v2+v3+v5+v9) from res;
