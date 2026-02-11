import sys
import time

def dfs(n, magic, sq, used, row, col, diag, adiag, pos, count):
    if pos == n * n:
        count[0] += 1
        return

    r = pos // n
    c = pos % n
    maxv = n * n

    forced = False
    v = -1

    # 行末・列末・対角線末の強制値
    if c == n - 1:
        need = magic - row[r]
        if need < 1 or need > maxv or used[need]:
            return
        v = need
        forced = True

    elif r == n - 1:
        need = magic - col[c]
        if need < 1 or need > maxv or used[need]:
            return
        v = need
        forced = True

    elif r == c and r == n - 1:
        need = magic - diag
        if need < 1 or need > maxv or used[need]:
            return
        v = need
        forced = True

    elif r + c == n - 1 and r == n - 1:
        need = magic - adiag
        if need < 1 or need > maxv or used[need]:
            return
        v = need
        forced = True

    if forced:
        try_value(n, magic, sq, used, row, col, diag, adiag, pos, v, count)
    else:
        for x in range(1, maxv + 1):
            if not used[x]:
                try_value(n, magic, sq, used, row, col, diag, adiag, pos, x, count)


def try_value(n, magic, sq, used, row, col, diag, adiag, pos, v, count):
    r = pos // n
    c = pos % n

    if row[r] + v > magic:
        return
    if col[c] + v > magic:
        return
    if r == c and diag + v > magic:
        return
    if r + c == n - 1 and adiag + v > magic:
        return

    sq[pos] = v
    used[v] = True
    row[r] += v
    col[c] += v

    newdiag = diag + v if r == c else diag
    newadiag = adiag + v if r + c == n - 1 else adiag

    dfs(n, magic, sq, used, row, col, newdiag, newadiag, pos + 1, count)

    used[v] = False
    row[r] -= v
    col[c] -= v


def main():
    n = int(sys.argv[1]) if len(sys.argv) >= 2 else 4
    magic = n * (n * n + 1) // 2

    sq = [0] * (n * n)
    used = [False] * (n * n + 1)
    row = [0] * n
    col = [0] * n

    # 1行目固定（Rust最速版と同条件）
    for i in range(n):
        v = i + 1
        sq[i] = v
        used[v] = True
        row[0] += v
        col[i] += v

    diag = sq[0]
    adiag = sq[n - 1]

    count = [0]

    start = time.perf_counter()
    dfs(n, magic, sq, used, row, col, diag, adiag, n, count)
    elapsed = time.perf_counter() - start

    print(f"N={n} Count={count[0]} Time={elapsed:.6f} sec")


if __name__ == "__main__":
    main()
