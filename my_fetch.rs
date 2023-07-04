/*
I'm too lazy to make a new repo...

colored = "2.0.0"
lazy_static = "1.4.0"
sysinfo = "0.29.2"
battery = "0.7.8"
h_time = "0.1.0"
*/

use colored::*;
use sysinfo::*;
use std::fs::File;
use std::io::Read;
use std::process::Command;

fn main() {
    println!("{}\n{}", title().join("\n"), bottom().join("\n"));
}

fn title() -> Vec<String> {
    vec![
        String::new(),
        format!("{}", "     ▛▀▚ ▗▄▖ ▞▀▚ ▌   ▖ ▖         ▗▄▖     ▜▌ ▘ ▗▄▖    ▌   ▗▖         ▖ ▖".red()),
        format!("{}", "     ▛▀▚ ▗▄▟ ▛▀▘ ▛▀▖ ▚▄▘ ▌ ▐ ▄▄  ▚▄▖ ▞▀▚ ▐▌   ▚▄▖    ▌   ▗▖ ▄▄  ▌ ▐ ▝▞ ".red()),
        format!("{}", "     ▙▄▞ ▚▄▞ ▚▄▞ ▌ ▌  ▐  ▚▄▞ ▌ ▌ ▗▄▞ ▚▄▞ ▐▙   ▗▄▞    ▙▄▄ ▐▌ ▌ ▌ ▚▄▞ ▞▝▖".blue()),
        format!("{}", "                     ▝▘                                                ".blue()),
        format!("{}", " =========================================================================="),
    ]
}

fn bottom() -> Vec<String> {
    let left = calendars();
    let right = vec![status(), vec!["".to_string()], load_memo()].concat();
    let mut lines = Vec::with_capacity(left.len().min(right.len()));

    for i in 0..left.len().min(right.len()) {
        lines.push(format!(" {} | {}", left[i], right[i]));
    }

    if left.len() > right.len() {

        for i in lines.len()..left.len().max(right.len()) {
            lines.push(format!(" {} |", left[i]));
        }

    }

    else {

        for i in lines.len()..left.len().max(right.len()) {
            lines.push(format!(" {} | {}", " ".repeat(33),  right[i]));
        }

    }

    lines
}

fn status() -> Vec<String> {
    let mut sys = System::new();
    sys.refresh_cpu();
    sys.refresh_memory();

    let now = h_time::Date::now();
    let birthday = h_time::Date::from_ymd(1999, 1, 20);
    let since_birth = now.duration_since(&birthday).into_days();

    let nu_version = String::from_utf8_lossy(&Command::new("nu").arg("-v").output().unwrap().stdout).to_string().strip_suffix("\n").unwrap().to_string();
    let rust_version = String::from_utf8_lossy(&Command::new("rustc").arg("--version").output().unwrap().stdout).to_string().strip_suffix("\n").unwrap().to_string();

    vec![
        format!("{}: {}.{:02}.{:02} ({}) {:02}:{:02}:{:02}", "Date".green(), NOW.0, NOW.1, NOW.2, NOW.3, NOW.4, NOW.5, NOW.6),
        format!("{}: {} days", "Since Birth".green(), since_birth),
        format!("{}: {} seconds", "Since Boot".green(), sys.uptime()),
        format!("{}: {}", "Battery".green(), get_battery().unwrap_or("Unknown".to_string())),
        format!("{}: {}", "Os".green(), sys.long_os_version().unwrap_or("Unknown".to_string())),
        format!("{}: {}", "Nushell".green(), nu_version),
        format!("{}: {}", "Rust".green(), rust_version),
        format!("{}: {}", "Kernel".green(), sys.kernel_version().unwrap_or("Unknown".to_string())),
        format!("{}: {}", "CPU".green(), sys.cpus()[0].brand()),
        format!("{}: {} MB", "Memory".green(), sys.total_memory() / 1048576),
    ]
}

fn load_memo() -> Vec<String> {
    let mut s = String::new();
    let mut lines = vec![format!("{}", "Memo".green())];

    match File::open("~/Documents/fetch_memo.txt") {
        Ok(mut f) => match f.read_to_string(&mut s) {
            Ok(_) => {},
            _ => {
                lines.push(String::from("~/Documents/fetch_memo.txt를 찾을 수 없습니다."));
                return lines;
            }
        }
        _ => {
            lines.push(String::from("~/Documents/fetch_memo.txt를 찾을 수 없습니다."));
            return lines;
        }
    }

    let mut curr_line = vec![];

    for c in s.chars() {

        if c == '\n' {
            lines.push(curr_line.into_iter().collect());
            curr_line = vec![];
        }

        else if curr_line.len() > 27 {
            lines.push(curr_line.into_iter().collect());
            curr_line = vec![c];
        }

        else if curr_line.len() > 18 && c == ' ' {
            lines.push(curr_line.into_iter().collect());
            curr_line = vec![];
        }

        else {
            curr_line.push(c);
        }

    }

    if curr_line.len() > 0 {
        lines.push(curr_line.into_iter().collect());
    }

    lines
}

