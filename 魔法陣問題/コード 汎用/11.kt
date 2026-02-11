import kotlin.system.measureTimeMillis

fun main(args: Array<String>) {
    val n = if (args.isNotEmpty()) args[0].toIntOrNull() ?: 4 else 4
    val magic = n * (n * n + 1) / 2

    val sq = IntArray(n * n)
    val used = BooleanArray(n * n + 1)
    val row = IntArray(n)
    val col = IntArray(n)

    // 1行目固定（Rust最速版と同条件）
    for (i in 0 until n) {
        val v = i + 1
        sq[i] = v
        used[v] = true
        row[0] += v
        col[i] += v
    }

    var diag = sq[0]
    var adiag = sq[n - 1]

    var count = 0L

    val time = measureTimeMillis {
        dfs(n, magic, sq, used, row, col, diag, adiag, n) { count++ }
    }

    println("N=$n Count=$count Time=${"%.6f".format(time / 1000.0)} sec")
}

fun dfs(
    n: Int, magic: Int,
    sq: IntArray, used: BooleanArray,
    row: IntArray, col: IntArray,
    diag: Int, adiag: Int,
    pos: Int,
    onCount: () -> Unit
) {
    if (pos == n * n) {
        onCount()
        return
    }

    val r = pos / n
    val c = pos % n
    val maxv = n * n

    var forced = false
    var v = -1

    // 行末・列末・対角線末の強制値
    if (c == n - 1) {
        val need = magic - row[r]
        if (need !in 1..maxv || used[need]) return
        v = need
        forced = true

    } else if (r == n - 1) {
        val need = magic - col[c]
        if (need !in 1..maxv || used[need]) return
        v = need
        forced = true

    } else if (r == c && r == n - 1) {
        val need = magic - diag
        if (need !in 1..maxv || used[need]) return
        v = need
        forced = true

    } else if (r + c == n - 1 && r == n - 1) {
        val need = magic - adiag
        if (need !in 1..maxv || used[need]) return
        v = need
        forced = true
    }

    if (forced) {
        tryValue(n, magic, sq, used, row, col, diag, adiag, pos, v, onCount)
    } else {
        for (x in 1..maxv) {
            if (!used[x]) {
                tryValue(n, magic, sq, used, row, col, diag, adiag, pos, x, onCount)
            }
        }
    }
}

fun tryValue(
    n: Int, magic: Int,
    sq: IntArray, used: BooleanArray,
    row: IntArray, col: IntArray,
    diag: Int, adiag: Int,
    pos: Int, v: Int,
    onCount: () -> Unit
) {
    val r = pos / n
    val c = pos % n

    if (row[r] + v > magic) return
    if (col[c] + v > magic) return
    if (r == c && diag + v > magic) return
    if (r + c == n - 1 && adiag + v > magic) return

    sq[pos] = v
    used[v] = true
    row[r] += v
    col[c] += v

    val newDiag = if (r == c) diag + v else diag
    val newAdiag = if (r + c == n - 1) adiag + v else adiag

    dfs(n, magic, sq, used, row, col, newDiag, newAdiag, pos + 1, onCount)

    used[v] = false
    row[r] -= v
    col[c] -= v
}
