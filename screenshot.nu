#!/home/baehyunsol/.cargo/bin/nu

let now = (date now | date to-table);
let dateint = (($now | get year | get 0) * 10000000000 + ($now | get month | get 0) * 100000000 + ($now | get day | get 0) * 1000000 + ($now | get hour | get 0) * 10000 + ($now | get minute | get 0) * 100 + ($now | get second | get 0));
let name = $"/home/baehyunsol/Pictures/($dateint).png";

import $name

echo $name
echo "done!"
