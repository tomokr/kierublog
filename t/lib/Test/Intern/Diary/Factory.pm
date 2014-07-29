package Test::Intern::Diary::Factory;

use strict;
use warnings;
use utf8;

use Exporter::Lite;
our @EXPORT = qw(
    create_user
);

use String::Random qw(random_regex);

use Intern::Diary::Util;
use Intern::Diary::DBI::Factory;
use Intern::Diary::Util::now;

# ランダムなユーザを作成する
sub create_user (%) {
    my (%args) = @_;
    my $name    = $args{name} // random_regex('\w{30}');
    my $created = $args{created} // Intern::Diary::Util::now;

    my $dbh = Intern::Diary::DBI::Factory->new->dbh('hatena_newbie');

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
    }, 'Intern::Diary::Model::User');
}

1;
