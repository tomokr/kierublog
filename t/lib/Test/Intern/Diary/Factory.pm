package Test::Intern::Diary::Factory;

use strict;
use warnings;
use utf8;

use Exporter::Lite;
our @EXPORT = qw(
    create_user
);

use String::Random qw(random_regex);

use Intern::Diary::Service::DB::User;

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
