#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAXN 10

int N, SIZE, TARGET;
long long count = 0;

int board[100];
int rowSum[MAXN], colSum[MAXN];
int rowCnt[MAXN], colCnt[MAXN];
int diag1Sum = 0, diag2Sum = 0;
int usedMask = 0;

// 未使用の最小 k 個の和
int minRemain(int k){
    int s=0, c=0;
    for(int v=1; v<=SIZE && c<k; v++)
        if(!(usedMask&(1<<v))){ s+=v; c++; }
    return s;
}

// 未使用の最大 k 個の和
int maxRemain(int k){
    int s=0, c=0;
    for(int v=SIZE; v>=1 && c<k; v--)
        if(!(usedMask&(1<<v))){ s+=v; c++; }
    return s;
}

void solve(int idx){
    if(idx == SIZE){
        if(diag1Sum==TARGET && diag2Sum==TARGET) count++;
        return;
    }

    int r = idx / N;
    int c = idx % N;

    for(int v=1; v<=SIZE; v++){
        if(usedMask & (1<<v)) continue;

        // 対称性除去：1行目を昇順
        if(r==0 && c>0 && v < board[c-1]) continue;

        int rs = rowSum[r] + v;
        int cs = colSum[c] + v;
        int rc = rowCnt[r] + 1;
        int cc = colCnt[c] + 1;

        int rem = N - rc;
        if(rs + minRemain(rem) > TARGET) continue;
        if(rs + maxRemain(rem) < TARGET) continue;

        rem = N - cc;
        if(cs + minRemain(rem) > TARGET) continue;
        if(cs + maxRemain(rem) < TARGET) continue;

        int d1 = diag1Sum, d2 = diag2Sum;

        if(r==c){
            int remd = N - (r+1);
            if(d1 + v + minRemain(remd) > TARGET) continue;
            if(d1 + v + maxRemain(remd) < TARGET) continue;
            d1 += v;
        }

        if(r+c==N-1){
            int remd = N - (r+1);
            if(d2 + v + minRemain(remd) > TARGET) continue;
            if(d2 + v + maxRemain(remd) < TARGET) continue;
            d2 += v;
        }

        // 置く
        usedMask |= (1<<v);
        board[idx] = v;
        rowSum[r] = rs; colSum[c] = cs;
        rowCnt[r] = rc; colCnt[c] = cc;
        diag1Sum = d1; diag2Sum = d2;

        solve(idx+1);

        // 戻す
        usedMask &= ~(1<<v);
        rowSum[r] -= v; colSum[c] -= v;
        rowCnt[r]--; colCnt[c]--;
        if(r==c) diag1Sum -= v;
        if(r+c==N-1) diag2Sum -= v;
    }
}

int main(int argc, char *argv[]){
    if(argc<2) return 1;

    N = atoi(argv[1]);
    SIZE = N*N;
    TARGET = N*(SIZE+1)/2;

    // 左上固定
    board[0] = 1;
    usedMask = (1<<1);
    rowSum[0] = 1;
    colSum[0] = 1;
    rowCnt[0] = 1;
    colCnt[0] = 1;
    diag1Sum = 1;

    clock_t s = clock();
    solve(1);
    clock_t e = clock();

    printf("N=%d Time=%f sec Count=%lld\n",
        N, (double)(e-s)/CLOCKS_PER_SEC, count);

    return 0;
}
