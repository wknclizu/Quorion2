create or replace view semiUp8692271282052163214 as select s_suppkey as v2, s_nationkey as v9 from supplier AS supplier where (s_nationkey) in (select n_nationkey from nation AS nation where n_name= 'GERMANY');
create or replace view semiUp3834313871176854411 as select ps_partkey as v1, ps_suppkey as v2, ps_availqty as v3, ps_supplycost as v4 from partsupp AS partsupp where (ps_suppkey) in (select v2 from semiUp8692271282052163214);
create or replace view partsuppAux56 as select v1 from semiUp3834313871176854411;
create or replace view semiDown4156860166275524527 as select v1, v2, v3, v4 from semiUp3834313871176854411 where (v1) in (select v1 from partsuppAux56);
create or replace view semiDown6658033603295035673 as select v2, v9 from semiUp8692271282052163214 where (v2) in (select v2 from semiDown4156860166275524527);
create or replace view semiDown1774005049104152567 as select n_nationkey as v9 from nation AS nation where (n_nationkey) in (select v9 from semiDown6658033603295035673) and n_name= 'GERMANY';
create or replace view aggView6308382845884965388 as select v9 from semiDown1774005049104152567;
create or replace view aggJoin2249342451412895342 as select v2 from semiDown6658033603295035673 join aggView6308382845884965388 using(v9);
create or replace view aggView8586691429573905440 as select v2, COUNT(*) as annot from aggJoin2249342451412895342 group by v2;
create or replace view aggJoin2611954156292643662 as select v1, v3, v4, annot from semiDown4156860166275524527 join aggView8586691429573905440 using(v2);
create or replace view aggView9047855300272988371 as select v1, SUM((v4 * v3) * annot) as v18, SUM(annot) as annot from aggJoin2611954156292643662 group by v1;
select v1, v18 from aggView9047855300272988371;

