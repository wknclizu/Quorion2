#!/usr/bin/env python3
"""
Generate all possible join tree plans from a SQL query file.

Usage: python gen_plans.py <query.sql>

Reads the SQL file, extracts table aliases and join conditions,
builds a join graph, and generates plan_x.json files for every
combination of (spanning tree, root).

- No cycle:       #plans = #nodes
- One cycle:      #plans = #cycle_edges * #nodes
- Multiple cycles: prints error and exits
"""

import json
import re
import sys
import os
from collections import defaultdict


def split_respecting_parens(text, delimiter=','):
    """Split text by delimiter while respecting nested parentheses."""
    parts = []
    depth = 0
    current = []
    for char in text:
        if char == '(':
            depth += 1
            current.append(char)
        elif char == ')':
            depth -= 1
            current.append(char)
        elif char == delimiter and depth == 0:
            parts.append(''.join(current))
            current = []
        else:
            current.append(char)
    if current:
        parts.append(''.join(current))
    return parts


def parse_from_clause(from_text):
    """Parse FROM clause to extract {alias: table_name} mapping.
    Skips subquery items like (SELECT ...) AS alias."""
    aliases = {}
    items = split_respecting_parens(from_text)
    for item in items:
        item = item.strip()
        if not item:
            continue
        # Skip subquery-derived tables
        if '(' in item:
            continue
        m = re.match(r'(\w+)\s+AS\s+(\w+)', item, re.IGNORECASE)
        if m:
            table, alias = m.group(1), m.group(2)
        else:
            m = re.match(r'(\w+)\s+(\w+)', item)
            if m:
                table, alias = m.group(1), m.group(2)
            else:
                m = re.match(r'(\w+)', item)
                if m:
                    table = alias = m.group(1)
                else:
                    continue
        aliases[alias] = table
    return aliases


def resolve_column_to_alias(col_expr, aliases):
    """
    Resolve a column expression to its table alias.
    Handles both qualified (alias.col) and unqualified (col) forms.
    For unqualified columns, uses the prefix before the first '_' to
    match against alias names (e.g. s_suppkey -> supplier).
    """
    col_expr = col_expr.strip()
    if '.' in col_expr:
        alias = col_expr.split('.', 1)[0]
        if alias in aliases:
            return alias
        return None

    if '_' in col_expr:
        prefix = col_expr.split('_', 1)[0].lower()
        matches = [a for a in aliases if a.lower().startswith(prefix)]
        if len(matches) == 1:
            return matches[0]
    return None


def parse_join_conditions(where_text, aliases):
    """Extract equi-join edges between different tables from WHERE clause."""
    temp = re.sub(
        r'BETWEEN\s+(.+?)\s+AND\s+',
        lambda m: f'BETWEEN {m.group(1)} __BETWEEN_AND__ ',
        where_text, flags=re.IGNORECASE | re.DOTALL
    )

    parts = re.split(r'\bAND\b', temp, flags=re.IGNORECASE)
    parts = [p.replace('__BETWEEN_AND__', 'AND').strip() for p in parts]

    edges = set()
    for cond in parts:
        cond = cond.strip().strip('()')
        m = re.match(r'([\w.]+)\s*=\s*([\w.]+)$', cond.strip())
        if not m:
            continue
        left, right = m.group(1), m.group(2)
        a1 = resolve_column_to_alias(left, aliases)
        a2 = resolve_column_to_alias(right, aliases)
        if a1 and a2 and a1 != a2:
            edge = tuple(sorted([a1, a2]))
            edges.add(edge)

    return list(edges)


def parse_sql(sql_file):
    """Parse a SQL file and return (aliases_dict, join_edges)."""
    with open(sql_file, 'r') as f:
        sql = f.read()

    sql = re.sub(r'--.*$', '', sql, flags=re.MULTILINE)
    sql = re.sub(r'/\*.*?\*/', '', sql, flags=re.DOTALL)
    sql = sql.replace('`', '')

    from_match = re.search(
        r'\bFROM\b\s+(.*?)\s*\bWHERE\b',
        sql, re.IGNORECASE | re.DOTALL
    )
    if not from_match:
        print("Error: Cannot find FROM ... WHERE in SQL")
        sys.exit(1)

    aliases = parse_from_clause(from_match.group(1))

    where_match = re.search(
        r'\bWHERE\b\s+(.*?)(?:\bGROUP\s+BY\b|\bORDER\s+BY\b|\bHAVING\b|\bLIMIT\b|;|\Z)',
        sql, re.IGNORECASE | re.DOTALL
    )
    if not where_match:
        print("Error: Cannot find WHERE clause in SQL")
        sys.exit(1)

    edges = parse_join_conditions(where_match.group(1), aliases)
    return aliases, edges


