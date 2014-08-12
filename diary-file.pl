#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Data::Dumper;

#以下、bookmark-file.plを参考にして書いてみる
use FindBin; #ライブラリ探索用
use lib "$FindBin::Bin/lib", glob "$FindBin::Bin/modules/*/lib";
use Encode;
use File::Slurp; #ファイルの読み書き用
use Intern::Diary::Model::Entry; #日記のひな形
use Intern::Diary::Service::Entry;
use DateTime;
use File::Temp; #外部エディタで編集したファイルをよみこむ用
use Path::Class; #上に同じ


my %HANDLERS = (
    add => \&add_diary,
    list => \&list_diary,
    edit => \&edit_diary,
    delete => \&delete_diary,
);

my $command = shift @ARGV ;# || 'list'; #これは何も入力しなかったらlist?

my $handler = $HANDLERS{ $command }; #or pod2usage; #使い方を表示するらしい。使うにはPod::Usageが必要

$handler->(@ARGV); #あまり挙動はよくわからないけどいれてみた

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
    my $diary_ltsv = generate_ltsv_by_hashref($diary);
    File::Slurp::write_file("data.ltsv", {append => 1}, $diary_ltsv);
#    print Dumper $diary_ltsv;
    print "OK\n";

}

sub list_diary{ #時間があればもっときれいに
      my $record = File::Slurp::read_file("data.ltsv");
      print $record;
}


sub edit_diary{
    my ($edit_id) = @_;
    die 'id required' unless defined $edit_id; #ID必要
    my $diary_ltsv = '';
    my $does_id_exist = 0;

    ($diary_ltsv,$does_id_exist) = Intern::Diary::Service::Entry->edit_entry($edit_id);
    File::Slurp::write_file("data.ltsv", $diary_ltsv); #最後に全部ファイルに書き出す

    print "This ID does not exist!\n" if $does_id_exist == 0; #存在しないIDを指定した場合
    print "Edited\n" if $does_id_exist == 1;
}

sub delete_diary{ #シェルのコマンドからN行めを削除のほうがよさそうだけどとりあえず
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
