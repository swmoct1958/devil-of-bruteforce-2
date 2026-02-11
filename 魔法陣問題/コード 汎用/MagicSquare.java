import java.util.Arrays;

public class MagicSquare {
    static int N;
    static int count = 0;
    static int magicSum;
    static int[] square;
    static boolean[] used;

    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Usage: java MagicSquare <N>");
            return;
        }

        N = Integer.parseInt(args[0]);
        magicSum = N * (N * N + 1) / 2;
        square = new int[N * N];
        used = new boolean[N * N + 1]; // 1..N^2

        long start = System.nanoTime();
        solve(0);
        long end = System.nanoTime();

        System.out.printf("N=%d Time=%.6f sec Count=%d%n", N, (end - start) / 1e9, count);
    }

    static void solve(int pos) {
        if (pos == N * N) {
            if (isMagic()) count++;
            return;
        }

        for (int i = 1; i <= N * N; i++) {
            if (!used[i]) {
                square[pos] = i;
                used[i] = true;

                // 早期枝刈り：行が埋まったら合計チェック
                if ((pos + 1) % N == 0 && !checkRow((pos / N))) {
                    used[i] = false;
                    continue;
                }

                // 早期枝刈り：列が埋まったら合計チェック
                if (pos >= N * (N - 1) && !checkCol(pos % N)) {
                    used[i] = false;
                    continue;
                }

                solve(pos + 1);
                used[i] = false;
            }
        }
    }

    static boolean isMagic() {
        // 行と列は既に部分チェック済み、最後に斜めを確認
        int diag1 = 0, diag2 = 0;
        for (int i = 0; i < N; i++) {
            diag1 += square[i * N + i];
            diag2 += square[i * N + (N - 1 - i)];
        }
        return diag1 == magicSum && diag2 == magicSum;
    }

    static boolean checkRow(int row) {
        int sum = 0;
        for (int i = 0; i < N; i++) sum += square[row * N + i];
        return sum == magicSum;
    }

    static boolean checkCol(int col) {
        int sum = 0;
        for (int i = 0; i < N; i++) sum += square[i * N + col];
        return sum == magicSum;
    }
}
