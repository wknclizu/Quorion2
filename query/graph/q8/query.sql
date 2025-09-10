SELECT g2.src, COUNT(*), SUM(g3.dst), AVG(g4.dst), AVG(g1.src)
FROM Graph AS g1, Graph AS g2, Graph AS g3, Graph AS g4
WHERE g1.dst = g2.src AND g2.dst = g3.src AND g3.dst = g4.src
GROUP BY g2.src