#!/usr/bin/gawk -f

BEGIN {
	print "HP Display hack in awk (gawk)"
	if (ARGC < 3) {
		print "Usage: hp.awk hostname message"
		exit 1
	}
	hostname = ARGV[1]
	message = ARGV[2]
	print "Hostname: " hostname
	print "Message:  " message
	print

	esc = sprintf("%c", 27)
	send_string = esc "%%-12345X@PJL RDYMSG DISPLAY = \"" substr(message, 1, 44) "\"\r\n" esc "%%-12345X\r\n"
	len = length(send_string) - 2
	net = "/inet/tcp/0/" hostname "/9100"
	printf(send_string) > net
	close(net)

	print "Sent " len " bytes"
}


