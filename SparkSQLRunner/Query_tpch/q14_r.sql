
create or replace TEMP view aggView1070749204180831765 as select l_partkey as v2, l_extendedprice * (1 - l_discount) as caseRes from lineitem as lineitem where l_shipdate>=DATE '1995-09-01' and l_shipdate<DATE '1995-10-01';
select ((100.0 * SUM( CASE WHEN p_type LIKE 'PROMO%' THEN caseRes ELSE 0.0 END)) / SUM(caseRes)) as v30 from part as part, aggView1070749204180831765 where part.p_partkey=aggView1070749204180831765.v2;
