package Intern::Diary::Engine::Entry;

use strict;
use warnings;
use utf8;

use Intern::Diary::Service::Entry;


sub default {
    my ($class, $c) = @_;

=head
    my $url = $c->req->parameters->{url};

    my $entry = Intern::Bookmark::Service::Entry->find_entry_by_url($c->db, {
        url => $url,
    });
    my $bookmarks = Intern::Bookmark::Service::Bookmark->find_bookmarks_by_entry(
        $c->db,
        { entry => $entry },
    );
    Intern::Bookmark::Service::Bookmark->load_user($c->db, $bookmarks);

    $c->html('bookmark.html', {
        entry     => $entry,
        bookmarks => $bookmarks,
    });
=cut
}


1;