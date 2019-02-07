#sift takes in a line of text and prints every credit card match found in it.
#for this assignment, each of the two lines contain only one match, but sift can find multiple matches per line.
def sift text
	matches = text.scan /%\w\d+\^\w+\/\w+\^\w+\?/
	matches.each do |match|
		$totalMatches += 1

		#slice! returns the first match and removes it from the string, so we can pull out data in order.
		#we start with the names. the first match will be the last name.
		lastName = match.slice! /[a-z]{2,}/i
		#once it is removed, the same slice! will return the first name.
		firstName = match.slice! /[a-z]{2,}/i
		puts "Name: #{firstName} #{lastName}"

		#as for the numbers, the card number comes first, then a large string of extra data.
		account = match.slice! /\d+/
		account.insert 12, ' '	#break into 4s for readability
		account.insert 8, ' '
		account.insert 4, ' '
		puts "Card Number: #{account}"

		#the first 7 digits of extra data is formatted as yymmccv (year, month, 3 digit ccv)
		expYear = '20' + match.slice!(/\d{2}/)
		expMonth = match.slice! /\d{2}/
		puts "Expiration: #{expMonth}/#{expYear}"

		ccv = match.slice! /\d{3}/
		puts "CCV: #{ccv}\n\n"
	end
end

#program start!
$totalMatches = 0
file = File.open 'memorydump.dmp'
unless file.eof?
	file.each_line do |line|
	  sift line
	end
end

puts "A total of #{$totalMatches} track 1 records were found in the memory dump."