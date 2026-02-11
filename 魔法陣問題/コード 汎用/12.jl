function dfs(n, magic, sq, used, row, col, diag, adiag, pos, count)
    if pos == n*n + 1
        count[] += 1
        return
    end

    r = div(pos-1, n) + 1
    c = mod(pos-1, n) + 1
    maxv = n*n

    forced = false
    v = -1

    # 行末・列末・対角線末の強制値
    if c == n
        need = magic - row[r]
        if need < 1 || need > maxv || used[need]
            return
        end
        v = need
        forced = true

    elseif r == n
        need = magic - col[c]
        if need < 1 || need > maxv || used[need]
            return
        end
        v = need
        forced = true

    elseif r == c && r == n
        need = magic - diag
        if need < 1 || need > maxv || used[need]
            return
        end
        v = need
        forced = true

    elseif r + c == n + 1 && r == n
        need = magic - adiag
        if need < 1 || need > maxv || used[need]
            return
        end
        v = need
        forced = true
    end

    if forced
        try_value(n, magic, sq, used, row, col, diag, adiag, pos, v, count)
    else
        for x in 1:maxv
            if !used[x]
                try_value(n, magic, sq, used, row, col, diag, adiag, pos, x, count)
            end
        end
    end
end

function try_value(n, magic, sq, used, row, col, diag, adiag, pos, v, count)
    r = div(pos-1, n) + 1
    c = mod(pos-1, n) + 1

    if row[r] + v > magic; return; end
    if col[c] + v > magic; return; end
    if r == c && diag + v > magic; return; end
    if r + c == n + 1 && adiag + v > magic; return; end

    sq[pos] = v
    used[v] = true
    row[r] += v
    col[c] += v

    newdiag = diag
    newadiag = adiag
    if r == c; newdiag += v; end
    if r + c == n + 1; newadiag += v; end

    dfs(n, magic, sq, used, row, col, newdiag, newadiag, pos+1, count)

    used[v] = false
    row[r] -= v
    col[c] -= v
end

function main()
    n = length(ARGS) >= 1 ? parse(Int, ARGS[1]) : 4
    magic = n * (n*n + 1) ÷ 2

    sq = zeros(Int, n*n)
    used = falses(n*n + 1)
    row = zeros(Int, n)
    col = zeros(Int, n)

    # 1行目固定（Rust最速版と同条件）
    for i in 1:n
        v = i
        sq[i] = v
        used[v] = true
        row[1] += v
        col[i] += v
    end

    diag = sq[1]
    adiag = sq[n]

    count = Ref(0)

    t = @elapsed dfs(n, magic, sq, used, row, col, diag, adiag, n+1, count)

    println("N=$n Count=$(count[]) Time=$(round(t, digits=6)) sec")
end

main()
