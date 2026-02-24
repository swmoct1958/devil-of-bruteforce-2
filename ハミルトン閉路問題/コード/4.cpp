// dfs_cpp_opt_final.cpp
// v6 グラフ用：bitmask + adjacency list + degree-order + pruning
// 再帰なし（iterative DFS）
// gXX.txt を読み込んでハミルトン閉路数を数える

#include <bits/stdc++.h>
using namespace std;

int main(int argc, char** argv) {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    if (argc < 2) {
        cerr << "usage: ./a.out gXX.txt\n";
        return 1;
    }

    // ---- グラフ読み込み ----
    ifstream fin(argv[1]);
    if (!fin) {
        cerr << "file not found\n";
        return 1;
    }

    vector<vector<int>> G;
    string line;
    while (getline(fin, line)) {
        if (line.empty()) continue;
        stringstream ss(line);
        vector<int> row;
        int x;
        while (ss >> x) row.push_back(x);
        if (!row.empty()) G.push_back(row);
    }

    int N = G.size();
    vector<vector<int>> adj(N);

    // 隣接リスト化
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            if (G[i][j]) adj[i].push_back(j);
        }
    }

    // 次数順ソート（低次数優先）
    vector<int> deg(N);
    for (int i = 0; i < N; i++) deg[i] = adj[i].size();
    for (int i = 0; i < N; i++) {
        sort(adj[i].begin(), adj[i].end(),
             [&](int a, int b){ return deg[a] < deg[b]; });
    }

    // ---- DFS（iterative） ----
    using ull = unsigned long long;
    const int start = 0;
    ull used0 = 1ULL << start;

    struct Node {
        int v;
        int depth;
        ull used;
    };

    vector<Node> st;
    st.reserve(1 << 20);
    st.push_back({start, 1, used0});

    long long count = 0;

    auto t0 = chrono::high_resolution_clock::now();

    while (!st.empty()) {
        auto [v, depth, used] = st.back();
        st.pop_back();

        if (depth == N) {
            // 閉路チェック
            for (int u : adj[v]) {
                if (u == start) {
                    count++;
                    break;
                }
            }
            continue;
        }

        // dead-end pruning（C++ では高速）
        // 「未訪問頂点のうち、どれかが '訪問可能な隣接先ゼロ' なら即終了」
        bool dead = false;
        for (int x = 0; x < N; x++) {
            if (!(used & (1ULL << x))) {
                bool ok = false;
                for (int y : adj[x]) {
                    if (!(used & (1ULL << y)) || y == v) {
                        ok = true;
                        break;
                    }
                }
                if (!ok) { dead = true; break; }
            }
        }
        if (dead) continue;

        // 次へ
        for (int u : adj[v]) {
            if (!(used & (1ULL << u))) {
                st.push_back({u, depth + 1, used | (1ULL << u)});
            }
        }
    }

    auto t1 = chrono::high_resolution_clock::now();
    double ms = chrono::duration<double, milli>(t1 - t0).count();

    cout << "N = " << N << "\n";
    cout << "Hamiltonian cycles: " << count << "\n";
    cout << "Time: " << ms << " ms\n";

    return 0;
}
