#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>

#define MAXN 20

static int N;
static int adj[MAXN][MAXN];
static int visited[MAXN];
static long long counter = 0;

void dfs(int v) {
    visited[v] = 1;
    counter++;

    for (int i = 0; i < N; i++) {
        if (adj[v][i] && !visited[i]) {
            dfs(i);
        }
    }

    visited[v] = 0;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: 5.exe <graphfile>\n");
        return 1;
    }

    FILE *fp = fopen(argv[1], "r");
    if (!fp) {
        printf("Cannot open %s\n", argv[1]);
        return 1;
    }

    char buf[256];
    N = 0;

    // 行数を数えながら読み込む（あなたの Python/C++ と同じ仕様）
    while (fgets(buf, sizeof(buf), fp)) {
        int col = 0;
        char *p = buf;
        int val, consumed;

        while (sscanf(p, "%d%n", &val, &consumed) == 1) {
            adj[N][col++] = val;
            p += consumed;
        }

        N++;
    }
    fclose(fp);

    LARGE_INTEGER freq, start, end;
    QueryPerformanceFrequency(&freq);

    QueryPerformanceCounter(&start);
    dfs(0);
    QueryPerformanceCounter(&end);

    double ms = (double)(end.QuadPart - start.QuadPart) * 1000.0 / freq.QuadPart;

    printf("file = %s\n", argv[1]);
    printf("N = %d\n", N);
    printf("counter = %lld\n", counter);
    printf("time = %.3f ms\n", ms);

    return 0;
}
