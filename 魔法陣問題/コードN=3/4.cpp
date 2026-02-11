#include <iostream>
#include <vector>
#include <chrono>

using namespace std;

void solve(int p, int n, vector<int>& board, vector<bool>& used, int target, int& count) {
    if (p == n * n) {
        int d1 = 0, d2 = 0;
        for (int i = 0; i < n; ++i) {
            d1 += board[i * n + i];
            d2 += board[i * n + (n - 1 - i)];
        }
        if (d1 == target && d2 == target) count++;
        return;
    }
    for (int v = 1; v <= n * n; ++v) {
        if (!used[v]) {
            board[p] = v;
            if ((p + 1) % n == 0) {
                int s = 0;
                for (int i = 0; i < n; ++i) s += board[p - i];
                if (s != target) continue;
            }
            if (p >= n * (n - 1)) {
                int s = 0;
                for (int i = 0; i < n; ++i) s += board[p - i * n];
                if (s != target) continue;
            }
            used[v] = true;
            solve(p + 1, n, board, used, target, count);
            used[v] = false;
        }
    }
}

int main() {
    int n = 3;
    int target = n * (n * n + 1) / 2;
    vector<int> board(n * n);
    vector<bool> used(n * n + 1, false);
    int count = 0;
    auto start = chrono::high_resolution_clock::now();
    solve(0, n, board, used, target, count);
    auto end = chrono::high_resolution_clock::now();
    cout << "N=" << n << ", Count: " << count << ", Time: " << chrono::duration<double>(end - start).count() << " s" << endl;
    return 0;
}
