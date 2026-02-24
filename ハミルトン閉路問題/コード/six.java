import java.io.*;
import java.nio.file.*;
import java.util.*;

public class six {
    static int N;
    static int[][] adj;
    static boolean[] visited;
    static long counter = 0;

    static void dfs(int v) {
        visited[v] = true;
        counter++;

        for (int i = 0; i < N; i++) {
            if (adj[v][i] == 1 && !visited[i]) {
                dfs(i);
            }
        }

        visited[v] = false;
    }

    public static void main(String[] args) throws Exception {
        if (args.length < 1) {
            System.out.println("Usage: java six <graphfile>");
            return;
        }

        String filename = args[0];
        List<String> lines = Files.readAllLines(Paths.get(filename));

        N = lines.size();
        adj = new int[N][N];
        visited = new boolean[N];

        for (int i = 0; i < N; i++) {
            String[] parts = lines.get(i).trim().split("\\s+");
            for (int j = 0; j < N; j++) {
                adj[i][j] = Integer.parseInt(parts[j]);
            }
        }

        long start = System.nanoTime();
        dfs(0);
        long end = System.nanoTime();

        double ms = (end - start) / 1_000_000.0;

        System.out.printf("file = %s\n", filename);
        System.out.printf("N = %d\n", N);
        System.out.printf("counter = %d\n", counter);
        System.out.printf("time = %.3f ms\n", ms);
    }
}
