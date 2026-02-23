create or replace TEMP view supplierAux24 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView5798503388132979669 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView2452342283492003600 as select distinct v1, v2, v3, v5 from supplierAux24 where (v1) in (select v1 from semiJoinView5798503388132979669);
create or replace TEMP view semiEnum2022305410078269493 as select distinct v2, v5, v1, v3, v9 from semiJoinView2452342283492003600 join semiJoinView5798503388132979669 using(v1);
create or replace TEMP view semiEnum6720757146601960078 as select v2, v5, v1, v3, v9 from semiEnum2022305410078269493, q15_inner as q15_inner where q15_inner.max_tr=semiEnum2022305410078269493.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum6720757146601960078;
select sum(v1+v2+v3+v5+v9) from res;
