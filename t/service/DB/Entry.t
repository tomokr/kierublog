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
subtest 'create_entry' => sub {
        my $user = create_user;
        my $now = Intern::Diary::Util::now;

        my $db = Intern::Diary::DBI::Factory->new;
        Intern::Diary::Service::DB::Entry->create_entry($db, {
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

    Intern::Diary::Service::DB::Entry->delete_entry($db, $entry->id);

    my $deleted_entry = $db->dbh('intern_diary')->select_row(q[
        SELECT * FROM entry
          WHERE
            id  = :id
    ], {
        id  => $entry->id,
    });

    ok ! $deleted_entry, '消えている';

};

#find_entries_by_user_idのテスト
subtest 'find_entries_by_user_id' => sub {
	my $user = create_user;
    my $db = Intern::Diary::DBI::Factory->new;

    my $created_time = Intern::Diary::Util::now->add(seconds => 1);
    my $entry_1 = create_entry(user_id => $user->id, created => $created_time);
    my $entry_2 = create_entry(user_id => $user->id);

    my $entries = Intern::Diary::Service::DB::Entry->find_entries_by_user_id($db, $user->id);

    is scalar @$entries, 2;
    cmp_deeply [map { $_->user_id } @$entries], [$entry_1->user_id, $entry_2->user_id];

};

#update_entryのテスト
subtest 'update_entry' => sub {
	my $entry = create_entry;

#   is $bookmark->date, $bookmark->created, 'dateはcreatedと同じ';
#    sleep 1;

    my $db = Intern::Diary::DBI::Factory->new;

    my $edit_entry = Intern::Diary::Model::Entry->new(
        id => $entry->id,
        title => 'Updated title',
        text => 'Updated text'
        );


    Intern::Diary::Service::DB::Entry->update_entry($db, $edit_entry);

    my $updated_entry = $db->dbh('intern_diary')->select_row(q[
        SELECT * FROM entry
          WHERE
            id  = :id
    ], {
        id  => $entry->id,
    });

    ok $updated_entry;
    is $updated_entry->{title}, 'Updated title';
    is $updated_entry->{text}, 'Updated text';
#    isnt $updated_bookmark->{date}, $updated_bookmark->{created}, 'updatedが変わっている';

};


done_testing;