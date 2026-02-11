package main
import ("fmt"; "time")

func solve(p, n, target int, board []int, used []bool, count *int) {
	if p == n*n {
		d1, d2 := 0, 0
		for i := 0; i < n; i++ {
			d1 += board[i*n+i]
			d2 += board[i*n+(n-1-i)]
		}
		if d1 == target && d2 == target { *count++ }
		return
	}
	for v := 1; v <= n*n; v++ {
		if !used[v] {
			board[p] = v
			if (p+1)%n == 0 {
				s := 0
				for i := 0; i < n; i++ { s += board[p-i] }
				if s != target { continue }
			}
			if p >= n*(n-1) {
				s := 0
				for i := 0; i < n; i++ { s += board[p-i*n] }
				if s != target { continue }
			}
			used[v] = true; solve(p+1, n, target, board, used, count); used[v] = false
		}
	}
}

func main() {
	n := 3
	target := n * (n*n + 1) / 2
	board := make([]int, n*n)
	used := make([]bool, n*n+1)
	count := 0
	start := time.Now()
	solve(0, n, target, board, used, &count)
	fmt.Printf("N=%d, Count: %d, Time: %v\n", n, count, time.Since(start))
}