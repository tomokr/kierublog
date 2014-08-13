#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;

use FindBin; #ライブラリ探索用
use lib "$FindBin::Bin/lib", glob "$FindBin::Bin/modules/*/lib";
use Intern::Diary::DBI::Factory;
use Intern::Diary::Model::User;
use Intern::Diary::Model::Entry;
use Intern::Diary::Service::DB::Entry;
use Intern::Diary::Service::DB::User;

my %HANDLERS = (
    add => \&add_diary,
    list => \&list_diary,
    edit => \&edit_diary,
    delete => \&delete_diary,
);

my $command = shift @ARGV;

my $db = Intern::Diary::DBI::Factory->new;

my $name = $ENV{USER};
my $user = Intern::Diary::Service::DB::User->find_user_by_name($db, +{ name => $name });
unless ($user) {
    $user = Intern::Diary::Service::DB::User->create($db, +{ name => $name });
}

my $handler = $HANDLERS{ $command };
$handler->($user, @ARGV);

sub add_diary{

    my ($class, $title) = @_;
    die 'title required' unless defined $title; #タイトル必要
    #入力
    print "Text:";
    my $text = <STDIN>;
    chomp($text);

    #入力からエントリを作成
    my $entry = Intern::Diary::Model::Entry->new(
    diary_title => $title,
    diary_text => $text,
    user_id => $user->id
    	);

    #エントリをDBに書き込む
    Intern::Diary::Service::DB::Entry->create_entry($db, $entry);
    print "OK\n";

}

sub list_diary{
      my $entries =  Intern::Diary::Service::DB::Entry->find_entries_by_user_id($db, $user);
      foreach my $entry (@$entries){
        printf "id:%s title:%s text:%s\n",$entry->id, $entry->title, $entry->text;

      }

}


sub edit_diary{

    my ($class, $edit_id) = @_;
    die 'id required' unless defined $edit_id; #ID必要
    #my $does_id_exist = 0; #もし指定したidがなかったら？

    my $edit_entry = Intern::Diary::Model::Entry->new(
        id => $edit_id,
        );
    my $old_entry = Intern::Diary::Service::DB::Entry->find_entry_by_id($db, $edit_entry);
    printf "old_title:%s\n",$old_entry->title;
    print "new_title:";
    my $new_title = <STDIN>;
    chomp($new_title);
     printf "old_text:%s\n",$old_entry->text;
    print "new_text:";
    my $new_text = <STDIN>;
    chomp($new_text);

    $edit_entry->{title} = $new_title;
    $edit_entry->{text} = $new_text;

    Intern::Diary::Service::DB::Entry->update_entry($db, $edit_entry);

    # print "This ID does not exist!\n" if $does_id_exist == 0; #存在しないIDを指定した場合
    # print "Edited.\n" if $does_id_exist == 1;
    print "Edited.\n";
}

sub delete_diary{
    my ($class, $delete_id) = @_;
    die 'id required' unless defined $delete_id; #ID必要
  #  my $does_id_exist = 0; #もし指定したidがなかったら？
    my $delete_entry = Intern::Diary::Model::Entry->new(
        id => $delete_id,
        );
    Intern::Diary::Service::DB::Entry->delete_entry($db, $delete_entry);

    # print "This ID does not exist!\n" if $does_id_exist == 0; #存在しないIDを指定した場合
    # print "Deleted.\n" if $does_id_exist == 1;
    print "Deleted.\n";
}

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
