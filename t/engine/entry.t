package t::Intern::Diary::Engine::Entry;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent 'Test::Class';

use Test::Intern::Diary;
use Test::Intern::Diary::Mechanize;
use Test::Intern::Diary::Factory;


sub _default : Test(2) {
    my $mech = create_mech;
    my $db = Intern::Diary::DBI::Factory->new;
    my $user = create_user;
    my $entry = create_entry( user_id => $user->id );
    $mech->get_ok('/entry?id='.$entry->id);
    $mech->content_contains($entry->title);
}

# sub list : Test(1){


# }
__PACKAGE__->runtests;

1;