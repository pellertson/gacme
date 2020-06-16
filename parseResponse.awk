BEGIN {
	FS = " "
	mono = 0
	print hostname
	print path
}
# trying to turn any partial link into a fully qualified gemini link
function parse_link(link) {
	if (link ~ /^gemini:\/\/.*/) {
		return link
	} else if (link ~ /^\/\/.*.[a-zA-Z]\/.*/) {
		return "gemini:" link
	} else if (link ~ /^\/.*/) {
		return "gemini://" hostname link
	}
}

# format the link lines to look a little bit nicer
/^=>/ {
	str = "=>"
	if (mono) {
		print
	} else {
		if ($1 == str) {
			$1 = ""
			link = parse_link($2)
			$2 = ""
		} else {
			sub(/=>/, "")
			link = parse_link($1)
			$1 = ""
		}
		printf("%s\n=>\t%s\n", $0, link)
	}
	next
}

# make nice bullet points
/^\* / {
	if (mono) sub(/\*/, "•")
	print
	next
}

/```/ { (mono == 0) ? mono = 1 : mono = 0 }

# print the rest of the lines without any special formatting
# not sure if we need this line but its here just incase
{ print($0) }