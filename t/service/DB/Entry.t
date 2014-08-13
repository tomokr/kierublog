package t::Intern::Diary::Service::DB::Entry;

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

use Intern::Diary::Util;

#モジュールがrequireできるか
require_ok 'Intern::Diary::Service::DB::Entry';

#createメソッドのテスト
subtest 'create' => sub {
        my $user = create_user;
        my $now = Intern::Diary::Util::now;

        my $db = Intern::Diary::DBI::Factory->new;
        Intern::Diary::Service::DB::Entry->create($db, {
             user_id => $user->id,
             diary_text => 'texttext',
             diary_title => 'titletitle',
        });

        my $dbh = $db->dbh('intern_diary');
        my $diary = $dbh->select_row(q[
         SELECT * FROM entry
          WHERE
            user_id  = :user_id AND
            created = :created
    ], {
        user_id  => $user->id,
        created  => $now,
    });
         ok $diary, 'エントリできている';
        is $diary->{user_id}, $user->{id}, 'user_idが一致する';
    };

#deleteメソッドのテスト
subtest 'delete' => sub {
	my $entry = create_entry;

    my $db = Intern::Diary::DBI::Factory->new;

    Intern::Diary::Service::DB::Entry->delete_entry($db, $entry);

    my $deleted_entry = $db->dbh('intern_diary')->select_row(q[
        SELECT * FROM entry
          WHERE
            id  = :id
    ], {
        id  => $entry->id,
    });

    ok ! $deleted_entry, '消えている';

};

done_testing;