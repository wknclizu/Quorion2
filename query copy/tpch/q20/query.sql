SELECT distinct ps_suppkey
FROM partsupp, q20_inner1, q20_inner2
WHERE ps_partkey = v1_partkey
  AND ps_availqty > v2_quantity_sum