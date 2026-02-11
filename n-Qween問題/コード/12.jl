# nqueens.jl

function dfs(row::Int, cols::Int, d1::Int, d2::Int, N::Int, count::Base.RefValue{Int})
    if row == N
        count[] += 1
        return
    end

    mask  = (1 << N) - 1
    avail = mask & ~(cols | d1 | d2)

    while avail != 0
        p = avail & (-avail)
        avail ⊻= p
        dfs(row + 1, cols | p, (d1 | p) << 1, (d2 | p) >> 1, N, count)
    end
end

function main()
    N = length(ARGS) >= 1 ? parse(Int, ARGS[1]) : 14
    count = Ref(0)

    t = @elapsed dfs(0, 0, 0, 0, N, count)

    println("N=$N Count=$(count[]) Time=$(round(t, digits=6)) sec")
end

main()
