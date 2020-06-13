# A Gemini Client for Acme

I use [the plan9port version of acme](https://9fans.github.io/plan9port/)
as my regular text editor.  Though just like emacs, acme can be much more
than an editor.

[Gemini](gopher://gemini.circumlunar.space) is an alternative to gopher
and the web, taking the best of both and putting it into one protocol.

None of the existing gemini clients out there are good enough for me to
want to use daily, so I am making my own.

This just uses standard POSIX tools and programs that were installed
by plan9port, so that makes the latter the only requirement.

## Install

These are just two shell scripts in this project, so you can just copy
them into your `$PATH`.

The url is `git://dome.circumlunar.space/~parker/gacme.git`

## TODO

* do proper TOFU authentication
* figure out plumbing rules for clicking on links
* publishing your own certs for servers that use them
* see about writing this in an actual programming language, possibly go