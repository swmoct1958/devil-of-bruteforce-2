#include <iostream>
#include <cstdint>
#include <chrono> // 時間計測用

using namespace std;

const int S = 34;
long long total_count = 0;
int board[16];
uint32_t used = 0;

void solve(int pos) {
    // 1行目逆算
    if (pos == 3) {
        int v = S - (board[0] + board[1] + board[2]);
        if (v < 1 || v > 16 || (used & (1 << v))) return;
        board[3] = v; used |= (1 << v); solve(4); used &= ~(1 << v); return;
    }
    // 2行目逆算
    if (pos == 7) {
        int v = S - (board[4] + board[5] + board[6]);
        if (v < 1 || v > 16 || (used & (1 << v))) return;
        board[7] = v; used |= (1 << v); solve(8); used &= ~(1 << v); return;
    }
    // 3行目逆算
    if (pos == 11) {
        int v = S - (board[8] + board[9] + board[10]);
        if (v < 1 || v > 16 || (used & (1 << v))) return;
        board[11] = v; used |= (1 << v); solve(12); used &= ~(1 << v); return;
    }
    // 4行目の各列を逆算して最終判定
    if (pos == 12) {
        int v12 = S - (board[0] + board[4] + board[8]);
        if (v12 < 1 || v12 > 16 || (used & (1 << v12))) return;
        int v13 = S - (board[1] + board[5] + board[9]);
        if (v13 < 1 || v13 > 16 || v13 == v12 || (used & (1 << v13))) return;
        int v14 = S - (board[2] + board[6] + board[10]);
        if (v14 < 1 || v14 > 16 || v14 == v12 || v14 == v13 || (used & (1 << v14))) return;
        int v15 = S - (board[3] + board[7] + board[11]);
        if (v15 < 1 || v15 > 16 || v15 == v12 || v15 == v13 || v15 == v14 || (used & (1 << v15))) return;

        if (v12 + v13 + v14 + v15 == S && 
            board[0] + board[5] + board[10] + v15 == S && 
            board[3] + board[6] + board[9] + v12 == S) {
            total_count++;
        }
        return;
    }

    for (int v = 1; v <= 16; ++v) {
        if (!(used & (1 << v))) {
            used |= (1 << v);
            board[pos] = v;
            solve(pos + 1);
            used &= ~(1 << v);
        }
    }
}

int main() {
    cout << "C++ n=4 最速探索開始..." << endl;
    
    // 正確な型名で計測開始
    auto start = chrono::high_resolution_clock::now();

    solve(0);

    auto end = chrono::high_resolution_clock::now();
    auto duration = chrono::duration_cast<chrono::milliseconds>(end - start).count();

    cout << "解の総数: " << total_count << " (理論値: 7040)" << endl;
    cout << "実行時間: " << duration << " ms" << endl;
    
    return 0;
}