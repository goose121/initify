#!/bin/env perl

my @timestamps;

while(<>) {
    my @timestamp = ("*", "*", "*", "*", "*");
    if(m/OnCalendar=(.*)/) {
	if ($1 =~ /^(hourly|daily|monthly|yearly)$/) {
	    # Use cron's special strings for better readability
	    @timestamp = ('@' . "$1");
	} elsif ($1 =~ /minutely/) {
	    @timestamp = ("*", "*", "*", "*", "*");
	} elsif ($1 =~ /weekly/) {
	    # Systemd does weekly on Mondays, but cron
	    # does it on Sundays. We don't want unexpected
	    # behaviour, so we force cron to do it on Mondays
	    @timestamp = ("0", "0", "*", "*", "Mon");
	} elsif ($1 =~ /quarterly/) {
	    @timestamp = ("0", "0", "1,4,7,10", "1", "*");
	} elsif ($1 =~ /semianually/) {
	    @timestamp = ("0", "0", "1,7", "1", "*")
	} else {
	    my @sysd_date = split / /, lc $1;

	    # Regex which matches the first three letters of
	    # the day of the week
	    my $dotw = "(?|(mon|fri|sun)(?:day)?|(tue)(?:sday)?|(wed)(?:nesday)?|(thu)(?:rsday)?|(sat)(?:urday)?)";

	    my @ts_dotw = ("*");

	    if ($sysd_date[0] =~ /${dotw}(?:\.\.${dotw})?/i) {
		@ts_dotw = ();
		$days = shift @sysd_date;
		foreach $day (split /,/, $days) {
		    $day =~ m/(${dotw})(?:\.\.(${dotw}))?/;
		    print $2, "\n";
		    push @ts_dotw, (($1 == $2) ? "$1" : "$1-$2");
		}
	    }
	    
	    print @ts_dotw, "\n";
	    $timestamp[4] = join ",", @ts_dotw;
	    
	    $date = shift @sysd_date;
	    print $date, "\n";
	    $date =~ m/([0-9]{4}|\*)-([0-9]{1,2}|\*)-([0-9]{1,2}|\*)/;
	    if($1 != "*") {
		print STDERR "Warning: Ignoring non-'*' year field in timer\n";
	    }
	    $date =~ m/^([0-9]{4}|\*)-([0-9]{1,2}|\*)-([0-9]{1,2}|\*)$/;
	    $timestamp[2] = $2;
	    $timestamp[3] = $3;

	    $time = shift @sysd_date;
	    print $time, "\n";
	    $time =~ m/^([0-9]{1,2}):([0-9]{1,2})(?::([0-9]{1,2}))?$/;
	    if(int($3)) {
		print STDERR "Warning: Ignoring non-zero seconds field in timer\n";
	    }
	    $time =~ m/^([0-9]{1,2}):([0-9]{1,2})(?::([0-9]{1,2}))?$/;
	    $timestamp[0] = $1;
	    $timestamp[1] = $2;
	    print @timestamp, "\n";
	}
	push @timestamps, \@timestamp;
    }
}

foreach $timestamp (@timestamps) {
    print join " ", @$timestamp, "\n";
}
