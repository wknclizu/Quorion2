create or replace TEMP view supplierAux43 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView7066752697585743407 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView2235739767982275368 as select distinct v1, v2, v3, v5 from supplierAux43 where (v1) in (select v1 from semiJoinView7066752697585743407);
create or replace TEMP view semiEnum2915044882979257317 as select distinct v2, v5, v3, v1, v9 from semiJoinView2235739767982275368 join semiJoinView7066752697585743407 using(v1);
create or replace TEMP view semiEnum3846483754248925868 as select v2, v5, v3, v1, v9 from semiEnum2915044882979257317, q15_inner as q15_inner where q15_inner.max_tr=semiEnum2915044882979257317.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum3846483754248925868;
select sum(v1+v2+v3+v5+v9) from res;
