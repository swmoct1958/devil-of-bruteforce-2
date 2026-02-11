import time

def solve_magic(n):
    target = n * (n**2 + 1) // 2
    board = [0] * (n * n)
    used = [False] * (n * n + 1)
    count = 0

    def backtrack(p):
        nonlocal count
        if p == n * n:
            # 対角線の最終チェック
            if sum(board[i*n + i] for i in range(n)) == target and \
               sum(board[i*n + (n-1-i)] for i in range(n)) == target:
                count += 1
            return

        for v in range(1, n * n + 1):
            if not used[v]:
                board[p] = v
                # 行の判定（n個埋まるごとにチェック）
                if (p + 1) % n == 0:
                    if sum(board[p-n+1 : p+1]) != target: continue
                # 列の判定（最終行を埋める時にチェック）
                if p >= n * (n - 1):
                    if sum(board[p % n::n]) != target: continue
                
                used[v] = True
                backtrack(p + 1)
                used[v] = False

    start = time.time()
    backtrack(0)
    print(f"N={n}, Count: {count}, Time: {time.time() - start:.4f}s")

solve_magic(3)