#include <stdio.h>
#include <time.h>

int count = 0;
int board[16];
int used[17];
const int TARGET = 34;

void solve(int idx) {
    // 1行目完成時に4マス目を計算で確定
    if (idx == 3) {
        int val = TARGET - (board[0] + board[1] + board[2]);
        if (val >= 1 && val <= 16 && !used[val]) {
            used[val] = 1; board[3] = val;
            solve(4);
            used[val] = 0;
        }
        return;
    }
    // 2行目完成時に8マス目を確定
    if (idx == 7) {
        int val = TARGET - (board[4] + board[5] + board[6]);
        if (val >= 1 && val <= 16 && !used[val]) {
            used[val] = 1; board[7] = val;
            solve(8);
            used[val] = 0;
        }
        return;
    }
    // 3行目完成時に12マス目を確定
    if (idx == 11) {
        int val = TARGET - (board[8] + board[9] + board[10]);
        if (val >= 1 && val <= 16 && !used[val]) {
            used[val] = 1; board[11] = val;
            solve(12);
            used[val] = 0;
        }
        return;
    }
    // 最終行と各列・対角線の判定
    if (idx == 15) {
        int val = TARGET - (board[12] + board[13] + board[14]);
        if (val >= 1 && val <= 16 && !used[val]) {
            board[15] = val;
            // 列のチェック
            for (int i = 0; i < 4; i++) {
                if (board[i] + board[i+4] + board[i+8] + board[i+12] != TARGET) return;
            }
            // 対角線のチェック
            if (board[0] + board[5] + board[10] + board[15] != TARGET) return;
            if (board[3] + board[6] + board[9] + board[12] != TARGET) return;
            
            count++;
        }
        return;
    }

    for (int i = 1; i <= 16; i++) {
        if (!used[i]) {
            used[i] = 1;
            board[idx] = i;
            solve(idx + 1);
            used[i] = 0;
        }
    }
}

int main() {
    clock_t start = clock();
    solve(0);
    clock_t end = clock();

    printf("実行時間: %f 秒\n", (double)(end - start) / CLOCKS_PER_SEC);
    printf("解の数: %d\n", count);
    return 0;
}