def find_spanning_tree(nodes, edges):
    """
    Build a spanning tree with Union-Find.
    Returns (tree_edges, extra_edges_that_cause_cycles).
    """
    parent = {n: n for n in nodes}
    rank = {n: 0 for n in nodes}

    def find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    def union(x, y):
        px, py = find(x), find(y)
        if px == py:
            return False
        if rank[px] < rank[py]:
            px, py = py, px
        parent[py] = px
        if rank[px] == rank[py]:
            rank[px] += 1
        return True

    tree_edges = []
    extra_edges = []
    for u, v in edges:
        if union(u, v):
            tree_edges.append((u, v))
        else:
            extra_edges.append((u, v))

    return tree_edges, extra_edges


def find_cycle(tree_edges, extra_edge):
    """Given a spanning tree and one extra edge, find all edges on the cycle.
    The cycle = path(u->v in tree) + extra_edge(u,v)."""
    adj = defaultdict(set)
    for u, v in tree_edges:
        adj[u].add(v)
        adj[v].add(u)

    start, end = extra_edge
    parent_map = {start: None}
    visited = {start}
    queue = [start]
    while queue:
        node = queue.pop(0)
        if node == end:
            break
        for nb in adj[node]:
            if nb not in visited:
                visited.add(nb)
                parent_map[nb] = node
                queue.append(nb)

    cycle_edges = [tuple(sorted(extra_edge))]
    cur = end
    while cur != start:
        prev = parent_map[cur]
        cycle_edges.append(tuple(sorted([prev, cur])))
        cur = prev
    return cycle_edges


def is_connected(nodes, edges):
    """Check whether the given edges connect all nodes."""
    if not nodes:
        return True
    adj = defaultdict(set)
    for u, v in edges:
        adj[u].add(v)
        adj[v].add(u)
    visited = set()
    stack = [next(iter(nodes))]
    visited.add(stack[0])
    while stack:
        node = stack.pop()
        for nb in adj[node]:
            if nb not in visited:
                visited.add(nb)
                stack.append(nb)
    return len(visited) == len(nodes)


def build_rooted_tree(root, tree_edges):
    """Return a plan dict rooted at `root`."""
    adj = defaultdict(set)
    for u, v in tree_edges:
        adj[u].add(v)
        adj[v].add(u)

    visited = set()

    def dfs(node):
        visited.add(node)
        children = []
        for nb in sorted(adj[node]):
            if nb not in visited:
                children.append(dfs(nb))
        return {"relation": node, "children": children}

    return dfs(root)


def main():
    if len(sys.argv) < 2:
        print("Usage: python gen_plans.py <query.sql>")
        sys.exit(1)

    sql_file = sys.argv[1]
    if not os.path.exists(sql_file):
        print(f"Error: File not found: {sql_file}")
        sys.exit(1)

    aliases, edges = parse_sql(sql_file)
    nodes = sorted(aliases.keys())

    print(f"Tables (aliases): {nodes}")
    print(f"Join edges: {edges}")

    tree_edges, extra_edges = find_spanning_tree(nodes, edges)

    if len(extra_edges) > 1:
        print(f"Error: Multiple cycles detected ({len(extra_edges)} extra edges).")
        print(f"Cycle-causing edges: {extra_edges}")
        sys.exit(1)

    # Build all distinct spanning trees
    # Each entry: (edge_list, removed_edge_or_None)
    spanning_trees = []

    if len(extra_edges) == 0:
        print("No cycles. Join graph is a tree.")
        spanning_trees.append((tree_edges, None))
    else:
        cycle = find_cycle(tree_edges, extra_edges[0])
        print(f"One cycle detected. Cycle edges: {cycle}")
        for remove_edge in cycle:
            st = [e for e in edges if tuple(sorted(e)) != remove_edge]
            spanning_trees.append((st, remove_edge))
        print(f"{len(spanning_trees)} spanning trees by removing each cycle edge.")

    if not is_connected(nodes, tree_edges):
        print("Warning: Join graph is not fully connected. Some tables are isolated.")

    output_dir = os.path.dirname(os.path.abspath(sql_file))

    idx = 0
    for st_edges, removed in spanning_trees:
        for root in nodes:
            tree = build_rooted_tree(root, st_edges)
            output_file = os.path.join(output_dir, f"plan_{idx}.json")
            with open(output_file, 'w') as f:
                json.dump(tree, f, indent=4)
            if removed:
                print(f"Generated {output_file} (removed={removed}, root='{root}')")
            else:
                print(f"Generated {output_file} (root='{root}')")
            idx += 1

    print(f"Total: {idx} plans generated.")


if __name__ == '__main__':
    main()
