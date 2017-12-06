# (c) goose121, 2017
# Released under the MIT license

use v5.10.1;
use feature "switch";
my $type = "simple";
my @cmds_start = ();
my @cmds_stop = ();
my $pidfile = "";
my $desc = "";

while(<>) {
    #s/\s*|\s*$//g; # Trim whitespace
    if (m/^Type\s*=\s*(.*)/) {
        $type=$1;
    }
    if (m/^ExecStart\s*=\s*(.*)/) {
        if (length $1) {
            push(@cmds_start, $1);
        }
        else {
            @cmds_start = (); # If the line is "ExecStart=",
                              # it means to clear ExecStart.
        }
    }
    if (m/^ExecStop\s*=\s*(.*)/) {
        if (length $1) {
            push(@cmds_stop, $1);
        }
        else {
            @cmds_stop = (); # If the line is "ExecStop=",
                             # it means to clear ExecStop.
        }
    }
    if (m/^PIDFile=(.*)/) {
        if(length $1) {
            $pidfile = $1;
        }
    }
    if (m/^Description=(.*)/) {
	$desc = $1
    }
}

my @cmds;

my @cmd_path;
my @cmd_argl;

map {my @sep = split(/ /, $_, 2);
     push(@cmd_path, $sep[0]);
     push(@cmd_argl, $sep[1]);
} @cmds_start;

print <<"EOF";
\#!/sbin/openrc-run

command=$cmd_path[0]
command_args="$cmd_argl[0]"
pidfile=$pidfile

name="(fill in)"
description="$desc"
EOF
