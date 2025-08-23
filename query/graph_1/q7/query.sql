SELECT g2.src, g3.dst, sum(g4.dst + g4.src) as sum1
FROM Graph AS g1, Graph AS g2, Graph AS g3, Graph AS g4, Graph AS g5,
    (SELECT src, COUNT(*) AS cnt FROM Graph GROUP BY src) AS c1,
    (SELECT src, COUNT(*) AS cnt FROM Graph GROUP BY src) AS c2,
    (SELECT dst, COUNT(*) AS cnt FROM Graph GROUP BY dst) AS c3,
    (SELECT dst, COUNT(*) AS cnt FROM Graph GROUP BY dst) AS c4
WHERE g1.dst = g2.src AND g2.dst = g3.src AND g1.src = c1.src
    AND g3.dst = c2.src AND g4.dst = g2.src AND g2.dst = g5.src 
    AND g4.src = c3.dst AND g5.dst = c4.dst
Group by g2.src, g3.dst