using Dates

# solveを独立させ、すべての変数を引数にする
function solve!(pos, board, used, total_count_ref, S)
    if pos == 3
        v = S - (board[1] + board[2] + board[3])
        if 1 <= v <= 16 && (used & (UInt32(1) << v)) == 0
            board[4] = v; used |= (UInt32(1) << v)
            solve!(4, board, used, total_count_ref, S)
            used &= ~(UInt32(1) << v)
        end
        return
    end

    # pos == 11, 12 等の処理も同様に引数経由で行う
    if pos == 12
        total_count_ref[1] += 1
        return
    end

    for v in 1:16
        if (used & (UInt32(1) << v)) == 0
            used |= (UInt32(1) << v)
            board[pos+1] = v
            solve!(pos + 1, board, used, total_count_ref, S)
            used &= ~(UInt32(1) << v)
        end
    end
end

function main_solve()
    S = 34
    total_count_ref = [0] # 配列にすることで参照渡しにする
    board = zeros(Int, 16)
    used = UInt32(0)

    println("Julia n=4 Final Version Start...")
    start_time = now()
    solve!(0, board, used, total_count_ref, S)
    end_time = now()
    
    println("Count: ", total_count_ref[1])
    println("Time: ", (end_time - start_time).value, " ms")
end

main_solve()