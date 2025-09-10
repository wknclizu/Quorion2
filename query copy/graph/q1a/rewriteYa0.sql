create or replace TEMP view g3 as select Graph.src as v4, Graph.dst as v6, v10 from Graph, (SELECT src, COUNT(*) AS v10 FROM Graph GROUP BY src) AS c2 where Graph.dst = c2.src;
create or replace TEMP view semiUp5160942682381793075 as select src as v2, dst as v4 from Graph AS g2 where (dst) in (select v4 from g3);
create or replace TEMP view g1 as select Graph.src as v7, Graph.dst as v2, v8 from Graph, (SELECT src, COUNT(*) AS v8 FROM Graph GROUP BY src) AS c1 where Graph.src = c1.src and v8<2;
create or replace TEMP view semiUp3092037487035349630 as select v2, v4 from semiUp5160942682381793075 where (v2) in (select v2 from g1);
create or replace TEMP view semiDown8839020112536842102 as select v7, v2, v8 from g1 where (v2) in (select v2 from semiUp3092037487035349630);
create or replace TEMP view semiDown6799527057852203230 as select v4, v6, v10 from g3 where (v4) in (select v4 from semiUp3092037487035349630);
create or replace TEMP view joinView354122636556184973 as select v2, v4, v7, v8 from semiUp3092037487035349630 join semiDown8839020112536842102 using(v2);
create or replace TEMP view joinView3762876236466302804 as select v2, v4, v7, v8, v6, v10 from joinView354122636556184973 join semiDown6799527057852203230 using(v4);
select sum(v7+v2+v4+v6+v8+v10) from joinView3762876236466302804;
