function solve_magic(n)
    target = div(n * (n^2 + 1), 2)
    board = zeros(Int, n * n)
    used = fill(false, n * n)
    count = 0

    function backtrack(p)
        if p > n * n
            d1, d2 = 0, 0
            for i in 1:n
                d1 += board[(i-1)*n + i]
                d2 += board[(i-1)*n + (n - i + 1)]
            end
            if d1 == target && d2 == target
                count += 1
            end
            return
        end

        for v in 1:(n*n)
            if !used[v]
                board[p] = v
                if p % n == 0
                    if sum(board[p-n+1:p]) != target; continue; end
                end
                if p > n * (n - 1)
                    if sum(board[p%n == 0 ? n : p%n : n : p]) != target; continue; end
                end
                used[v] = true
                backtrack(p + 1)
                used[v] = false
            end
        end
    end
    @time backtrack(1)
    println("N=$n, Count: $count")
end

solve_magic(3)