use std::env;
use std::time::Instant;

fn dfs(n: usize, row: usize, cols: u32, d1: u32, d2: u32, count: &mut u64) {
    if row == n {
        *count += 1;
        return;
    }

    let mask: u32 = (1u32 << n) - 1;
    let mut avail = mask & !(cols | d1 | d2);

    while avail != 0 {
        let p = avail & (!avail + 1); // 最下位ビット
        avail ^= p;

        dfs(
            n,
            row + 1,
            cols | p,
            (d1 | p) << 1,
            (d2 | p) >> 1,
            count,
        );
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let n: usize = if args.len() >= 2 {
        args[1].parse().unwrap_or(14)
    } else {
        14
    };

    let start = Instant::now();
    let mut count: u64 = 0;

    dfs(n, 0, 0, 0, 0, &mut count);

    let t = start.elapsed().as_secs_f64();

    println!("N={} Count={} Time={:.6} sec", n, count, t);
}
