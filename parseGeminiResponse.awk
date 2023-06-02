# Copyright © 2020 Parker Ellertson

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
	if (link ~ /(https?|gemini|gopher|finger):\/\/.*/ || link ~ /mailto:/) {
		return link
	} else if (link ~ /^\/\/.*/) {
		return "gemini:" link
	} else if (index(link, "/") == 1) {
		return "gemini://" hostname link
	} else if (index(link, "/") > 1 || !index(link, "/")) {
		return "gemini://" hostname "/" pathForRelativeLink() link
	} else { # generic catch-all for me to find any bugs that arise
		return link
	}
}

function printFormatedLine(line, pre) {
	if (pre == "") {
		formatedLine = line[1]
	} else {
		formatedLine = pre
	}

	for (i = 2; i <= length(line); i++) {
		word = line[i]
		if (length(word) + length(formatedLine) > width) {
			printf("%s\n", formatedLine)
			formatedLine = word
		} else {
			formatedLine = sprintf("%s %s", formatedLine, word)
		}
	}
	print(formatedLine)

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
		printFormatedLine(words, "•")
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
		printFormatedLine(words, "")
	}
}