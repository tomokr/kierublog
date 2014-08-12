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
use DateTime;


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

    my $now = now_datetime_as_string();
    my $diary_id = $now; #generate_diary_id(); #この関数必要
    my $entry = Intern::Diary::Model::Entry->new(
        diary_id => $diary_id,
        diary_title => $title,
    );

    my $diary_ltsv = generate_ltsv_by_hashref($entry);
    File::Slurp::write_file("data.ltsv", {append => 1}, $diary_ltsv);
    print Dumper $diary_ltsv;
    print "OK\n";

}

sub list_diary{ #時間があればもっときれいに
      my $record = File::Slurp::read_file("data.ltsv");
      print $record;

}

sub edit_diary{

}

sub delete_diary{

}

sub generate_ltsv_by_hashref {
    my ($hashref) = @_;
    my $fields = [ map { join ':', $_, $hashref->{$_} } sort (keys %$hashref) ];
    my $record = join("\t", @$fields) . "\n";
    return $record;
}

sub now_datetime_as_string {
    #中身は自分で書き換えたのでBookmarkのとはちがう
    my $dt = DateTime->from_epoch(epoch => time);
    my $string = sprintf "%4d%02d%02d%02d%02d%02d",$dt->year,$dt->month,$dt->day,$dt->hour,$dt->minute,$dt->second;
    return $string;
}

## ltsvファイルパース ##
sub parse_ltsv {
    my ($record) = @_;
    my $fields = [ split "\t", $record ];
    my $hashref = { map {
        my ($label, $value) = split ':', $_, 2;
        ($label => $value eq '-' ? undef : $value);
    } @$fields };
    return $hashref;
}

sub parse_bookmark_ltsv_file {
    my ($filename) = @_;
    my @record = File::Slurp::read_file($filename); #1行ずつよみこむ

    foreach my $record (@record){
    my $hashref  = parse_ltsv($record);

    return $;
}

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
