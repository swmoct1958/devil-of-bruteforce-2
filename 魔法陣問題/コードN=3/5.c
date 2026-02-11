#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

void solve(int p, int n, int* board, bool* used, int target, int* count) {
    if (p == n * n) {
        // 対角線の最終チェック
        int d1 = 0, d2 = 0;
        for (int i = 0; i < n; i++) {
            d1 += board[i * n + i];
            d2 += board[i * n + (n - 1 - i)];
        }
        if (d1 == target && d2 == target) (*count)++;
        return;
    }

    for (int v = 1; v <= n * n; v++) {
        if (!used[v]) {
            board[p] = v;
            // 行の枝切り
            if ((p + 1) % n == 0) {
                int s = 0;
                for (int i = 0; i < n; i++) s += board[p - i];
                if (s != target) continue;
            }
            // 列の枝切り（最後の行に達したとき）
            if (p >= n * (n - 1)) {
                int s = 0;
                for (int i = 0; i < n; i++) s += board[p - i * n];
                if (s != target) continue;
            }

            used[v] = true;
            solve(p + 1, n, board, used, target, count);
            used[v] = false;
        }
    }
}

int main() {
    int n = 3; // ここを4に変えれば4次になります
    int target = n * (n * n + 1) / 2;
    int *board = (int *)calloc(n * n, sizeof(int));
    bool *used = (bool *)calloc(n * n + 1, sizeof(bool));
    int count = 0;
    clock_t start = clock();
    solve(0, n, board, used, target, &count);
    printf("N=%d, Count: %d, Time: %.3f s\n", n, count, (double)(clock() - start) / CLOCKS_PER_SEC);
    free(board); free(used);
    return 0;
}