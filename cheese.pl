#!/usr/bin/perl

# cheese.pl
# by Steven B. 2007/04/01
# based on a script by:
# Yaakov

use strict;
use warnings;

sub I_am_interactive { return -t STDIN && -t STDOUT; }

my $random_number = int(rand(4));
if ($random_number == 2)
{
print “Hit on number $random_number, exiting..\n” if I_am_interactive();
exit;
}
my $sleep_time = int(rand(2400));
if ($ARGV[0]) { $sleep_time = 0; }
print “Sleeping for: $sleep_time seconds\n” if I_am_interactive();
sleep($sleep_time);

my @sayings =
(
“Insert Coin”,
“Insert Cheese”,
“Im Sad..”,
“”,
“Low Monkeys”,
“Insert Monkeys”,
“Insert Butter & Jam”,
“Free The Ink!!”,
“My Cousin Is A Toaster”,
“Load Soy Latte”,
“”,
“Paper Tastes Funny Today”,
“Free Hugs..”,
“**** CBM BASIC V2 ****\n3583 BYTES FREE\nREADY.”,
“Toner Tastes Funny Today”,
“”,
“Press OK Button for Pacman”,
“Flower Power Mode”,
“Incoming Fax…”,
“Cheese Mode”,
“”,
);

# put your network printer IPs here.
my @ips = (”10.46.15.31″,”10.46.15.32″,”10.46.15.33″);

foreach my $ip (@ips)
{

my $peeraddr = $ip;
my $rdymsg = $sayings[rand @sayings];
chomp $peeraddr;

if ($ARGV[0]) { print “clearing…\n”; $rdymsg = “”; }

print “Going to contact IP: $ip\n” if I_am_interactive();
print “Going to send: $rdymsg\n” if I_am_interactive();

use IO::Socket;
my $socket = IO::Socket::INET->new(
PeerAddr => $peeraddr,
PeerPort => “9100″,
Proto => “tcp”,
Type => SOCK_STREAM
) or die “Could not create socket: $!”;

my $data = <<EOJ
\e%-12345X\@PJL JOB
\@PJL RDYMSG DISPLAY=”$rdymsg”
\@PJL EOJ
\e%-12345X
EOJ
;

print $socket $data;
}
