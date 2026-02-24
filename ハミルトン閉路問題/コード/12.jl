using Printf

function dfs(v, adj, visited, n, counter)
    @inbounds begin
        visited[v] = true
        counter += 1

        for i in 1:n
            if adj[v, i] == 1 && !visited[i]
                counter = dfs(i, adj, visited, n, counter)
            end
        end

        visited[v] = false
    end

    return counter
end

function main(filename)
    lines = readlines(filename)
    n = length(lines)

    adj = Array{Int8}(undef, n, n)
    visited = falses(n)

    for i in 1:n
        row = split(lines[i])
        for j in 1:n
            adj[i, j] = parse(Int8, row[j])
        end
    end

    start = time()
    counter = dfs(1, adj, visited, n, 0)
    elapsed = (time() - start) * 1000

    println("file = $filename")
    println("N = $n")
    println("counter = $counter")
    @printf("time = %.4f ms\n", elapsed)
end
