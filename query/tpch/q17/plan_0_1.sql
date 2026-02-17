create or replace TEMP view aggView5302344288696633287 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin6820963949483625671 as select p_partkey as v17, p_brand as v20, p_container as v23, v27 from part as part, aggView5302344288696633287 where part.p_partkey=aggView5302344288696633287.v17 and (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggView5547200792823740569 as select v17, COUNT(*) as annot, v27 from aggJoin6820963949483625671 group by v17,v27;
create or replace TEMP view aggJoin8740903878137034467 as select l_quantity as v5, l_extendedprice as v6, v27, annot from lineitem as lineitem, aggView5547200792823740569 where lineitem.l_partkey=aggView5547200792823740569.v17 and l_quantity>v27;
create or replace TEMP view res as select (SUM((v6)* annot) / 7.0) as v29 from aggJoin8740903878137034467;
select sum(v29) from res;