use std::time::Instant;

fn solve(p: usize, n: usize, target: i32, board: &mut Vec<i32>, used: &mut Vec<bool>, count: &mut i32) {
    if p == n * n {
        let mut d1 = 0; let mut d2 = 0;
        for i in 0..n {
            d1 += board[i * n + i];
            d2 += board[i * n + (n - 1 - i)];
        }
        if d1 == target && d2 == target { *count += 1; }
        return;
    }

    for v in 1..=(n * n) as i32 {
        if !used[v as usize] {
            board[p] = v;
            if (p + 1) % n == 0 {
                if board[p + 1 - n..=p].iter().sum::<i32>() != target { continue; }
            }
            if p >= n * (n - 1) {
                if (0..n).map(|i| board[p % n + i * n]).sum::<i32>() != target { continue; }
            }
            used[v as usize] = true;
            solve(p + 1, n, target, board, used, count);
            used[v as usize] = false;
        }
    }
}

fn main() {
    let n = 3;
    let target = (n * (n * n + 1) / 2) as i32;
    let mut board = vec![0; n * n];
    let mut used = vec![false; n * n + 1];
    let mut count = 0;
    let start = Instant::now();
    solve(0, n, target, &mut board, &mut used, &mut count);
    println!("N={}, Count: {}, Time: {:?}", n, count, start.elapsed());
}
