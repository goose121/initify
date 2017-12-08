# initify
This utility converts simple systemd services to OpenRC init-scripts.

## Usage
    initify.pl [filename]

NOTE: The service name will initially be `(fill in)`. This is due to the ability to pipe service-files from `stdin`, as well
as the lack of a service-name field in systemd services. 

## TODO

- Handle the targets which directly map to OpenRC runlevels
- Convert systemd timers to crontab entries
