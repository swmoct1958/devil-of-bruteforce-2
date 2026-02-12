# nqueens.py
import sys
import time

def dfs(row, cols, d1, d2, N):
    if row == N:
        return 1

    mask = (1 << N) - 1
    avail = mask & ~(cols | d1 | d2)

    total = 0
    while avail:
        p = avail & -avail
        avail ^= p
        total += dfs(row + 1,
                     cols | p,
                     (d1 | p) << 1,
                     (d2 | p) >> 1,
                     N)
    return total

def main():
    if len(sys.argv) >= 2:
        N = int(sys.argv[1])
    else:
        N = 14

    start = time.perf_counter()
    count = dfs(0, 0, 0, 0, N)
    elapsed = time.perf_counter() - start

    print(f"N={N} Count={count} Time={elapsed:.6f} sec")

if __name__ == "__main__":
    main()
