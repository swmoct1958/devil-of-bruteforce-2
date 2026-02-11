import kotlin.system.measureTimeMillis

const val S = 34
var totalCount: Long = 0
val board = IntArray(16)
var used: Int = 0

fun solve(pos: Int) {
    // 各行の逆算枝切り
    when (pos) {
        3 -> {
            val v = S - (board[0] + board[1] + board[2])
            if (v in 1..16 && (used and (1 shl v)) == 0) {
                board[3] = v; used = used or (1 shl v); solve(4); used = used and (1 shl v).inv()
            }
            return
        }
        7 -> {
            val v = S - (board[4] + board[5] + board[6])
            if (v in 1..16 && (used and (1 shl v)) == 0) {
                board[7] = v; used = used or (1 shl v); solve(8); used = used and (1 shl v).inv()
            }
            return
        }
        11 -> {
            val v = S - (board[8] + board[9] + board[10])
            if (v in 1..16 && (used and (1 shl v)) == 0) {
                board[11] = v; used = used or (1 shl v); solve(12); used = used and (1 shl v).inv()
            }
            return
        }
    }

    // 最終判定（列と対角線）
    if (pos == 12) {
        val v12 = S - (board[0] + board[4] + board[8])
        if (v12 !in 1..16 || (used and (1 shl v12)) != 0) return
        val v13 = S - (board[1] + board[5] + board[9])
        if (v13 !in 1..16 || v13 == v12 || (used and (1 shl v13)) != 0) return
        val v14 = S - (board[2] + board[6] + board[10])
        if (v14 !in 1..16 || v14 == v12 || v14 == v13 || (used and (1 shl v14)) != 0) return
        val v15 = S - (board[3] + board[7] + board[11])
        if (v15 !in 1..16 || v15 == v12 || v15 == v13 || v15 == v14 || (used and (1 shl v15)) != 0) return

        if (v12 + v13 + v14 + v15 == S &&
            board[0] + board[5] + board[10] + v15 == S &&
            board[3] + board[6] + board[9] + v12 == S) {
            totalCount++
        }
        return
    }

    for (v in 1..16) {
        if ((used and (1 shl v)) == 0) {
            used = used or (1 shl v)
            board[pos] = v
            solve(pos + 1)
            used = used and (1 shl v).inv()
        }
    }
}

fun main() {
    println("Kotlin n=4 Search Start...")
    val time = measureTimeMillis {
        solve(0)
    }
    println("Count: $totalCount (7040)")
    println("Time: $time ms")
}
