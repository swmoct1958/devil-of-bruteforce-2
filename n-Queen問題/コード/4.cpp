#include <bits/stdc++.h>
using namespace std;

long long solve(int n) {
    long long count = 0;
    function<void(int, int, int, int)> dfs =
        [&](int row, int cols, int d1, int d2) {
            if (row == n) {
                count++;
                return;
            }
            int avail = ((1 << n) - 1) & ~(cols | d1 | d2);
            while (avail) {
                int p = avail & -avail;
                avail -= p;
                dfs(row + 1,
                    cols | p,
                    (d1 | p) << 1,
                    (d2 | p) >> 1);
            }
        };
    dfs(0, 0, 0, 0);
    return count;
}

int main(int argc, char** argv) {
    int n = 14;
    if (argc >= 2) n = atoi(argv[1]);
    auto start = chrono::high_resolution_clock::now();
    long long cnt = solve(n);
    auto end = chrono::high_resolution_clock::now();
    double t = chrono::duration<double>(end - start).count();
    printf("N=%d Count=%lld Time=%.6f sec\n", n, cnt, t);
    return 0;
}
