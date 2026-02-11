package main

import (
	"fmt"
	"time"
)

const S = 34

var (
	totalCount int64
	board      [16]int
	used       uint32
)

func solve(pos int) {
	// 各行が埋まるたびに逆算して枝切り
	if pos == 3 {
		v := S - (board[0] + board[1] + board[2])
		if v >= 1 && v <= 16 && (used&(1<<v)) == 0 {
			board[3] = v; used |= (1 << v); solve(4); used &= ^(1 << uint(v))
		}
		return
	}
	if pos == 7 {
		v := S - (board[4] + board[5] + board[6])
		if v >= 1 && v <= 16 && (used&(1<<v)) == 0 {
			board[7] = v; used |= (1 << v); solve(8); used &= ^(1 << uint(v))
		}
		return
	}
	if pos == 11 {
		v := S - (board[8] + board[9] + board[10])
		if v >= 1 && v <= 16 && (used&(1<<v)) == 0 {
			board[11] = v; used |= (1 << v); solve(12); used &= ^(1 << uint(v))
		}
		return
	}

	// 最終判定（列と対角線）
	if pos == 12 {
		v12 := S - (board[0] + board[4] + board[8])
		if v12 < 1 || v12 > 16 || (used&(1<<uint(v12))) != 0 { return }
		v13 := S - (board[1] + board[5] + board[9])
		if v13 < 1 || v13 > 16 || v13 == v12 || (used&(1<<uint(v13))) != 0 { return }
		v14 := S - (board[2] + board[6] + board[10])
		if v14 < 1 || v14 > 16 || v14 == v12 || v14 == v13 || (used&(1<<uint(v14))) != 0 { return }
		v15 := S - (board[3] + board[7] + board[11])
		if v15 < 1 || v15 > 16 || v15 == v12 || v15 == v13 || v15 == v14 || (used&(1<<uint(v15))) != 0 { return }

		if v12+v13+v14+v15 == S &&
			board[0]+board[5]+board[10]+v15 == S &&
			board[3]+board[6]+board[9]+v12 == S {
			totalCount++
		}
		return
	}

	for v := 1; v <= 16; v++ {
		if (used & (1 << uint(v))) == 0 {
			used |= (1 << uint(v))
			board[pos] = v
			solve(pos + 1)
			used &= ^(1 << uint(v))
		}
	}
}

func main() {
	fmt.Println("Go n=4 Search Start...")
	start := time.Now()

	solve(0)

	duration := time.Since(start)
	fmt.Printf("Count: %d (7040)\n", totalCount)
	fmt.Printf("Time: %v\n", duration)
}
