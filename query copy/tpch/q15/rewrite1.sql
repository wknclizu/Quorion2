create or replace TEMP view supplierAux58 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView1687993581181054585 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView3427638630852759559 as select distinct v1, v2, v3, v5 from supplierAux58 where (v1) in (select v1 from semiJoinView1687993581181054585);
create or replace TEMP view semiEnum2297694008821965863 as select distinct v9, v5, v1, v2, v3 from semiJoinView3427638630852759559 join semiJoinView1687993581181054585 using(v1);
create or replace TEMP view semiEnum7427281417288811253 as select v9, v5, v2, v1, v3 from semiEnum2297694008821965863, q15_inner as q15_inner where q15_inner.max_tr=semiEnum2297694008821965863.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum7427281417288811253;
select sum(v1+v2+v3+v5+v9) from res;
