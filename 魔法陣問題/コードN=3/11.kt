fun solve(p: Int, n: Int, target: Int, board: IntArray, used: BooleanArray, count: IntArray) {
    if (p == n * n) {
        var d1 = 0; var d2 = 0
        for (i in 0 until n) {
            d1 += board[i * n + i]
            d2 += board[i * n + (n - 1 - i)]
        }
        if (d1 == target && d2 == target) count[0]++
        return
    }
    for (v in 1..n * n) {
        if (!used[v]) {
            board[p] = v
            if ((p + 1) % n == 0) {
                var s = 0
                for (i in 0 until n) s += board[p - i]
                if (s != target) continue
            }
            if (p >= n * (n - 1)) {
                var s = 0
                for (i in 0 until n) s += board[p - i * n]
                if (s != target) continue
            }
            used[v] = true; solve(p + 1, n, target, board, used, count); used[v] = false
        }
    }
}

fun main() {
    val n = 3
    val target = n * (n * n + 1) / 2
    val board = IntArray(n * n)
    val used = BooleanArray(n * n + 1)
    val count = intArrayOf(0)
    val start = System.currentTimeMillis()
    solve(0, n, target, board, used, count)
    println("N=$n, Count: ${count[0]}, Time: ${(System.currentTimeMillis() - start) / 1000.0} s")
}
