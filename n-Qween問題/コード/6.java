// public を削除して class だけで始める
class NQueenSolver {
    private static long totalSolutions = 0;
    private static int allMask;

    public static void solve(int colMask, int leftMask, int rightMask) {
        if (colMask == allMask) {
            totalSolutions++;
            return;
        }

        int pos = allMask & ~(colMask | leftMask | rightMask);

        while (pos != 0) {
            int bit = pos & -pos;
            pos ^= bit;
            // Javaの符号なし右シフト
            solve(colMask | bit, (leftMask | bit) << 1, (rightMask | bit) >>> 1);
        }
    }

    public static void main(String[] args) {
        int n = 13;
        allMask = (1 << n) - 1;

        long start = System.currentTimeMillis();
        solve(0, 0, 0);
        long end = System.currentTimeMillis();

        System.out.println("N=" + n + " の解の総数: " + totalSolutions);
        System.out.println("実行時間: " + (end - start) / 1000.0 + " 秒");
    }
}