use std::env;
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::sync::atomic::{AtomicU64, Ordering};
use std::time::Instant;

static COUNTER: AtomicU64 = AtomicU64::new(0);

fn dfs(v: usize, adj: &Vec<Vec<i32>>, visited: &mut Vec<bool>, n: usize) {
    visited[v] = true;

    COUNTER.fetch_add(1, Ordering::Relaxed);

    for i in 0..n {
        if adj[v][i] == 1 && !visited[i] {
            dfs(i, adj, visited, n);
        }
    }

    visited[v] = false;
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        println!("Usage: 7 <graphfile>");
        return;
    }

    let filename = &args[1];
    let file = File::open(filename).expect("Cannot open file");
    let reader = BufReader::new(file);

    let mut adj: Vec<Vec<i32>> = Vec::new();

    for line in reader.lines() {
        let line = line.unwrap();
        let row: Vec<i32> = line
            .split_whitespace()
            .map(|x| x.parse::<i32>().unwrap())
            .collect();
        adj.push(row);
    }

    let n = adj.len();
    let mut visited = vec![false; n];

    let start = Instant::now();
    dfs(0, &adj, &mut visited, n);
    let elapsed = start.elapsed();

    let ms = elapsed.as_secs_f64() * 1000.0;

    println!("file = {}", filename);
    println!("N = {}", n);
    println!("counter = {}", COUNTER.load(Ordering::Relaxed));
    println!("time = {:.4} ms", ms);
}
