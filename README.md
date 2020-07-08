# A Gemini Client for Acme

I use [the plan9port version of acme](https://9fans.github.io/plan9port/)
as my regular text editor.  Though just like emacs, acme can be much more
than an editor.

[Gemini](https://gemini.circumlunar.space) is an alternative to gopher
and the web, taking the best of both and putting it into one protocol.

Using acme is fun.  And as much as I like using the mouse, I couldn't
stand the extra dependencies some of the graphical clients out there
for gemini. So I wrote my own for acme.

This just uses standard POSIX tools and programs that were installed
by plan9port, so that makes the latter the only requirement.

## Install

Just run `sudo make`.  I will possibly use `mk` in the future but it doesn't seem to be needed.

Finally, add the following to `$HOME/lib/plumbing`:

```
# gemini links without a path or port
type is text
data matches 'gemini://([a-zA-Z0-9_\-.]+[a-zA-Z0-9_@\-]+)/?'
plumb to web
plumb start gacme $0'/' $1 '/'

# gemini links without a path but with a port
type is text
data matches 'gemini://([a-zA-Z0-9_\-.]+[a-zA-Z0-9_@\-]+):([0-9]+)/?'
plumb to web
plumb start gacme $0'/' $1 '/' $2

# gemini links with a path but no port
type is text
data matches 'gemini://([a-zA-Z0-9_\-.]+[a-zA-Z0-9_@\-]+)/(.*)'
plumb to web
plumb start gacme $0 $1 $2

# gemini links with a path and a port
type is text
data matches 'gemini://([a-zA-Z0-9_\-.]+[a-zA-Z0-9_@\-]+):([0-9]+)/(.*)'
plumb to web
plumb start gacme $0 $1 $3 $2

include basic
```

## LICENSE

Licenced under the GNU GPL v3+

## TODO

* do proper TOFU authentication
* publishing your own certs for servers that use them

## BUGS

* Some sites won't connect due to the TLS certificate generateed.  Openssl
  is a bitch when it comes to TOFU authentication.  And `gnutls-cli` doesn't
  seem to understand the meaning of "Trust On **First Use**."

## CONTRIBUTING

My email is in the git logs.  Contact me there for any questions or contributions
that you might have.
