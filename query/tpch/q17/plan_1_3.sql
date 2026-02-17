create or replace TEMP view aggView6379593206365727683 as select l_partkey as v17, SUM(l_extendedprice) as v28, COUNT(*) as annot, l_quantity as v5 from lineitem as lineitem group by l_partkey,l_quantity;
create or replace TEMP view aggJoin7118911200723254718 as select v1_partkey as v17, v1_quantity_avg as v27, v28, v5, annot from q17_inner as q17_inner, aggView6379593206365727683 where q17_inner.v1_partkey=aggView6379593206365727683.v17 and v5>v1_quantity_avg;
create or replace TEMP view aggView7897806050864625257 as select p_partkey as v17 from part as part where (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggJoin2565955592800121893 as select v27, v28, v5, annot from aggJoin7118911200723254718 join aggView7897806050864625257 using(v17);
create or replace TEMP view res as select (SUM(v28) / 7.0) as v29 from aggJoin2565955592800121893;
select sum(v29) from res;