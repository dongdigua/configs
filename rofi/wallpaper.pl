#! /usr/bin/perl
# just try some perl

$base_dir = "~/Pictures/wallpaper/";
@list = (
    "ocean-waves.jpg",
    "winter_mountain.jpg",
    "miku-wallpaper-modified.jpg",
    "centos7-bg.jpg",
    "crystal-water.jpg",
    "plain-flower.png",
    "beautiful-ocean.jpg",
    "Miku_Day_2020.png",
    "Miku_Winter.png",
    "Miku_Landscape.png",
    "centos9-motif.png",
    "Cardinali.jpg",
    "debian9-softwaves.png",
    "f38-day.jpg",
    "f26-dawn.png",
    "f26-day.png",
    "f26-dusk.png",
    "f26-night.png",
    "aurora.jpg",
    "nord-pixel-moon.png",
    "landscape-1216423.jpg",
);

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
    if ($_[0] ~~ @list) {
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
