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
    let mut evens = BinaryHeap::new();
    let mut odds = BinaryHeap::new();

    if let Ok(lines) = read_lines("./input.txt") {
        for line in lines.flatten() {
            let numbers: Vec<i64> = line
                .split_whitespace()
                .map(|x| x.parse::<i64>().unwrap())
                .collect();
            if let [even, odd] = numbers[..] {
                evens.push(Reverse(even));
                odds.push(Reverse(odd));
            }
        }
    }

    assert!(evens.len() == odds.len());

    let mut s = 0;
    while !evens.is_empty() {
        let Reverse(e) = evens.pop().unwrap();
        let Reverse(o) = odds.pop().unwrap();

        s += i64::abs(e - o);
    }

    println!("{}", s);
}
