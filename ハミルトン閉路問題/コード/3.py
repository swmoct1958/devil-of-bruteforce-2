# dfs_python_opt_final.py
# CPython3.xx 専用・標準ライブラリのみ
# v6 グラフ用：bitmask + iterative DFS + 次数順ソート

import sys
import time

def load_graph(path):
    G = []
    with open(path) as f:
        for line in f:
            row = line.strip().split()
            if row:
                G.append([int(x) for x in row])
    N = len(G)

    # 隣接リスト化
    adj = [[] for _ in range(N)]
    for i in range(N):
        for j in range(N):
            if G[i][j]:
                adj[i].append(j)

    # 次数順ソート（低次数優先）
    for i in range(N):
        adj[i].sort(key=lambda x: len(adj[x]))

    return N, adj


def dfs(N, adj):
    start = 0
    used0 = 1 << start
    stack = [(start, 1, used0)]
    count = 0

    while stack:
        v, depth, used = stack.pop()

        if depth == N:
            # 閉路チェック
            if start in adj[v]:
                count += 1
            continue

        for u in adj[v]:
            if not (used & (1 << u)):
                stack.append((u, depth + 1, used | (1 << u)))

    return count


def main():
    N, adj = load_graph(sys.argv[1])

    t0 = time.time()
    count = dfs(N, adj)
    t1 = time.time()

    print("N =", N)
    print("Hamiltonian cycles:", count)
    print("Time:", (t1 - t0) * 1000, "ms")


if __name__ == "__main__":
    main()
