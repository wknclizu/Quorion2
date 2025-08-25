SELECT g2.src, g4.dst, sum(g1.src) as sum1
FROM Graph AS g1, Graph AS g2, Graph AS g3, Graph AS g4
WHERE g1.dst = g2.src AND g2.dst = g3.src AND g3.dst = g4.src AND g1.dst < g3.src
GROUP BY g2.src, g4.dst