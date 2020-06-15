BEGIN {
	FS=" "
}
# trying to turn any partial url into a fully qualified gemini url
function parse_url(url) {
	if (index(url, "/") == 1) {
		return "gemini://" hostname url
	# TODO: fix bug involving this following if branch
	# this only works if the current url we're on is a "directory"
	# or more simply, it ends with a "/"
	# see gemini://gemini.conman.org/test/torture/0006
	} else if (index(url, "://") == 0) {
		return "gemini://" path url
	} else {
		return url
	}
}

function find_last_slash(path) {
	for (i = length(path); i > 0; i--) {
		if (path[i] == "/") {
			return i + 0
		}
	}
}

# format the link lines to look a little bit nicer
/^=>/ {
	str = "=>"
	if (mono == 1) {
		print
	} else {
		if ($1 == str) {
			$1 = ""
			url = parse_url($2)
			$2 = ""
		} else {
			sub(/=>/, "")
			url = parse_url($1)
			$1 = ""
		}
		printf("%s\n=>\t%s\n", $0, url)
	}
	next
}

# make nice bullet points
/^\* / {
	sub(/\*/, "•")
	print
	next
}

/```/ { (mono == 0) ? mono = 1 : mono = 0 }

# print the rest of the lines without any special formatting
# not sure if we need this line but its here just incase
{ print($0) }