#include <bits/stdc++.h>
using namespace std;

int N, M, MAGIC_SUM;

vector<int> grid;
vector<bool> used;

vector<int> row_sum, col_sum;
vector<int> row_left, col_left;

int diag1_sum = 0, diag2_sum = 0;
int diag1_left = 0, diag2_left = 0;

int min_unused = 0, max_unused = 0;

long long solutions = 0;

// 部分和の実現可能性チェック
inline bool feasible(int sum, int left_cells) {
    if (left_cells == 0) return sum == MAGIC_SUM;
    int min_possible = sum + min_unused * left_cells;
    int max_possible = sum + max_unused * left_cells;
    return (min_possible <= MAGIC_SUM && MAGIC_SUM <= max_possible);
}

void dfs(int pos) {
    if (pos == M) {
        if (diag1_sum == MAGIC_SUM && diag2_sum == MAGIC_SUM)
            solutions++;
        return;
    }

    int r = pos / N;
    int c = pos % N;

    for (int v = 1; v <= M; ++v) {
        if (used[v]) continue;

        // 値を置く
        grid[pos] = v;
        used[v] = true;

        int old_row = row_sum[r];
        int old_col = col_sum[c];
        int old_d1 = diag1_sum;
        int old_d2 = diag2_sum;
        int old_min = min_unused;
        int old_max = max_unused;

        row_sum[r] += v;
        col_sum[c] += v;
        row_left[r]--;
        col_left[c]--;

        bool on_d1 = (r == c);
        bool on_d2 = (r + c == N - 1);

        if (on_d1) { diag1_sum += v; diag1_left--; }
        if (on_d2) { diag2_sum += v; diag2_left--; }

        // min_unused / max_unused の更新
        if (v == min_unused || v == max_unused) {
            min_unused = M + 1;
            max_unused = 0;
            for (int k = 1; k <= M; ++k) {
                if (!used[k]) {
                    min_unused = min(min_unused, k);
                    max_unused = max(max_unused, k);
                }
            }
            if (min_unused == M + 1) {
                min_unused = 0;
                max_unused = 0;
            }
        }

        bool ok = true;

        // 行・列の部分和枝刈り
        if (!feasible(row_sum[r], row_left[r])) ok = false;
        if (ok && !feasible(col_sum[c], col_left[c])) ok = false;

        // 対角線の部分和枝刈り
        if (ok && on_d1 && !feasible(diag1_sum, diag1_left)) ok = false;
        if (ok && on_d2 && !feasible(diag2_sum, diag2_left)) ok = false;

        if (ok) dfs(pos + 1);

        // 元に戻す
        row_sum[r] = old_row;
        col_sum[c] = old_col;
        row_left[r]++;
        col_left[c]++;
        diag1_sum = old_d1;
        diag2_sum = old_d2;
        if (on_d1) diag1_left++;
        if (on_d2) diag2_left++;
        min_unused = old_min;
        max_unused = old_max;
        used[v] = false;
    }
}

int main(int argc, char** argv) {
    if (argc < 2) {
        cout << "Usage: exe N\n";
        return 0;
    }

    N = atoi(argv[1]);
    M = N * N;
    MAGIC_SUM = N * (M + 1) / 2;

    grid.assign(M, 0);
    used.assign(M + 1, false);

    row_sum.assign(N, 0);
    col_sum.assign(N, 0);
    row_left.assign(N, N);
    col_left.assign(N, N);

    diag1_sum = diag2_sum = 0;
    diag1_left = diag2_left = N;

    min_unused = 1;
    max_unused = M;

    auto start = chrono::high_resolution_clock::now();
    dfs(0);
    auto end = chrono::high_resolution_clock::now();

    double t = chrono::duration<double>(end - start).count();

    cout << "N=" << N << " Count=" << solutions
         << " Time=" << fixed << setprecision(6) << t << " sec\n";
}
