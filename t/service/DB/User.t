package t::Intern::Diary::Service::DB::User;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use Test::Intern::Diary;
use Test::Intern::Diary::Factory;

use Test::More;
use Test::Deep;

use String::Random qw(random_regex);

use Intern::Diary::DBI::Factory;

#モジュールがrequireできるか
require_ok 'Intern::Diary::Service::DB::User';

#名前でユーザーがみつかるか
subtest 'find_user_by_name' => sub {

    my $db = Intern::Diary::DBI::Factory->new;
    my $created_user = create_user;
    my $user = Intern::Diary::Service::DB::User->find_user_by_name($db, {
            name => $created_user->name,
        });

    ok $user, 'userが引ける';
    isa_ok $user, 'Intern::Diary::Model::User', 'blessされている';
    is $user->name, $created_user->name, 'nameが一致する';
};

#idでユーザーを探せるか
subtest 'find_users_by_user_id' => sub {
        my $user_1 = create_user;
        my $db = Intern::Diary::DBI::Factory->new;

        my $users = Intern::Diary::Service::DB::User->find_users_by_user_ids($db, {
            user_ids => [$user_1->id],
        });

        is scalar @$users, 1, 'userがひとり';
        cmp_deeply $users, [$user_1], '内容が一致';
	};

#ユーザーをつくれるか
subtest 'ユーザー作成できる' => sub {
        my $name = random_regex('test_user_\w{15}');
        my $db = Intern::Diary::DBI::Factory->new;
        Intern::Diary::Service::DB::User->create($db, {
            name => $name,
        });

        my $dbh = $db->dbh('intern_diary');
        my $user = $dbh->select_row(q[
            SELECT * FROM user
              WHERE
                name = :name
        ], {
            name => $name,
        });
         ok $user, 'ユーザーできている';
        is $user->{name}, $name, 'nameが一致する';
    };

done_testing;
