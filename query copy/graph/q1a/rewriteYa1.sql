create or replace TEMP view g3 as select Graph.src as v4, Graph.dst as v6, v10 from Graph, (SELECT src, COUNT(*) AS v10 FROM Graph GROUP BY src) AS c2 where Graph.dst = c2.src;
create or replace TEMP view semiUp4741380821574572116 as select src as v2, dst as v4 from Graph AS g2 where (dst) in (select v4 from g3);
create or replace TEMP view g1 as select Graph.src as v7, Graph.dst as v2, v8 from Graph, (SELECT src, COUNT(*) AS v8 FROM Graph GROUP BY src) AS c1 where Graph.src = c1.src and v8<2;
create or replace TEMP view semiUp9200670548360790279 as select v7, v2, v8 from g1 where (v2) in (select v2 from semiUp4741380821574572116);
create or replace TEMP view semiDown8954558507783478533 as select v2, v4 from semiUp4741380821574572116 where (v2) in (select v2 from semiUp9200670548360790279);
create or replace TEMP view semiDown8101523025170315304 as select v4, v6, v10 from g3 where (v4) in (select v4 from semiDown8954558507783478533);
create or replace TEMP view joinView4205075384691516384 as select v2, v4, v6, v10 from semiDown8954558507783478533 join semiDown8101523025170315304 using(v4);
create or replace TEMP view joinView7577770425865165035 as select v7, v2, v8, v4, v6, v10 from semiUp9200670548360790279 join joinView4205075384691516384 using(v2);
select sum(v7+v2+v4+v6+v8+v10) from joinView7577770425865165035;
