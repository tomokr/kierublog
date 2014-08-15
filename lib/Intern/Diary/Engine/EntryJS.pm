package Intern::Diary::Engine::EntryJS;

use strict;
use warnings;
use utf8;

sub default {

    my ($class, $c) = @_;
    $c->html('entry_js.html',{});
}

1;
__END__