fn get_battery() -> Result<String, ()> {
    let manager = if let Ok(m) = battery::Manager::new() { m } else { return Err(()); };

    if let Ok(mut iterator) = manager.batteries() {
        let battery = match iterator.next() {
            Some(Ok(battery)) => battery,
            _ => {
                return Err(());
            }
        };

        let state = match battery.state() {
            battery::State::Charging => ", charging",
            battery::State::Discharging => ", discharging",
            battery::State::Full => ", full",
            _ => ""
        }.to_string();

        let n = match format!("{:?}", battery.state_of_charge()).parse::<f32>() {
            Ok(n) => n,
            _ => { return Err(()); }
        };

        Ok(format!("{}%{state}", pretty_f32(n)))
    }

    else {
        Err(())
    }

}

fn pretty_f32(n: f32) -> String {
    let n = (n * 1000.0) as u32;

    if n % 10 == 0 {
        (n / 10).to_string()
    }

    else {
        let rem = n % 10;
        let n = n / 10;
        format!("{n}.{rem}")
    }

}

fn calendars() -> Vec<String> {
    let (year, month, day) = (NOW.0, NOW.1, NOW.2);
    let (year2, month2) = if month == 12 {
        (year + 1, 1)
    } else {
        (year, month + 1)
    };

    let (cal1_weekday, cal1_lastday) = MONTHS.get(&(year, month)).unwrap();
    let (cal2_weekday, cal2_lastday) = MONTHS.get(&(year2, month2)).unwrap();

    vec![
        vec![" ".repeat(33)],
        calendar(year, month, *cal1_weekday, *cal1_lastday, day),
        vec![" ".repeat(33)],
        calendar(year2, month2, *cal2_weekday, *cal2_lastday, 999),
        vec![" ".repeat(33)],
    ].concat()
}

// weekday: 0 for Sunday, 6 for Saturday
fn calendar(year: usize, month: usize, first_weekday: usize, last_day: usize, today: usize) -> Vec<String> {
    let mut result = vec![
        format!("             {}.{:02}             ", year, month),
        format!("{}  MON  TUE  WED  THU  FRI  SAT", "SUN".green())
    ];

    let mut curr_day = 1;
    let mut curr_weekday = 0;
    let mut curr_line = Vec::with_capacity(7);

    while curr_day <= last_day {
        let width = if curr_weekday == 0 { 3 } else { 5 };

        if curr_weekday < first_weekday && curr_day == 1 {
            curr_line.push(format!("{:width$}", ""));
            curr_weekday += 1;
        }

        else {

            if curr_day == today {
                curr_line.push(format!(
                    "{}{}",
                    format!("{:1$}", " ", width - curr_day.to_string().len()),
                    format!("{}", curr_day.to_string().on_yellow().black())
                ));
            }

            else if curr_weekday == 0 || HOLIDAYS.contains(&(month, curr_day)) {
                curr_line.push(format!("{:>width$}", curr_day.to_string().green()));
            }

            else {
                curr_line.push(format!("{:>width$}", curr_day));
            }

            curr_day += 1;
            curr_weekday += 1;
        }

        if curr_weekday == 7 {
            result.push(curr_line.join(""));
            curr_weekday = 0;
            curr_line = Vec::with_capacity(7);
        }

    }

    if curr_line.len() > 0 {

        while curr_line.len() < 7 {
            curr_line.push("     ".to_string());
        }

        result.push(curr_line.join(""));
    }

    #[cfg(test)] assert!(result.iter().all(|line| line.len() == 33));

    result
}

use std::collections::{HashSet, HashMap};

lazy_static::lazy_static! {

    pub static ref HOLIDAYS: HashSet<(usize, usize)> = {
        vec![
            (1, 1),
            (3, 1),
            (5, 5),
            (6, 6),
            (8, 15),
            (10, 3),
            (10, 9),
            (12, 25),
        ].into_iter().collect()
    };

    pub static ref MONTHS: HashMap<(usize, usize), (usize, usize)> = {  // <(year, month), (weekday, lastday)>
        let mut result = HashMap::with_capacity(12);

        result.insert((2023, 5), (1, 31));
        result.insert((2023, 6), (4, 30));
        result.insert((2023, 7), (6, 31));
        result.insert((2023, 8), (2, 31));
        result.insert((2023, 9), (5, 30));
        result.insert((2023, 10), (0, 31));
        result.insert((2023, 11), (3, 30));
        result.insert((2023, 12), (5, 31));
        result.insert((2024, 1), (1, 31));
        result.insert((2024, 2), (4, 29));
        result.insert((2024, 3), (5, 31));
        result.insert((2024, 4), (1, 30));

        result
    };

    pub static ref NOW: (usize, usize, usize, String, usize, usize, usize) = {  // (year, month, day, weekday, hour. minute, second)
        let now = h_time::Date::now();
        let weekdays = [
            "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"
        ];

        (now.year as usize, now.month as usize, now.m_day as usize, weekdays[now.w_day as usize].to_string(), now.hour as usize, now.minute as usize, now.second as usize)
    };
}
