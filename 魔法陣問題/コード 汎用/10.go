package main

import (
    "fmt"
    "os"
    "strconv"
    "time"
)

func main() {
    n := 4
    if len(os.Args) >= 2 {
        if v, err := strconv.Atoi(os.Args[1]); err == nil {
            n = v
        }
    }

    magic := n * (n*n + 1) / 2

    sq := make([]int, n*n)
    used := make([]bool, n*n+1)
    row := make([]int, n)
    col := make([]int, n)

    // 1行目固定（Rust最速版と同条件）
    for i := 0; i < n; i++ {
        v := i + 1
        sq[i] = v
        used[v] = true
        row[0] += v
        col[i] += v
    }

    diag := sq[0]
    adiag := sq[n-1]

    count := int64(0)

    start := time.Now()
    dfs(n, magic, sq, used, row, col, diag, adiag, n, &count)
    elapsed := time.Since(start).Seconds()

    fmt.Printf("N=%d Count=%d Time=%.6f sec\n", n, count, elapsed)
}

func dfs(n, magic int, sq []int, used []bool, row, col []int,
    diag, adiag int, pos int, count *int64) {

    if pos == n*n {
        *count++
        return
    }

    r := pos / n
    c := pos % n
    maxv := n * n

    forced := false
    v := -1

    // 行末・列末・対角線末の強制値
    if c == n-1 {
        need := magic - row[r]
        if need < 1 || need > maxv || used[need] {
            return
        }
        v = need
        forced = true

    } else if r == n-1 {
        need := magic - col[c]
        if need < 1 || need > maxv || used[need] {
            return
        }
        v = need
        forced = true

    } else if r == c && r == n-1 {
        need := magic - diag
        if need < 1 || need > maxv || used[need] {
            return
        }
        v = need
        forced = true

    } else if r+c == n-1 && r == n-1 {
        need := magic - adiag
        if need < 1 || need > maxv || used[need] {
            return
        }
        v = need
        forced = true
    }

    if forced {
        tryValue(n, magic, sq, used, row, col, diag, adiag, pos, v, count)
    } else {
        for v = 1; v <= maxv; v++ {
            if !used[v] {
                tryValue(n, magic, sq, used, row, col, diag, adiag, pos, v, count)
            }
        }
    }
}

func tryValue(n, magic int, sq []int, used []bool, row, col []int,
    diag, adiag int, pos, v int, count *int64) {

    r := pos / n
    c := pos % n

    if row[r]+v > magic {
        return
    }
    if col[c]+v > magic {
        return
    }
    if r == c && diag+v > magic {
        return
    }
    if r+c == n-1 && adiag+v > magic {
        return
    }

    sq[pos] = v
    used[v] = true
    row[r] += v
    col[c] += v
    oldDiag := diag
    oldAdiag := adiag
    if r == c {
        diag += v
    }
    if r+c == n-1 {
        adiag += v
    }

    dfs(n, magic, sq, used, row, col, diag, adiag, pos+1, count)

    used[v] = false
    row[r] -= v
    col[c] -= v
    diag = oldDiag
    adiag = oldAdiag
}
