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

=head
sub update {
    my ($class, $db, $args) = @_;

    my $bookmark_id = $args->{bookmark_id} // croak 'bookmark_id required';
    my $comment = $args->{comment} // '';

    $db->dbh('intern_bookmark')->query(q[
        UPDATE bookmark
          SET
            comment = :comment,
            updated = :updated
          WHERE
            bookmark_id = :bookmark_id
    ], {
        bookmark_id => $bookmark_id,
        comment     => encode_utf8 $comment,
        updated     => Intern::Bookmark::Util->now,
    });
}

=cut

1;
