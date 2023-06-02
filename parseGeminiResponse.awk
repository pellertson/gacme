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
}

function pathForRelativeLink() {
	str = ""
	if (path == "" || path == "/") {
		return ""
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

/^=>/ {
	link = parseLink($2)
	sub($2, "")
	printf $0 "\n\t\t" link "\n\n"
	next
}

{print}