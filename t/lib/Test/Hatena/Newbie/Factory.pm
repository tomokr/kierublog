package Test::Intern::Bookmark::Factory;

use strict;
use warnings;
use utf8;

use Exporter::Lite;
our @EXPORT = qw(
    create_user
);

use String::Random qw(random_regex);

use Intern::Bookmark::Util;
use Intern::Bookmark::DBI::Factory;
use Intern::Bookmark::Util::now;

# ランダムなユーザを作成する
sub create_user (%) {
    my (%args) = @_;
    my $name    = $args{name} // random_regex('\w{30}');
    my $created = $args{created} // Intern::Bookmark::Util::now;

    my $dbh = Intern::Bookmark::DBI::Factory->new->dbh('intern_bookmark');

    $dbh->query(q[
        INSERT INTO user
          SET name = :name,
              created = :created
    ], {
        name    => $name,
        created => $created,
    });

    return $dbh->select_row_as(q[
        SELECT * FROM user
          WHERE name = :name
    ], {
        name => $name
    }, "Intern::Bookmark::Model::User");
}

1;
