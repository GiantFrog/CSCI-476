#NOTE: Multithreading support requires the jruby interpreter! Otherwise, all threads will run on a single core.
#An example password dictionary can be found below.
#https://crackstation.net/crackstation-wordlist-password-cracking-dictionary.htm
#Whatever you use, rename it to dictionary.txt and make sure each entry is line-seperated!

require 'digest'

#takes in which hash to crack and prints the results.
def crack index
	hash = $hashes[index]
	found = false
	#try to load the dictionary file
	if File.exist? 'dictionary.txt'
		dictionary = File.open 'dictionary.txt'
	else
		puts 'Could not find dictionary.txt! Aborting.'
		return
	end

	start = Time.now
	#check the hash we are on against hashes of passwords from the dictionary until we find a match.
	dictionary.each_line do |line|
		line.chomp!
		if (Digest::MD5.hexdigest line).eql? hash
			finish = Time.now
			puts "\nHash: #{hash}"
			puts "Password discovered in #{finish - start} seconds."
			puts "Password: #{line}"
			found = true
			break
		end
	end
	#when we get here, we've either found a match or exhausted all our options.
	#print the disappointment if no match was found.
	unless found
		finish = Time.now
		puts "\nHash: #{hash}"
		puts "#{finish - start} seconds have elapsed."
		puts 'The password could not be found.'
	end
end

#program begins here!
$hashes = ['6f047ccaa1ed3e8e05cde1c7ebc7d958', '275a5602cd91a468a0e10c226a03a39c', 'b4ba93170358df216e8648734ac2d539',
					 'dc1c6ca00763a1821c5af993e0b6f60a', '8cd9f1b962128bd3d3ede2f5f101f4fc', '554532464e066aba23aee72b95f18ba2']
threads = Array.new($hashes.size)

#iterate through each hash we are trying to crack
$hashes.each_index do |index|
	threads[index] = Thread.new {crack(index)}
end

#wait for each thread to finish executing before terminating the program
threads.each do |thread|
	thread.join
end