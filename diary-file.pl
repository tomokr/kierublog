#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;

use FindBin; #ライブラリ探索用
use lib "$FindBin::Bin/lib", glob "$FindBin::Bin/modules/*/lib";
use Encode;
use File::Slurp; #ファイルの読み書き用
use DateTime;
use File::Temp; #外部エディタで編集したファイルをよみこむ用
use Path::Class; #上に同じ

use Intern::Diary::Model::Entry; #日記のひな形
use Intern::Diary::Service::Entry;
use Intern::Diary::Model::Parse;


my %HANDLERS = (
    add => \&add_diary,
    list => \&list_diary,
    edit => \&edit_diary,
    delete => \&delete_diary,
);

my $command = shift @ARGV;
my $handler = $HANDLERS{ $command };
$handler->(@ARGV);

sub add_diary{

    my ($title) = @_;
    die 'title required' unless defined $title; #タイトル必要
    #入力
    print "Text:";
    my $text = <STDIN>;
    chomp($text);

    #入力からエントリを作成
    my $diary = Intern::Diary::Service::Entry->create_entry($title,$text);

    #ファイルにltsvにして書き込む
    my $diary_ltsv = Intern::Diary::Model::Parse->generate_ltsv_by_hashref($diary);
    File::Slurp::write_file("data.ltsv", {append => 1}, $diary_ltsv);
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

diary-file.pl - コマンドラインで日記を書くためのツール。データはファイルに書き込みます。

=head1 SYNOPSIS

  $ ./diary-file.pl [action] [argument...]

=head1 ACTIONS

=head2 C<add>

  $ diary-file.pl add [title]

日記に記事を書きます。

=head2 C<list>

  $ diary-file.pl list

日記に投稿された記事の一覧を表示します。

=head2 C<edit>

  $ diary-file.pl edit [entry ID]

指定したIDの記事を編集します。

=head2 C<delete>

  $ diary-file.pl delete [entry ID]

指定したIDの記事を削除します。

=cut
