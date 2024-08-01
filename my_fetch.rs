/*
I'm too lazy to make a new repo...

colored = "2.0.4"
lazy_static = "1.4.0"
sysinfo = "0.30.3"
battery = "0.7.8"
h_time = "0.1.0"
clearscreen = "2.0.1"
*/

use colored::*;
use sysinfo::*;
use std::fs::File;
use std::io::Read;
use std::process::Command;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let inte = args.len() > 1 && (args[1] == "-i" || args[1] == "--interactive");

    let mut prev = format!("{}\n{}", title().join("\n"), bottom().join("\n"));

    loop {
        println!("{prev}");

        if !inte { break; }

        prev = format!("{}\n{}", title().join("\n"), bottom().join("\n"));
        std::thread::sleep(std::time::Duration::from_millis(120));
        clearscreen::clear().unwrap();
    }
}

fn title() -> Vec<String> {
    vec![
        String::new(),
        format!("{}", "      ▛▀▚ ▗▄▖ ▞▀▚ ▌   ▖ ▖         ▗▄▖     ▜▌ ▘ ▗▄▖    ▌   ▗▖         ▖ ▖".red()),
        format!("{}", "      ▛▀▚ ▗▄▟ ▛▀▘ ▛▀▖ ▚▄▘ ▌ ▐ ▄▄  ▚▄▖ ▞▀▚ ▐▌   ▚▄▖    ▌   ▗▖ ▄▄  ▌ ▐ ▝▞ ".red()),
        format!("{}", "      ▙▄▞ ▚▄▞ ▚▄▞ ▌ ▌  ▐  ▚▄▞ ▌ ▌ ▗▄▞ ▚▄▞ ▐▙   ▗▄▞    ▙▄▄ ▐▌ ▌ ▌ ▚▄▞ ▞▝▖".blue()),
        format!("{}", "                      ▝▘                                                ".blue()),
        format!("{}", " ────────────────────────────────────┬───────────────────────────────────────"),
    ]
}

fn bottom() -> Vec<String> {
    let left = calendars();
    let right = vec![status(), vec!["".to_string()], load_memo()].concat();
    let mut lines = Vec::with_capacity(left.len().min(right.len()));

    for i in 0..left.len().min(right.len()) {
        lines.push(format!("  {}  │ {}", left[i], right[i]));
    }

    if left.len() > right.len() {
        for i in lines.len()..left.len().max(right.len()) {
            lines.push(format!("  {}  │", left[i]));
        }
    }

    else {
        for i in lines.len()..left.len().max(right.len()) {
            lines.push(format!("  {}  │ {}", " ".repeat(33),  right[i]));
        }
    }

    lines
}

fn status() -> Vec<String> {
    let mut sys = System::new();
    sys.refresh_cpu();
    sys.refresh_memory();

    let now = h_time::Date::now();
    let now_pretty = now_pretty();
    let birthday = h_time::Date::from_ymd(1999, 1, 20);
    let since_birth = now.duration_since(&birthday).into_days();

    let nu_version = if let Ok(proc) = Command::new("nu").arg("-v").output() {
        Some(String::from_utf8_lossy(&proc.stdout).to_string().strip_suffix("\n").unwrap().to_string())
    } else {
        None
    };
    let rust_version = if let Ok(proc) = Command::new("rustc").arg("--version").output() {
        Some(String::from_utf8_lossy(&proc.stdout).to_string().strip_suffix("\n").unwrap().to_string())
    } else {
        None
    };

    let res = vec![
        Some(format!("{}: {}.{:02}.{:02} ({}) {:02}:{:02}:{:02}", "Date".green(), now_pretty.0, now_pretty.1, now_pretty.2, now_pretty.3, now_pretty.4, now_pretty.5, now_pretty.6)),
        Some(format!("{}: {} days", "Since Birth".green(), since_birth)),
        Some(format!("{}: {} seconds", "Since Boot".green(), System::uptime())),
        Some(format!("{}: {}", "CPU".green(), sys.cpus()[0].brand())),
        Some(format!("{}: {} MB", "Memory".green(), sys.total_memory() >> 20)),
        get_disk().map(|res| format!("{}: {res}", "Disk".green())).ok(),
        get_battery().map(|res| format!("{}: {res}", "Battery".green())).ok(),
        System::long_os_version().map(|res| format!("{}: {res}", "Os".green())),
        nu_version.map(|res| format!("{}: {res}", "Nushell".green())),
        rust_version.map(|res| format!("{}: {res}", "Rust".green())),
        System::kernel_version().map(|res| format!("{}: {res}", "Kernel".green())),
    ];

    res.into_iter().filter_map(|s| s).collect()
}

fn load_memo() -> Vec<String> {
    let mut s = String::new();
    let mut lines = vec![format!("{}", "Memo".green())];

    match File::open("/Users/baehyunsol/Documents/fetch_memo.txt") {  // TODO: I don't want to hard-code `/home/baehyunsol`
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

fn get_disk() -> Result<String, ()> {
    let mut disks = Disks::new_with_refreshed_list();

    if disks.len() == 0 {
        return Err(());
    }

    disks.sort_by_key(|disk| u64::MAX - disk.available_space());

    // takes one with the biggest available space
    let disk = &disks[0];

    // MB
    let available = disk.available_space() >> 20;
    let total = disk.total_space() >> 20;
    let used = total - available;

    let fs = if let Some(s) = disk.file_system().to_str() {
        s.to_string()
    } else {
        String::from("Unknown")
    };

    Ok(format!(
        "{}, using {}.{} / {}.{} GB",
        fs,
        used >> 10, used % 1000 / 100,
        total >> 10, total % 1000 / 100,
    ))
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
    let now_pretty = now_pretty();
    let (year, month, day) = (now_pretty.0, now_pretty.1, now_pretty.2);
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
        format!("{}  MON  TUE  WED  THU  FRI  SAT", "SUN".green()),
    ];

    let mut curr_day = 1;
    let mut curr_weekday = 0;
    let mut curr_line = Vec::with_capacity(9);

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
    result.push(" ".repeat(33));  // bottom padding

    result
}

fn now_pretty() -> (usize, usize, usize, String, usize, usize, usize) {
    let now = h_time::Date::now();
    let weekdays = [
        "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"
    ];

    (now.year as usize, now.month as usize, now.m_day as usize, weekdays[now.w_day as usize].to_string(), now.hour as usize, now.minute as usize, now.second as usize)
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

        result.insert((2024, 2), (4, 29));
        result.insert((2024, 3), (5, 31));
        result.insert((2024, 4), (1, 30));
        result.insert((2024, 5), (3, 31));
        result.insert((2024, 6), (6, 30));
        result.insert((2024, 7), (1, 31));
        result.insert((2024, 8), (4, 31));
        result.insert((2024, 9), (0, 30));
        result.insert((2024, 10), (2, 31));
        result.insert((2024, 11), (5, 30));
        result.insert((2024, 12), (0, 31));

        result
    };
}
