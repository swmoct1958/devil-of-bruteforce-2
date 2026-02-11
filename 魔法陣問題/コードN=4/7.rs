use std::time::Instant;

const S: i32 = 34;

struct Solver {
    total_count: i64,
    board: [i32; 16],
    used: u32,
}

impl Solver {
    fn new() -> Self {
        Self {
            total_count: 0,
            board: [0; 16],
            used: 0,
        }
    }

    fn solve(&mut self, pos: usize) {
        // 行が埋まったタイミングでの逆算と枝切り
        if pos == 3 {
            let v = S - (self.board[0] + self.board[1] + self.board[2]);
            if v >= 1 && v <= 16 && (self.used & (1 << v)) == 0 {
                self.board[3] = v; self.used |= 1 << v; self.solve(4); self.used &= !(1 << v);
            }
            return;
        }
        if pos == 7 {
            let v = S - (self.board[4] + self.board[5] + self.board[6]);
            if v >= 1 && v <= 16 && (self.used & (1 << v)) == 0 {
                self.board[7] = v; self.used |= 1 << v; self.solve(8); self.used &= !(1 << v);
            }
            return;
        }
        if pos == 11 {
            let v = S - (self.board[8] + self.board[9] + self.board[10]);
            if v >= 1 && v <= 16 && (self.used & (1 << v)) == 0 {
                self.board[11] = v; self.used |= 1 << v; self.solve(12); self.used &= !(1 << v);
            }
            return;
        }

        // 最終判定（列と対角線）
        if pos == 12 {
            let v12 = S - (self.board[0] + self.board[4] + self.board[8]);
            if v12 < 1 || v12 > 16 || (self.used & (1 << v12)) != 0 { return; }
            let v13 = S - (self.board[1] + self.board[5] + self.board[9]);
            if v13 < 1 || v13 > 16 || v13 == v12 || (self.used & (1 << v13)) != 0 { return; }
            let v14 = S - (self.board[2] + self.board[6] + self.board[10]);
            if v14 < 1 || v14 > 16 || v14 == v12 || v14 == v13 || (self.used & (1 << v14)) != 0 { return; }
            let v15 = S - (self.board[3] + self.board[7] + self.board[11]);
            if v15 < 1 || v15 > 16 || v15 == v12 || v15 == v13 || v15 == v14 || (self.used & (1 << v15)) != 0 { return; }

            if v12 + v13 + v14 + v15 == S && 
               self.board[0] + self.board[5] + self.board[10] + v15 == S && 
               self.board[3] + self.board[6] + self.board[9] + v12 == S {
                self.total_count += 1;
            }
            return;
        }

        for v in 1..=16 {
            if (self.used & (1 << v)) == 0 {
                self.used |= 1 << v;
                self.board[pos] = v;
                self.solve(pos + 1);
                self.used &= !(1 << v);
            }
        }
    }
}

fn main() {
    println!("Rust n=4 Search Start...");
    let mut solver = Solver::new();
    let start = Instant::now();

    solver.solve(0);

    let duration = start.elapsed();
    println!("Count: {} (7040)", solver.total_count);
    println!("Time: {} ms", duration.as_millis());
}