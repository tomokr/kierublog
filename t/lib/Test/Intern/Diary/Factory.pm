package Test::Intern::Diary::Factory;

use strict;
use warnings;
use utf8;

use Exporter::Lite;
our @EXPORT = qw(
    create_user
    create_entry
);

use String::Random qw(random_regex);

use Intern::Diary::Service::DB::User;
use Intern::Diary::Service::DB::Entry;
use Intern::Diary::Util;

sub create_user {
    my %args = @_;
    my $name = $args{name} // random_regex('test_user_\w{15}');

    my $db = Intern::Diary::DBI::Factory->new;
    my $dbh = $db->dbh('intern_diary');
    $dbh->query(q[
        INSERT INTO user
          SET name = :name
    ], {
        name    => $name,
    });

    return Intern::Diary::Service::DB::User->find_user_by_name($db, { name => $name });
}

sub create_entry {
    my %args = @_;
    my $user_id    = $args{user_id}    // create_user();
    my $diary_text = $args{diary_text} // random_regex('\w{50}');
    my $diary_title = $args{diary_title} // random_regex('\w{50}');
    my $created = $args{created} // Intern::Diary::Util::now;
    my $date = $args{date} // Intern::Diary::Util::now;

    my $db = Intern::Diary::DBI::Factory->new;
    my $dbh = $db->dbh('intern_diary');
    $dbh->query(q[
        INSERT INTO entry
          SET user_id  = :user_id,
              text = :diary_text,
              title  = :diary_title,
              created  = :created,
              date  = :date
    ], {
        user_id  => $user_id,
        diary_text  => $diary_text,
        diary_title => $diary_title,
        created  => $created,
        date  => $date,
    });

    my $diary = Intern::Diary::Service::DB::Entry->find_entry_by_user_id_and_created(
        $db,
        { user_id => $user_id, created => $created },
    );

    return $diary;
}


1;
