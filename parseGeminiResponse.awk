BEGIN {
	FS = " "
	mono = 0
}

function pathForRelativeLink() {
	str = ""
	if (path == "") {
		return "/"
	} else {
		len = split(path, parts, "/")
		for (i = 1; i < len; i++) {
			str = str parts[i] "/"
		}
		return str
	}
}


# trying to turn any partial link into a fully qualified gemini link
function parseLink(link) {
	if (link ~ /(https?|gemini|gopher|mailto|finger):\/\/.*/) {
		return link
	} else if (link ~ /^\/\/.*/) {
		return "gemini:" link
	} else if (index(link, "/") == 1) {
		return "gemini://" hostname link
	} else if (index(link, "/") > 1 || !index(link, "/")) {
		return "gemini://" hostname pathForRelativeLink() link
	} else { # generic catch-all for me to find any bugs that arise
		return link
	}
}

function foldLine(line, pre) {

}

function printFormatedLine(line, pre) {
	print line pre
}

/^=>/ {
	str = "=>"
	if (mono) {
		print
	} else {
		if ($1 == str) {
			$1 = ""
			link = parseLink($2)
			$2 = ""
		} else {
			sub(/=>/, "")
			link = parseLink($1)
			$1 = ""
		}
		printf("\n⇒%s\n⇒\t%s\n", $0, link)
	}
	next
}

/^\* / {
	if (!mono) {
		sub(/\*/, "•")
		split($0, words, " ")
		line = words[1]
		for (i = 2; i <= length(words); i++) {
			word = words[i]
			if (length(word) + length(line) > width) {
				printf("%s\n", line)
				line = word
			} else {
				line = sprintf("%s %s", line, word)
			}
		}
		print line
	} else print
	next
}

/^```/ {
	(mono == 0) ? mono = 1 : mono = 0
	print("```")
	next
}

{
	if (mono) {
		print
	} else {
		split($0, words, " ")
		line = words[1]
		for (i = 2; i <= length(words); i++) {
			word = words[i]
			if (length(word) + length(line) > width) {
				printf("%s\n", line)
				line = word
			} else {
				line = sprintf("%s %s", line, word)
			}
		}
		print line
	}
}