create or replace TEMP view supplierAux51 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView7926814440498979533 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView5803518926821996885 as select distinct v1, v2, v3, v5 from supplierAux51 where (v1) in (select v1 from semiJoinView7926814440498979533);
create or replace TEMP view semiEnum3082942132114767182 as select distinct v9, v2, v1, v5, v3 from semiJoinView5803518926821996885 join semiJoinView7926814440498979533 using(v1);
create or replace TEMP view semiEnum2561252986472472663 as select v9, v2, v1, v5, v3 from semiEnum3082942132114767182, q15_inner as q15_inner where q15_inner.max_tr=semiEnum3082942132114767182.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum2561252986472472663;
select sum(v1+v2+v3+v5+v9) from res;
