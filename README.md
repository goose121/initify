# initify
This utility converts simple systemd services to OpenRC init-scripts.

## Usage

### initify
See

    initify.pl --help

### cronify

    cronify.pl [file]
    
Turns a systemd timer-file into a `cron` timespec

## TODO

- Handle the targets which directly map to OpenRC runlevels
- ~~Convert systemd timers to crontab entries~~
