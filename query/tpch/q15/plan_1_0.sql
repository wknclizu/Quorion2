create or replace TEMP view supplierAux83 as select s_suppkey as v1, s_name as v2, s_address as v3, s_phone as v5 from supplier;
create or replace TEMP view semiJoinView7369480434773667089 as select supplier_no as v1, total_revenue as v9 from revenue0 AS revenue0 where (total_revenue) in (select max_tr from q15_inner AS q15_inner);
create or replace TEMP view semiJoinView988990991317376109 as select distinct v1, v2, v3, v5 from supplierAux83 where (v1) in (select v1 from semiJoinView7369480434773667089);
create or replace TEMP view semiEnum7933194453655461692 as select distinct v2, v5, v1, v3, v9 from semiJoinView988990991317376109 join semiJoinView7369480434773667089 using(v1);
create or replace TEMP view semiEnum6303861689919142324 as select v1, v3, v5, v2, v9 from semiEnum7933194453655461692, q15_inner as q15_inner where q15_inner.max_tr=semiEnum7933194453655461692.v9;
create or replace TEMP view res as select distinct v1, v2, v3, v5, v9 from semiEnum6303861689919142324;
select sum(v1+v2+v3+v5+v9) from res;
