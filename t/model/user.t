package t::Intern::Diary::Model::User;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use Test::More;

#モジュールがrequireできるか
require_ok 'Intern::Diary::Model::User';

#accessorテスト
subtest '_accessor' => sub {

    my $user = Intern::Diary::Model::User->new(
        id => '1234',
        name => 'doughnutomo',

    );
    is $user->id, '1234';
    is $user->name, 'doughnutomo';

};


done_testing;