package Intern::Diary::Service::DB::Entry;

use strict;
use warnings;
use utf8;

use Carp;
use Encode;

use Intern::Diary::Util;

sub create {
    my ($class, $db, $args) = @_;

    my $user_id = $args->{user_id} // croak 'user_id required';
    my $diary_title = $args->{diary_title} // croak 'diary_title required';
    my $diary_text = $args->{diary_text} // croak 'diary_text required';

    my $now = Intern::Diary::Util::now;

    $db->dbh('intern_diary')->query(q[
        INSERT INTO entry
          SET
            user_id  = :user_id,
            text = :diary_text,
            title = :diary_title,
            created  = :created,
            date  = :date
    ], {
        user_id  => $user_id,
        diary_title => encode_utf8 $diary_title,
        diary_text  => encode_utf8 $diary_text,
        created  => $now,
        date  => $now,
    });
}

sub delete_entry {
    my ($class, $db, $entry) = @_;

    $db->dbh('intern_diary')->query(q[
        DELETE FROM entry
          WHERE
            id = :id
    ], {
        id => $entry->id,
    });
}

sub find_entry_by_user_id_and_created {
    my ($class, $db, $args) = @_;

    my $user_id = $args->{user_id} // croak 'user_id required';
    my $created = $args->{created} // croak 'created required';

    $db->dbh('intern_diary')->select_row_as(q[
        SELECT * FROM entry
          WHERE
          user_id = :user_id AND
          created = :created
    ], {
        user_id => $user_id,
        created => $created,
    }, 'Intern::Diary::Model::Entry');
}

sub find_entries_by_user_id {
    my ($class, $db, $args) = @_;

    my $user_id = $args->{user_id} // croak 'user_id required';

    $db->dbh('intern_diary')->select_all_as(q[
        SELECT * FROM entry
          WHERE user_id = :user_id
    ], {
        user_id => $user_id,
    }, 'Intern::Diary::Model::Entry');
};

sub update_entry {
    my ($class, $db, $args) = @_;

    my $entry_id = $args->{entry_id} // croak 'entry_id required';
    my $title = $args->{title} // croak 'title required';
    my $text = $args->{text} // croak 'text required';

    $db->dbh('intern_diary')->query(q[
        UPDATE entry
          SET
            title = :title,
            text = :text,
            date = :date
          WHERE
            id = :entry_id
    ], {
        entry_id => $entry_id,
        title     => encode_utf8 $title,
        text     => encode_utf8 $text,
        date     => Intern::Diary::Util->now,
    });
}



1;
