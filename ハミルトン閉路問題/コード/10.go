package main

import (
    "bufio"
    "fmt"
    "os"
    "strconv"
    "strings"
    "time"
)

var (
    adj     [][]int
    visited []bool
    counter uint64
    n       int
)

func dfs(v int) {
    visited[v] = true
    counter++

    for i := 0; i < n; i++ {
        if adj[v][i] == 1 && !visited[i] {
            dfs(i)
        }
    }

    visited[v] = false
}

func main() {
    if len(os.Args) < 2 {
        fmt.Println("Usage: 10 <graphfile>")
        return
    }

    filename := os.Args[1]
    file, err := os.Open(filename)
    if err != nil {
        fmt.Println("Cannot open file:", filename)
        return
    }
    defer file.Close()

    scanner := bufio.NewScanner(file)
    lines := [][]int{}

    for scanner.Scan() {
        line := scanner.Text()
        fields := strings.Fields(line)
        row := make([]int, len(fields))
        for i, f := range fields {
            v, err := strconv.Atoi(f)
            if err != nil {
                fmt.Println("Parse error")
                return
            }
            row[i] = v
        }
        lines = append(lines, row)
    }

    n = len(lines)
    adj = make([][]int, n)
    for i := 0; i < n; i++ {
        adj[i] = make([]int, n)
        copy(adj[i], lines[i])
    }
    visited = make([]bool, n)

    start := time.Now()
    dfs(0)
    elapsed := time.Since(start)
    ms := float64(elapsed.Microseconds()) / 1000.0

    fmt.Printf("file = %s\n", filename)
    fmt.Printf("N = %d\n", n)
    fmt.Printf("counter = %d\n", counter)
    fmt.Printf("time = %.4f ms\n", ms)
}
