public class NQueens {
    static long count;
    static int N;

    static void dfs(int row, int cols, int d1, int d2) {
        if (row == N) {
            count++;
            return;
        }
        int mask = (1 << N) - 1;
        int avail = mask & ~(cols | d1 | d2);

        while (avail != 0) {
            int p = avail & -avail;   // 最下位ビット
            avail -= p;
            dfs(row + 1,
                cols | p,
                (d1 | p) << 1,
                (d2 | p) >> 1);
        }
    }

    public static void main(String[] args) {
        N = 14;
        if (args.length >= 1) {
            N = Integer.parseInt(args[0]);
        }

        long start = System.nanoTime();
        count = 0;
        dfs(0, 0, 0, 0);
        double t = (System.nanoTime() - start) / 1e9;

        System.out.printf("N=%d Count=%d Time=%.6f sec%n", N, count, t);
    }
}
