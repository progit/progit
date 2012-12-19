[![Build Status](https://secure.travis-ci.org/progit/progit.png?branch=master)](https://travis-ci.org/progit/progit)

# Pro Git Book Contents

This is the source code for the Pro Git book contents.  It is licensed under
the Creative Commons Attribution-Non Commercial-Share Alike 3.0 license.  I
hope you enjoy it, I hope it helps you learn Git, and I hope you'll support
Apress and me by purchasing a print copy of the book at Amazon:

http://tinyurl.com/amazonprogit

# Making Ebooks

On Fedora you can run something like this::

    $ yum install ruby calibre rubygems ruby-devel rubygem-ruby-debug 
    $ gem install rdiscount
    $ makeebooks en  # will produce a mobi

On MacOS you can do like this::
	
1. INSTALL ruby and rubygems
2. `$ gem install rdiscount`
3. DOWNLOAD Calibre for MacOS and install command line tools
4. `$ makeebooks zh` #will produce a mobi

# Errata

If you see anything that is technically wrong or otherwise in need of
correction, please [open an issue](https://github.com/progit/progit/issues) and one of the maintainers will take a look.


# Translation

If you wish to translate the book, your work will be put up on the 
git-scm.com site.  Please put your translation into the appropriate
subdirectory of this project, using the 
[ISO 639](http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) 
and send a pull request. Be careful to use UTF-8 encoding in your files.

