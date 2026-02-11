#include <stdio.h>
#include <stdint.h>
#include <time.h>

#define S 34

long long total_count = 0;
int board[16];
uint32_t used = 0;

void solve(int pos) {
    if (pos == 3) {
        int v = S - (board[0] + board[1] + board[2]);
        if (v < 1 || v > 16 || (used & (1 << v))) return;
        board[3] = v; used |= (1 << v); solve(4); used &= ~(1 << v); return;
    }
    if (pos == 7) {
        int v = S - (board[4] + board[5] + board[6]);
        if (v < 1 || v > 16 || (used & (1 << v))) return;
        board[7] = v; used |= (1 << v); solve(8); used &= ~(1 << v); return;
    }
    if (pos == 11) {
        int v = S - (board[8] + board[9] + board[10]);
        if (v < 1 || v > 16 || (used & (1 << v))) return;
        board[11] = v; used |= (1 << v); solve(12); used &= ~(1 << v); return;
    }
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
            used |= (1 << v); board[pos] = v;
            solve(pos + 1);
            used &= ~(1 << v);
        }
    }
}

int main() {
    printf("C Language n=4 Independent Fast Search...\n");
    clock_t start = clock(); 
    solve(0);
    clock_t end = clock();
    double duration = (double)(end - start) * 1000.0 / CLOCKS_PER_SEC;

    printf("Count: %lld (7040)\n", total_count);
    printf("Time: %.2f ms\n", duration);
    return 0;
}