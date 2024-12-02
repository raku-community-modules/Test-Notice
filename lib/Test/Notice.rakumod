use Test;
# use Terminal::Width; # doesn't actually work under `prove`
constant AVERAGE_READING_SPEED_WPM = 184; # words per minute

sub notice (Str $message, Bool :$try-color = True) is export {
    my $color = (try require Terminal::ANSIColor) === Nil
        && {''} || ::('Terminal::ANSIColor::EXPORT::DEFAULT::&color');

    my $t-width = 80; #terminal-width;
    $t-width -= 2; # diag adds two chars
    $t-width = 10 if $t-width < 10;

    my $hr = '#' x $t-width;
    my $blank = '#' ~ ' ' x ($t-width - 2) ~ '#';
    diag join "\n",
        '', # <-- avoid shifted first line when noticing inside a subtest
        $color('bold red on_green') ~ $hr ~ $color('reset'),
        $color('bold blue on_green') ~ $hr ~ $color('reset'),
        $color('bold yellow on_green') ~ $hr ~ $color('reset'),
        $color('bold white on_black') ~ $blank,
        $color('bold white on_black') ~ $blank,
            to-lines($message, $t-width - 6)
                .map({$color('bold white on_black') ~ "#  $_  #"}),
        $color('bold white on_black') ~ $blank,
        $color('bold white on_black') ~ $blank,
        $color('bold yellow on_green') ~ $hr ~ $color('reset'),
        $color('bold blue on_green') ~ $hr ~ $color('reset'),
        $color('bold red on_green') ~ $hr ~ $color('reset');

    # Pause long enough for the person to read the message...
    # ...plus 1 second to notice it in the first place
    sleep 1 + $message.words / AVERAGE_READING_SPEED_WPM * 60
        unless %*ENV<NONINTERACTIVE_TESTING>;
}

my sub to-lines (Str $message, Int $line-length) {
    my @out;
    my @line;
    for $message.words -> $word {
        if @line.join(' ').chars + $word.chars > $line-length {
            if $word.chars >= $line-length {
                @out.append: @line.join(' '), $word;
                @line = ();
            }
            else {
                @out.push: @line.join: ' ';
                @line = $word;
            }
            next;
        }
        @line.push: $word;
    }
    @out.push: @line.join: ' ' if @line;

    # pad lines with whitespace so right "border" of the message is straight
    $_ ~= ' ' x ($line-length - .chars) for @out;

    @out
}

=begin pod

=head1 NAME

Test::Notice - Display noticeable messages to users during tests

=head1 SYNOPSIS

=begin code :lang<raku>

use Test::Notice;
notice 'Install Foo::Bar::Baz for extra awesome features!';

# Do not use colors
notice 'Now without colors!', :!try-color;

=end code

=head1 DESCRIPTION

This module lets you display highly visible messages to users during
the run of your test, pausing long enough for them to read it.

=head1 EXPORTED SUBROUTINES

=head2 notice( Str $message, Bool :$try-color = True )

=begin code :lang<raku>

notice 'Install Foo::Bar::Baz for extra awesome features!';

=end code

Takes one mandatory argument: the string to display in the message.
Does not return anything meaningful. The message will be coloured
if optional C<Terminal::ANSIColor> is installed.

The output also pauses long enough for an average reader to read
the entire message (regardless of its length), unless
C<NONINTERACTIVE_TESTING> environmental variable is set.

You can turn detection off the coloring module by setting
C<:try-color> to C<False>.

=head1 LIMITATIONS

The current implementation always assumes the terminal width of
80 characters.  If you can figure out how to get the actual width
when tests are run, patches are more than welcome.

Currently, any amount of whitespace in the displayed message will
be squashed into a single space.

=head1 AUTHOR

Zoffix Znet

=head1 COPYRIGHT AND LICENSE

Copyright 2016 - 2017 Zoffix Znet

Copyright 2020 - 2024 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
