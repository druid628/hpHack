#!/usr/bin/env ruby -wKU

require 'socket'

unless ARGV.length == 2
  puts "Usage: hp.rb hostname message"
  exit
end

hostname, message = ARGV[0..1]

puts "hp.rb: homage to l0pht's hp.c"
puts "-----------------------------"
puts "Hostname: #{hostname}"
puts "Message : #{message}"
puts ""

send_string = "\033%-12345X@PJL RDYMSG DISPLAY = \"#{message[0...44]}\"\r\n\033%-12345X\r\n"

socket = TCPSocket.open(hostname, 9100)
bytes_sent = socket.send(send_string,0)
puts "Sent #{bytes_sent} bytes"
socket.close

