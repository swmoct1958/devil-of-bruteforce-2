public class MagicSquareSolver {
    public static void main(String[] args) {
        int n = 4;
        int target = n * (n * n + 1) / 2;
        int[] board = new int[n * n];
        boolean[] used = new boolean[n * n + 1];
        int[] count = {0};

        long start = System.currentTimeMillis();
        solve(0, n, board, used, target, count);
        long end = System.currentTimeMillis();
        System.out.println("N=" + n + ", Count: " + count[0] + ", Time: " + (end - start) / 1000.0 + " s");
    }

    static void solve(int p, int n, int[] board, boolean[] used, int target, int[] count) {
        if (p == n * n) {
            int d1 = 0, d2 = 0;
            for (int i = 0; i < n; i++) {
                d1 += board[i * n + i];
                d2 += board[i * n + (n - 1 - i)];
            }
            if (d1 == target && d2 == target) count[0]++;
            return;
        }
        for (int v = 1; v <= n * n; v++) {
            if (!used[v]) {
                board[p] = v;
                if ((p + 1) % n == 0) {
                    int s = 0;
                    for (int i = 0; i < n; i++) s += board[p - i];
                    if (s != target) continue;
                }
                if (p >= n * (n - 1)) {
                    int s = 0;
                    for (int i = 0; i < n; i++) s += board[p - i * n];
                    if (s != target) continue;
                }
                used[v] = true; solve(p + 1, n, board, used, target, count); used[v] = false;
            }
        }
    }
}