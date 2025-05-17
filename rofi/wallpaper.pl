#! /usr/bin/perl
# just try some perl

$base_dir = "/home/digua/Pictures/wallpaper/";
opendir(my $dh, $base_dir) || die "can't opendir $base_dir: $!";
@list = grep { !/^\.\.?$/ } readdir($dh);
closedir $dh;

$arg1 = $ARGV[0];
$arg2 = $ARGV[1];

sub cur_bg {
    $ps = `ps l | grep swaybg`;
    $ps =~ /wallpaper\/(.+) -m fill/;
    $1;
}

sub find_sock {
    $uid = `id -u`;
    chomp $uid;
    $sock = `ls /run/user/$uid/sway-ipc.*.sock`;
    chomp $sock;
    $sock;
}

sub do_bg {
    if (grep { $_ eq $_[0] } @list) {
        $sock = find_sock();
        system("swaymsg -s $sock output '* bg $base_dir$_[0] fill' >> /dev/null");
    }
}

if ($arg1 eq "-random") {
    while (true) {
        $random_one = @list[int(rand(scalar @list))];
        if (cur_bg() == $random_one) {
            do_bg($random_one);
            last;
        }
    }
}
elsif ($arg1 eq "-time") {
    # to work with cron
    if (cur_bg() =~ /day|dawn|dusk|night/) {
        do_bg("$`$arg2$'");
    }
}
else {
    foreach $w (@list) {
        if ($arg1 eq $w) {
            do_bg($w);
            print "$w\n"
        }
        else {
            print "$w\n"
        }
    }
}
