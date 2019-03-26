#Reads a PCAP file and searches for any potential SYN attacks.
#by Jay Van Alstyne. packetfu can be installed with 'gem install packetfu'
require 'packetfu'	#https://github.com/packetfu/packetfu

#let's load up a pcap file. use the first arg if supplied, otherwise prompt for the file.
if ARGV.size < 1
	puts 'Please specify the name of the file to load.'
	filename = gets.chomp
else
	filename = ARGV[0]
end

#try to read packets in from the specified file.
begin
	packets = PacketFu::PcapFile.read_packets filename
	puts 'Packets loaded!'
rescue
	puts "The file #{filename} could not be read!"
	return 1
end

#these will store tallies for each IP address we come across. defaults to 0 for IPs with no entry.
synSent = Hash.new 0
synAckReceived = Hash.new 0

#iterate over every packet read and tally up the ones with a syn flag.
packets.each do |packet|
	if packet.is_tcp? && packet.tcp_flags.syn == 1		#tcp packet w/ a syn flag
		if packet.tcp_flags.ack == 1		#syn + ack
			synAckReceived[packet.ip_daddr.to_sym] += 1
		else		#syn, no ack
			synSent[packet.ip_saddr.to_sym] += 1
		end
	end
end

#iterate through every device's tallies.
#print their IP if they have sent 3x as many syn packets as they have received syn + ack packets.
attackFound = false
synSent.each do |key, value|
	synAckTally = synAckReceived[key]
	if value >= 3*synAckTally
		puts "#{key} has sent #{value} packets, but has only received #{synAckTally} responses."
		attackFound = true
	end
end
unless attackFound
	puts 'No SYN attacks were detected in this traffic!'
end