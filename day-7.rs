use std::fs::read_to_string;
use std::collections::HashMap;

fn make_name(x: usize, y: usize) -> String {
    return format!("{},{}", x, y)
}

fn main() {
    let mut manifold: Vec<Vec<char>> = read_to_string("./day-7-input")
        .unwrap()
        .lines()
        .map(|ln| ln.chars().collect())
        .collect();

    let row_count = manifold.len();
    let col_count = manifold[0].len();
    let mut lineage = HashMap::new();
    let mut root = make_name(0, 0);


    for i in 0..row_count - 1 {
        for j in 0..col_count {
            if manifold[i][j] == 'S' || manifold[i][j] == '|' {
                if manifold[i][j] == 'S' {
                    root = make_name(i, j)
                }

                let below = manifold[i + 1][j];

                match below {
                    '.' | '|' => {
                        lineage.insert(make_name(i, j), vec![make_name(i + 1, j)]);
                        manifold[i + 1][j] = '|';
                    },
                    '^' => {
                        match j {
                            0 => {
                                lineage.insert(make_name(i, j), vec![make_name(i + 1, j + 1)]);
                                manifold[i + 1][j + 1] = '|';
                            },
                            val if val == col_count -1 => {
                                lineage.insert(make_name(i, j), vec![make_name(i + 1, j - 1)]);
                                manifold[i + 1][j - 1] = '|';
                            },
                            _ => {
                                lineage.insert(make_name(i, j), vec![make_name(i + 1, j - 1), make_name(i + 1, j + 1)]);
                                manifold[i + 1][j + 1] = '|';
                                manifold[i + 1][j - 1] = '|'
                            }
                        }
                    }
                    _ => (),
                }
            }
        }
    }

    let mut spliter_count = 0;

    for i in 0..row_count - 1 {
        for j in 0..col_count {
            if manifold[i][j] == '^' && manifold[i - 1][j] == '|' {
                spliter_count += 1;
            }
        }
    }

    let mut memo = HashMap::new();

    fn dfs_impl(node: &str,
        memo: &mut HashMap<String, i64>,
        lineage: &HashMap<String, Vec<String>>,
        row_count: usize) -> i64 {
        if let Some(val) = memo.get(node) {
            return *val
        }

        let mut coord = node.split(",");

        if let Some(y) = coord.nth(0) {
            let n: usize = y.parse().unwrap();

            if n == row_count - 1 {
                return 1;
            }
        }

        let mut count: i64 = 0;

        if let Some(val) = lineage.get(node) {
            for i in val.iter() {
                count += dfs_impl(i, memo, lineage, row_count)
            }
        }

        memo.insert(node.to_string(), count);
        count
    }

    let mut dfs = |node: &str| dfs_impl(node, &mut memo, &lineage, row_count);

    println!("Problem 1: {:?}", spliter_count);
    println!("Problem 2: {:?}", dfs(&root));
}
