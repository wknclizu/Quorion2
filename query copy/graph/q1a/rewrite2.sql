create or replace TEMP view g1 as select Graph.src as v7, Graph.dst as v2, v8 from Graph, (SELECT src, COUNT(*) AS v8 FROM Graph GROUP BY src) AS c1 where Graph.src = c1.src and v8<2;
create or replace TEMP view semiJoinView9062224839730538193 as select src as v2, dst as v4 from Graph AS g2 where (src) in (select v2 from g1);
create or replace TEMP view g3 as select Graph.src as v4, Graph.dst as v6, v10 from Graph, (SELECT src, COUNT(*) AS v10 FROM Graph GROUP BY src) AS c2 where Graph.dst = c2.src;
create or replace TEMP view semiJoinView4335375713989912330 as select v4, v6, v10 from g3 where (v4) in (select v4 from semiJoinView9062224839730538193);
create or replace TEMP view semiEnum1503752060230464577 as select v4, v6, v10, v2 from semiJoinView4335375713989912330 join semiJoinView9062224839730538193 using(v4);
create or replace TEMP view semiEnum6599280966329177926 as select v6, v4, v8, v2, v7, v10 from semiEnum1503752060230464577 join g1 using(v2);
select sum(v7+v2+v4+v6+v8+v10) from semiEnum6599280966329177926;
