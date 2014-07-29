package t::Hatena::Newbie::Model::User;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use Test::Hatena::Newbie;

use Test::More;

use parent 'Test::Class';

use Intern::Diary::Util;

sub _use : Test(startup => 1) {
    my ($self) = @_;
    use_ok 'Intern::Diary::Model::User';
}

sub _accessor : Test(3) {
    my $now = Hatena::Newbie::Util::now;
    my $user = Intern::Diary::Model::User->new(
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
