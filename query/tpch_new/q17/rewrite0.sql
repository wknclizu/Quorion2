create or replace TEMP view aggView4934717342931095789 as select v1_partkey as v17, v1_quantity_avg as v27 from q17_inner as q17_inner;
create or replace TEMP view aggJoin2568376434481509684 as select p_partkey as v17, p_brand as v20, p_container as v23, v27 from part as part, aggView4934717342931095789 where part.p_partkey=aggView4934717342931095789.v17 and (p_brand = 'Brand#23') and (p_container = 'MED BOX');
create or replace TEMP view aggView4148457119895478239 as select v17, COUNT(*) as annot, v27 from aggJoin2568376434481509684 group by v17,v27;
create or replace TEMP view aggJoin4969353648810996217 as select l_quantity as v5, l_extendedprice as v6, v27, annot from lineitem as lineitem, aggView4148457119895478239 where lineitem.l_partkey=aggView4148457119895478239.v17 and l_quantity>v27;
create or replace TEMP view res as select (SUM((v6)* annot) / 7.0) as v29 from aggJoin4969353648810996217;
select sum(v29) from res;