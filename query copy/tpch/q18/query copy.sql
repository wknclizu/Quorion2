SELECT c_name, c_custkey, o_orderkey, o_orderdate, o_totalprice, SUM(l_quantity) as agg
FROM customer, orders, lineitem, 
 (select l_orderkey as v1_orderkey from lineitem l2 group by l_orderkey having sum(l_quantity) > 312) as q18_inner
WHERE o_orderkey = v1_orderkey
  AND c_custkey = o_custkey
  AND o_orderkey = l_orderkey
GROUP BY c_name, c_custkey, o_orderkey, o_orderdate, o_totalprice