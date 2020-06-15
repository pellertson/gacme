#!/bin/sh
# a gemini client written for acme
# i would use rc but i'm more comfortable with standard bourne shell script

foo=${1#gemini://}
domain=${foo%%/*}
path=${foo#/}

# BUG: this client will only connect to port 1965.
#  should be fine for most servers, but it should be fixed somehow
port=1965

get() {
	openssl s_client -crlf -quiet \
	                 -no_ssl3 -no_tls1 -no_tls1_1 \
	                 -connect $1:$2 -servername $1
}

echo $1 | get $domain $port | \
9 awk -F ' ' -v "hostname=$domain" -v "path=$path" '
	# trying to turn any partial url into a fully qualified gemini url
	function parse_url(url) {
		if (index(url, "/") == 1) {
			return "gemini://" hostname url
		# TODO: fix bug involving this following if branch
		# this only works if the current url we’re on is a "directory"
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
' | displayonacme $1
