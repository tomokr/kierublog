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

    #ファイルにltsvにして書き込む
    Intern::Diary::Service::DB::Entry->create_entry($db, $entry);
    print "OK\n";

}

sub list_diary{

      my $record = File::Slurp::read_file("data.ltsv");
      print $record;

}


sub edit_diary{

    my ($edit_id) = @_;
    die 'id required' unless defined $edit_id; #ID必要
    my $diary_ltsv = '';
    my $does_id_exist = 0;
    my @parsed_record = Intern::Diary::Model::Parse->parse_diary_ltsv_file("data.ltsv");
    my ($new_title, $diary_id, $entry, $new_text);
    $new_title = '';
    foreach (@parsed_record){ #空行があるとエラーがでる
        next unless defined $_->{diary_id};
        unless($_->{diary_id} eq $edit_id){#編集しようとしているidでなければ$diary_ltsvにくっつけていく
            $diary_ltsv .= Intern::Diary::Model::Parse->generate_ltsv_by_hashref($_);
            }else{
                #消そうとしているところの処理
             $entry = Intern::Diary::Service::Entry->edit_entry($_);
             $diary_ltsv .= Intern::Diary::Model::Parse->generate_ltsv_by_hashref($entry);
             $does_id_exist = 1;
         }
    }

    File::Slurp::write_file("data.ltsv", $diary_ltsv); #最後に全部ファイルに書き出す

    print "This ID does not exist!\n" if $does_id_exist == 0; #存在しないIDを指定した場合
    print "Edited.\n" if $does_id_exist == 1;
}

sub delete_diary{
    my ($delete_id) = @_;
    die 'id required' unless defined $delete_id; #ID必要
    my $does_id_exist = 0;
    my $diary_ltsv = '';

    ($diary_ltsv, $does_id_exist) = Intern::Diary::Service::Entry->delete_entry($delete_id);

    File::Slurp::write_file("data.ltsv", $diary_ltsv); #最後に全部ファイルに書き出す
    print "This ID does not exist!\n" if $does_id_exist == 0; #存在しないIDを指定した場合
    print "Deleted.\n" if $does_id_exist == 1;
}

## ハッシュからltsvへ ##
sub generate_ltsv_by_hashref {
    my ($hashref) = @_;
    my $fields = [ map { join ':', $_, $hashref->{$_} } sort (keys %$hashref) ];
    my $record = join("\t", @$fields) . "\n";
    return $record;
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
