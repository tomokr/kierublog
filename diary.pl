#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumoer;

use Intern::diary::DBI::Factory;
use Intern::Diary::Service::DB::User;

my %HANDLERS = (
    add => \&add_diary,
    list => \&list_diary,
    edit => \&edit_diary,
    delete => \&delete_diary,
);

my $command = shift @ARGV;

my $db = Intern::Bookmark::DBI::Factory->new;

my $name = $ENV{USER};
my $user = Intern::Diary::Service::DB::User->find_user_by_name($db, +{ name => $name });
unless ($user) {
    $user = Intern::Diary::Service::DB::User->create($db, +{ name => $name });
}

my $handler = $HANDLERS{ $command };
$handler->(@ARGV);




__END__

=head1 NAME

diary.pl - コマンドラインで日記を書くためのツール。データはデータベースに書き込みます。

=head1 SYNOPSIS

  $ ./diary.pl [action] [argument...]

=head1 ACTIONS

=head2 C<add>

  $ diary.pl add [title]

日記に記事を書きます。

=head2 C<list>

  $ diary.pl list

日記に投稿された記事の一覧を表示します。

=head2 C<edit>

  $ diary.pl edit [entry ID]

指定したIDの記事を編集します。

=head2 C<delete>

  $ diary.pl delete [entry ID]

指定したIDの記事を削除します。

=cut
