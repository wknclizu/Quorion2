create or replace view aggView8808514475225602656 as select n_name as v47, n_nationkey as v37 from nation as n2;
create or replace view aggJoin8503338377088736481 as select v37, v47 from aggView8808514475225602656 where v47= 'GERMANY';
create or replace view aggView8752859015428585810 as select l_orderkey as v25, l_year as v9, l_suppkey as v1, SUM(l_extendedprice * (1 - l_discount)) as v51, COUNT(*) as annot from lineitemwithyear as lineitemwithyear where l_shipdate>=DATE '1995-01-01' and l_shipdate<=DATE '1996-12-31' group by l_orderkey,l_year,l_suppkey;
create or replace view aggView4288073702731848095 as select n_nationkey as v4, n_name as v43 from nation as n1;
create or replace view aggJoin6000208847348514460 as select v4, v43 from aggView4288073702731848095 where v43= 'FRANCE';
create or replace view semiJoinView4771355823403436077 as select c_custkey as v34, c_nationkey as v37 from customer AS customer where (c_nationkey) in (select v37 from aggJoin8503338377088736481);
create or replace view semiJoinView7445637448070817991 as select o_orderkey as v25, o_custkey as v34 from orders AS orders where (o_custkey) in (select v34 from semiJoinView4771355823403436077);
create or replace view semiJoinView7588811530237693503 as select v25, v9, v1, v51, annot from aggView8752859015428585810 where (v25) in (select v25 from semiJoinView7445637448070817991);
create or replace view semiJoinView7721072991748282511 as select s_suppkey as v1, s_nationkey as v4 from supplier AS supplier where (s_suppkey) in (select v1 from semiJoinView7588811530237693503);
create or replace view semiJoinView3453079805881143942 as select distinct v4, v43 from aggJoin6000208847348514460 where (v4) in (select v4 from semiJoinView7721072991748282511);
create or replace view semiEnum1741521260928797116 as select distinct v43, v1 from semiJoinView3453079805881143942 join semiJoinView7721072991748282511 using(v4);
create or replace view semiEnum7325740257583053348 as select distinct v25, v51, v43, v9, annot from semiEnum1741521260928797116 join semiJoinView7588811530237693503 using(v1);
create or replace view semiEnum6432078094351862122 as select distinct v43, v34, v51, v9, annot from semiEnum7325740257583053348 join semiJoinView7445637448070817991 using(v25);
create or replace view semiEnum334118978450405550 as select distinct v37, v43, v51, v9, annot from semiEnum6432078094351862122 join semiJoinView4771355823403436077 using(v34);
create or replace view semiEnum7137540933947025241 as select v43, v51, v9, annot, v47 from semiEnum334118978450405550 join aggJoin8503338377088736481 using(v37);
select v43, v47, v9, SUM(v51) as v51 from semiEnum7137540933947025241 group by v43, v47, v9;

