create or replace TEMP view hq2_innerK as
SELECT ps_partkey as v1_partkey, MIN(ps_supplycost) as v1_supplycost_min
FROM spartsuppT, supplier, nation, region
WHERE s_suppkey = ps_suppkey
  AND s_nationkey = n_nationkey
  AND n_regionkey = r_regionkey
  AND r_name = 'EUROPE'
GROUP BY ps_partkey;
create or replace TEMP view p_new as select p_partkey, p_mfgr from part where p_size=15 and p_type LIKE '%BRASS';
create or replace TEMP view ps_new as select ps_partkey, ps_supplycost, ps_suppkey from spartsuppT where (ps_suppkey) in (select s_suppkey from supplier);
create or replace TEMP view bag as select p_partkey, p_mfgr, ps_suppkey from p_new, ps_new, hq2_innerK where p_partkey=ps_partkey and ps_supplycost=v1_supplycost_min and p_partkey = v1_partkey;
create or replace TEMP view n_new as select n_name, n_nationkey from nation where (n_regionkey) in (select r_regionkey from region where r_name= 'EUROPE');
create or replace TEMP view s_new as select s_acctbal, s_name, s_address, s_phone, s_comment, s_suppkey, n_name from supplier, n_new where s_nationkey = n_nationkey;
select distinct s_acctbal, s_name, n_name, p_partkey, p_mfgr, s_address, s_phone, s_comment from bag, s_new where s_suppkey = ps_suppkey;