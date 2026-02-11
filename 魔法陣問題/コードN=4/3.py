import time

def solve_ultimate():
    S = 34
    total_count = 0
    board = [0] * 16
    used = 0

    def backtrack(pos, used):
        nonlocal total_count
        
        # --- 強力な枝切り（Pruning）セクション ---
        if pos == 4: # 1行目
            if board[0] + board[1] + board[2] + board[3] != S: return
        elif pos == 8: # 2行目
            if board[4] + board[5] + board[6] + board[7] != S: return
        elif pos == 12: # 3行目 + 縦列の一部チェック
            if board[8] + board[9] + board[10] + board[11] != S: return
            # この時点で1,2,3列目の合計がSを超えていたら即終了
            if board[0]+board[4]+board[8] >= S: return
            if board[1]+board[5]+board[9] >= S: return
            if board[2]+board[6]+board[10] >= S: return
        elif pos == 13: # 4行目の1枚目：1列目が確定
            if board[0] + board[4] + board[8] + board[12] != S: return
            # ついでに右下がり対角線のチェック
            if board[0] + board[5] + board[10] + board[15] != S and pos > 15: pass # 後で判定
        elif pos == 14: # 2列目が確定
            if board[1] + board[5] + board[9] + board[13] != S: return
        elif pos == 15: # 3列目が確定
            if board[2] + board[6] + board[10] + board[14] != S: return
        
        # 完了判定
        if pos == 16:
            if (board[12] + board[13] + board[14] + board[15] == S and # 4行目
                board[3] + board[7] + board[11] + board[15] == S and # 4列目
                board[0] + board[5] + board[10] + board[15] == S and # 対角1
                board[3] + board[6] + board[9] + board[12] == S):   # 対角2
                total_count += 1
            return

        # 探索ループ
        for v in range(1, 17):
            if not (used & (1 << v)):
                board[pos] = v
                backtrack(pos + 1, used | (1 << v))

    print("Python n=4 Ultimate Optimized Search Start...")
    start_time = time.time()
    backtrack(0, 0)
    end_time = time.time()
    
    print(f"Count: {total_count}")
    print(f"Time: {int((end_time - start_time) * 1000)} ms")

solve_ultimate()
