#!/usr/bin/perl -w

use IO::Socket;

if($#ARGV < 1) { die "Usage: hp.pl hostname message\n"; }
my $hostname = $ARGV[0];
my $message  = $ARGV[1];
my $send_string = chr(27)."%-12345X\@PJL RDYMSG DISPLAY = \"".substr($message,0,44)."\"\r\n".chr(27)."%-12345X\r\n";

print "hp.pl: HP Display hack in perl\n";
print "Hostname: $hostname\n";
print "Message:  $message\n";

my $socket = IO::Socket::INET->new("$hostname:9100");
my $bytes_sent = $socket->send($send_string);
print "Send $bytes_sent bytes\n";

