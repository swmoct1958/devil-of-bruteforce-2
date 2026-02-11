public class MagicSquareSolver {
    public static void main(String[] args) {
        // main関数で次数を定義
        final int n = 3;
        final int target = n * (n * n + 1) / 2;
        
        int[] board = new int[n * n];
        boolean[] used = new boolean[n * n + 1];
        int[] foundCount = {0};

        System.out.println(n + "次魔法陣の探索を開始します(Java)...");

        // --- 計測開始 ---
        long start = System.nanoTime();

        solve(0, n, board, used, target, foundCount);

        long end = System.nanoTime();
        // --- 計測終了 ---

        // ナノ秒を秒に変換
        double duration = (end - start) / 1_000_000_000.0;

        System.out.println("\n探索完了。見つかった解の数: " + foundCount[0]);
        System.out.printf("実行時間: %.4f 秒\n", duration);
    }

    private static void solve(int step, int n, int[] board, boolean[] used, int target, int[] count) {
        if (step == n * n) {
            if (isMagic(n, board, target)) {
                count[0]++;
                // 解の表示（必要なら）
                // printBoard(n, board);
            }
            return;
        }

        for (int i = 1; i <= n * n; i++) {
            if (!used[i]) {
                used[i] = true;
                board[step] = i;
                solve(step + 1, n, board, used, target, count);
                used[i] = false;
            }
        }
    }

    private static boolean isMagic(int n, int[] board, int target) {
        for (int i = 0; i < n; i++) {
            int rowSum = 0, colSum = 0;
            for (int j = 0; j < n; j++) {
                rowSum += board[i * n + j];
                colSum += board[j * n + i];
            }
            if (rowSum != target || colSum != target) return false;
        }
        int d1 = 0, d2 = 0;
        for (int i = 0; i < n; i++) {
            d1 += board[i * n + i];
            d2 += board[i * n + (n - 1 - i)];
        }
        return (d1 == target && d2 == target);
    }
}
