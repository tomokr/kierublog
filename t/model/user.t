package t::Intern::Bookmark::Model::User;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use Test::Intern::Bookmark;

use Test::More;

use parent 'Test::Class';

use Intern::Bookmark::Util;

sub _use : Test(startup => 1) {
    my ($self) = @_;
    use_ok 'Intern::Bookmark::Model::User';
}

sub _accessor : Test(3) {
    my $now = Intern::Bookmark::Util::now;
    my $user = Intern::Bookmark::Model::User->new(
        user_id => 1,
        name    => 'user_name',
        created => $now,
    );
    is $user->user_id, 1;
    is $user->name, 'user_name';
    is $user->created->epoch, $now->epoch;
}

__PACKAGE__->runtests;

1;
