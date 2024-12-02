[![Actions Status](https://github.com/raku-community-modules/Test-Notice/actions/workflows/linux.yml/badge.svg)](https://github.com/raku-community-modules/Test-Notice/actions) [![Actions Status](https://github.com/raku-community-modules/Test-Notice/actions/workflows/macos.yml/badge.svg)](https://github.com/raku-community-modules/Test-Notice/actions) [![Actions Status](https://github.com/raku-community-modules/Test-Notice/actions/workflows/windows.yml/badge.svg)](https://github.com/raku-community-modules/Test-Notice/actions)

NAME
====

Test::Notice - Display noticeable messages to users during tests

SYNOPSIS
========

```raku
use Test::Notice;
notice 'Install Foo::Bar::Baz for extra awesome features!';

# Do not use colors
notice 'Now without colors!', :!try-color;
```

DESCRIPTION
===========

This module lets you display highly visible messages to users during the run of your test, pausing long enough for them to read it.

EXPORTED SUBROUTINES
====================

notice( Str $message, Bool :$try-color = True )
-----------------------------------------------

```raku
notice 'Install Foo::Bar::Baz for extra awesome features!';
```

Takes one mandatory argument: the string to display in the message. Does not return anything meaningful. The message will be coloured if optional `Terminal::ANSIColor` is installed.

The output also pauses long enough for an average reader to read the entire message (regardless of its length), unless `NONINTERACTIVE_TESTING` environmental variable is set.

You can turn detection off the coloring module by setting `:try-color` to `False`.

LIMITATIONS
===========

The current implementation always assumes the terminal width of 80 characters. If you can figure out how to get the actual width when tests are run, patches are more than welcome.

Currently, any amount of whitespace in the displayed message will be squashed into a single space.

AUTHOR
======

Zoffix Znet

COPYRIGHT AND LICENSE
=====================

Copyright 2016 - 2017 Zoffix Znet

Copyright 2020 - 2024 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

