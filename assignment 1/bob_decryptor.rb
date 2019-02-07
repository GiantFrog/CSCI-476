#use the key we built and translate the input, returning the result
def translate
	translated = ''
	$text.each_char do |char|
		if $translation[char.to_s.to_sym] == nil
			translated += char
		else
			translated += $translation[char.to_s.to_sym]
		end
	end
	return translated
end

def try_word word

end

#load the input text
file = File.open 'input.txt'
$text = ''
unless file.eof?
	file.each_line do |line|
		$text += line
	end
end
#set the words 'lyl' and 'm' to mean 'bob' and 'a'
$translation = { l: 'b', y: 'o', m: 'a', z: 'n', j: 'd', i: 'e', f: 'h', u: 's', v: 'r', s: 'u', e: 'i', x: 'p', p: 'x', k: 'c', b: 'l', r: 'v', o: 'y', h: 'f', c: 'k', a: 'm' , q: 'w', w: 'q', n: 'z', d: 'j'}

#make a guess for 'i' and 's,' then check that an 'is' exists in the text
puts translate