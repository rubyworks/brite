# Brite

A Shiny Static Website Generator

[Homepage](http://rubyworks.github.com/brite) /
[Documentation](http://rubydoc.info/gems/brite/frames) /
[Report Issue](http://github.com/rubyworks/brite/issues) /
[Development](http://github.com/rubyworks/brite) /
[Mailing List](http://groups.google.com/group/rubyworks-mailinglist)

[![Brite](http://travis-ci.org/rubyworks/brite.png)](http://travis-ci.org/rubyworks/brite)


## DESCRIPTION

Brite is an innovative static website/blog generation utility
which is as easy to use as it is versatile.


## FEATURES

* Site layout is 100% user-defined.
* Can generate files in place, so no "special directories" are required.
* Or templated routes can customize the site organization. 
* Supports multi-format templates via Neapolitan template engine.
* Which supports many markup and templating formats via Malt or Tilt.


## SYNOPSIS

Very briefly, one creates `.page`, `.post`, `.part` and `.layout` files and 
then runs:

    $ brite

Voila, website made!

Of course, the question really is: how does one go about creating `.page`,
`.post`, `.part`, and `.layout` files and such. For information about that see the
[Brite website](https://rubyworks.github.com/brite) and see the
[Getting Started Tutorial](https://github.com/rubyworks/brite/wiki/Getting-Started).

For a quick start, have a look at the [brite-site repository](https://github.com/rubyworks/brite-site),
which contains a generic Brite project anyone can use to start their own Brite Site.

To get further under the hood, see Brite source code in the
[GitHub hosted repository](http://github.com/rubyworks/brite)
and read the [API documentation](http://rubydoc.info/gems/brite/frames).


## HOW TO INSTALL

### RubyGems

  $ gem install brite

### Setup.rb

If you are old fashioned and want to install to a site location,
see [Setup.rb](http://rubyworks.github.com/setup).


## COPYRIGHTS

Copyright (c) 2009 Rubyworks

Brite is distributable in accordance with the *BSD-2-Clause* license.

See LICENSE.md file for details.
