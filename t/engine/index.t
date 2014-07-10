package t::Intern::Bookmark::Engine::Index;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent 'Test::Class';

use Test::Intern::Bookmark;
use Test::Intern::Bookmark::Mechanize;

sub _get : Test(3) {
    my $mech = create_mech;
    $mech->get_ok('/');
    $mech->title_is('Intern::Bookmark');
    $mech->content_contains('Intern-Bookmark');
}

__PACKAGE__->runtests;

1;
