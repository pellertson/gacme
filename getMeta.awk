{
	$1 = ""
	split($0, chars, "")
	for (i = 2; i < length(chars); i++)
		printf("%s", chars[i])
}