import java.io.File
import kotlin.system.measureNanoTime

var adj = Array(0) { IntArray(0) }
var visited = BooleanArray(0)
var counter = 0L
var n = 0

fun dfs(v: Int) {
    visited[v] = true
    counter++

    for (i in 0 until n) {
        if (adj[v][i] == 1 && !visited[i]) {
            dfs(i)
        }
    }

    visited[v] = false
}

fun main(args: Array<String>) {
    if (args.isEmpty()) {
        println("Usage: 11 <graphfile>")
        return
    }

    val filename = args[0]
    val lines = File(filename).readLines()

    n = lines.size
    adj = Array(n) { IntArray(n) }
    visited = BooleanArray(n)

    for (i in 0 until n) {
        val row = lines[i].trim().split(" ")
        for (j in 0 until n) {
            adj[i][j] = row[j].toInt()
        }
    }

    counter = 0L
    for (i in 0 until n) visited[i] = false

    val ns = measureNanoTime {
        dfs(0)
    }

    val ms = ns / 1_000_000.0

    println("file = $filename")
    println("N = $n")
    println("counter = $counter")
    println("time = %.4f ms".format(ms))
}
