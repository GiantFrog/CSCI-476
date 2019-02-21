#https://github.com/danielmiessler/SecLists/tree/master/Passwords

require 'digest'

#try to load the dictionary file
begin
	dictionaryFile = File.open 'dictionary.txt'
rescue
	puts 'Couldn not find dictionary.txt! Aborting.'
	return
end

dictionary = Array.new
hashes = ['6f047ccaa1ed3e8e05cde1c7ebc7d958', '275a5602cd91a468a0e10c226a03a39c', 'b4ba93170358df216e8648734ac2d539',
					'dc1c6ca00763a1821c5af993e0b6f60a', '8cd9f1b962128bd3d3ede2f5f101f4fc', '554532464e066aba23aee72b95f18ba2']

#load all the passwords from the dictionary into memory
#TODO some of these files are really big, can I even load them?
unless dictionaryFile.eof?
	dictionaryFile.each_line do |line|
	  dictionary << line.chomp
	end
	puts 'Dictionary loaded!'
else
	puts 'The dictionary is empty and could not be loaded.'
	return
end

#iterate through each hash we are trying to crack
hashes.each do |hash|
	puts "\nHash: #{hash}"
	found = false
	start = Time.now
	#check the hash we are on against hashes of passwords from the dictionary until we find a match.
	dictionary.each do |password|
	  if (Digest::MD5.hexdigest password).eql? hash
			finish = Time.now
			puts "Password: #{password}"
			puts "Password discovered in #{finish - start} seconds."
			found = true
			break
		end
	end
	#when we get here, we've either found a match or exhausted all our options.
	#print the disappointment if no match was found.
	unless found
		finish = Time.now
		puts 'The password could not be found.'
		puts "#{finish - start} seconds have elapsed."
	end
end