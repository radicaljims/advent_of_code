use std::cmp::Reverse;
use std::collections::BinaryHeap;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

fn main() {
    // for part 1
    let mut evens = BinaryHeap::new();
    let mut odds = BinaryHeap::new();

    // for part 2
    let mut sorted_odds = Vec::new();

    if let Ok(lines) = read_lines("./input.txt") {
        for line in lines.flatten() {
            let numbers: Vec<i64> = line
                .split_whitespace()
                .map(|x| x.parse::<i64>().unwrap())
                .collect();
            if let [even, odd] = numbers[..] {
                evens.push(Reverse(even));
                odds.push(Reverse(odd));

                sorted_odds.push(odd);
            }
        }
    }

    sorted_odds.sort();

    assert!(evens.len() == odds.len());

    let mut s = 0;
    let mut t = 0;
    while !evens.is_empty() {
        let Reverse(e) = evens.pop().unwrap();
        let Reverse(o) = odds.pop().unwrap();

        // part 1
        s += i64::abs(e - o);

        let low = sorted_odds.partition_point(|x| x < &e);
        let high = sorted_odds.partition_point(|x| x <= &e);

        let c = (high - low) as i64;

        // part 2
        t += e * c;
    }

    println!("{}", s);
    println!("{}", t);
}
