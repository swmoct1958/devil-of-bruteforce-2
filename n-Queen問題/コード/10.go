package main

import (
    "fmt"
    "os"
    "strconv"
    "time"
)

var (
    N     int
    count uint64
)

func dfs(row int, cols, d1, d2 uint32) {
    if row == N {
        count++
        return
    }

    mask := uint32((1 << N) - 1)
    avail := mask & ^(cols | d1 | d2)

    for avail != 0 {
        p := avail & -avail
        avail ^= p
        dfs(row+1, cols|p, (d1|p)<<1, (d2|p)>>1)
    }
}

func main() {
    if len(os.Args) >= 2 {
        N, _ = strconv.Atoi(os.Args[1])
    } else {
        N = 14
    }

    count = 0

    start := time.Now()
    dfs(0, 0, 0, 0)
    elapsed := time.Since(start).Seconds()

    fmt.Printf("N=%d Count=%d Time=%.6f sec\n", N, count, elapsed)
}
