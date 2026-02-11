use std::env;
use std::time::Instant;

fn main() {
    let args: Vec<String> = env::args().collect();
    let n: usize = if args.len() >= 2 {
        args[1].parse().unwrap_or(4)
    } else {
        4
    };

    let magic = n * (n * n + 1) / 2;

    let mut sq = vec![0usize; n * n];
    let mut used = vec![false; n * n + 1];

    let mut row = vec![0usize; n];
    let mut col = vec![0usize; n];

    let mut count = 0usize;

    let start = Instant::now();

    // 1行目を固定（最速化のため）
    for i in 0..n {
        let v = i + 1;
        sq[i] = v;
        used[v] = true;
        row[0] += v;
        col[i] += v;
    }

    let mut diag = sq[0]; // 左上
    let mut adiag = sq[n - 1]; // 右上

    dfs(
        n, n, magic,
        &mut sq, &mut used,
        &mut row, &mut col,
        &mut diag, &mut adiag,
        &mut count,
    );

    println!(
        "N={} Count={} Time={:.6} sec",
        n, count, start.elapsed().as_secs_f64()
    );
}

fn dfs(
    pos: usize, n: usize, magic: usize,
    sq: &mut [usize], used: &mut [bool],
    row: &mut [usize], col: &mut [usize],
    diag: &mut usize, adiag: &mut usize,
    count: &mut usize,
) {
    if pos == n * n {
        *count += 1;
        return;
    }

    let r = pos / n;
    let c = pos % n;

    // 行末・列末の強制値
    let forced = if c == n - 1 {
        let need = magic - row[r];
        if need >= 1 && need <= n * n && !used[need] {
            Some(need)
        } else {
            return;
        }
    } else if r == n - 1 {
        let need = magic - col[c];
        if need >= 1 && need <= n * n && !used[need] {
            Some(need)
        } else {
            return;
        }
    } else if r == c && r == n - 1 {
        // 主対角線の最後
        let need = magic - *diag;
        if need >= 1 && need <= n * n && !used[need] {
            Some(need)
        } else {
            return;
        }
    } else if r + c == n - 1 && r == n - 1 {
        // 副対角線の最後
        let need = magic - *adiag;
        if need >= 1 && need <= n * n && !used[need] {
            Some(need)
        } else {
            return;
        }
    } else {
        None
    };

    let iter: Box<dyn Iterator<Item = usize>> = match forced {
        Some(v) => Box::new(std::iter::once(v)),
        None => Box::new(1..=n * n),
    };

    for v in iter {
        if used[v] {
            continue;
        }

        if row[r] + v > magic || col[c] + v > magic {
            continue;
        }

        if r == c && *diag + v > magic {
            continue;
        }
        if r + c == n - 1 && *adiag + v > magic {
            continue;
        }

        sq[pos] = v;
        used[v] = true;
        row[r] += v;
        col[c] += v;
        if r == c {
            *diag += v;
        }
        if r + c == n - 1 {
            *adiag += v;
        }

        dfs(pos + 1, n, magic, sq, used, row, col, diag, adiag, count);

        used[v] = false;
        row[r] -= v;
        col[c] -= v;
        if r == c {
            *diag -= v;
        }
        if r + c == n - 1 {
            *adiag -= v;
        }
    }
}
