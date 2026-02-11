import kotlin.system.measureNanoTime

var N = 0
var count = 0L

fun dfs(row: Int, cols: Int, d1: Int, d2: Int) {
    if (row == N) {
        count++
        return
    }

    val mask = (1 shl N) - 1
    var avail = mask and (cols or d1 or d2).inv()

    while (avail != 0) {
        val p = avail and -avail
        avail = avail xor p
        dfs(row + 1, cols or p, (d1 or p) shl 1, (d2 or p) shr 1)
    }
}

fun main(args: Array<String>) {
    N = if (args.isNotEmpty()) args[0].toInt() else 14
    count = 0

    val time = measureNanoTime {
        dfs(0, 0, 0, 0)
    } / 1e9

    println("N=$N Count=$count Time=${"%.6f".format(time)} sec")
}
