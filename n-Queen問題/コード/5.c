#include <stdio.h>
#include <stdlib.h>
#include <time.h>

static long long count_sol;
static int N;

void dfs(int row, int cols, int d1, int d2) {
    if (row == N) {
        count_sol++;
        return;
    }
    int mask = (1 << N) - 1;
    int avail = mask & ~(cols | d1 | d2);

    while (avail) {
        int p = avail & -avail;   // 最下位ビット
        avail -= p;
        dfs(row + 1,
            cols | p,
            (d1 | p) << 1,
            (d2 | p) >> 1);
    }
}

int main(int argc, char** argv) {
    N = 14;
    if (argc >= 2) N = atoi(argv[1]);

    count_sol = 0;

    clock_t s = clock();
    dfs(0, 0, 0, 0);
    clock_t e = clock();

    double t = (double)(e - s) / CLOCKS_PER_SEC;

    printf("N=%d Count=%lld Time=%.6f sec\n", N, count_sol, t);
    return 0;
}
