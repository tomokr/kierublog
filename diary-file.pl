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

    my $now = now_datetime_as_string();
    my $diary_id = $now;
    print "Text:";
    my $text = <STDIN>;
    chomp($text);
    my $diary_text = $text;  #generate_text();不要になった
    my $entry = Intern::Diary::Model::Entry->new(
        diary_id => $diary_id,
        diary_title => $title,
        diary_text => $diary_text,
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
    my ($delete_id) = @_;
    die 'id required' unless defined $delete_id; #ID必要

    my $diary_ltsv;
    my @parsed_record = parse_diary_ltsv_file("data.ltsv");
    my $does_id_exist = 0;
    my ($new_title, $diary_id, $entry, $new_text);
    $new_title = '';
    foreach (@parsed_record){ #空行があるとエラーがでる
        unless($_->{diary_id} eq $delete_id){#編集しようとしているidでなければ$diary_ltsvにくっつけていく
            $diary_ltsv .= generate_ltsv_by_hashref($_);
            }else{
                $does_id_exist = 1;
                print "title:";
                $new_title = <STDIN>;
                chomp($new_title);
                printf "Old_text:%s\n",$_->{diary_text};
                print "New_text:";
                $new_text = <STDIN>;
                chomp($new_text);
                $diary_id = $_->{diary_id};
                $entry = Intern::Diary::Model::Entry->new(
                    diary_id => $diary_id,
                    diary_title => $new_title,
                    diary_text => $new_text,#edit_text($_->{diary_id}),
                );
                 $diary_ltsv .= generate_ltsv_by_hashref($entry);
            }
    }
    File::Slurp::write_file("data.ltsv", $diary_ltsv); #最後に全部ファイルに書き出す
    print "This ID does not exist!\n" if $does_id_exist == 0; #存在しないIDを指定した場合

}

sub delete_diary{ #シェルのコマンドからN行めを削除のほうがよさそうだけどとりあえず
    my ($delete_id) = @_;

    die 'id required' unless defined $delete_id; #ID必要

    my $diary_ltsv;
    my @parsed_record = parse_diary_ltsv_file("data.ltsv");
    my $does_id_exist = 0;
    foreach (@parsed_record){
        unless($_->{diary_id} eq $delete_id){#消そうとしているidでなければ$diary_ltsvにくっつけていく
            $diary_ltsv .= generate_ltsv_by_hashref($_);
            }else{
                $does_id_exist = 1;
            }
    }
    File::Slurp::write_file("data.ltsv", $diary_ltsv); #最後に全部ファイルに書き出す
    print "This ID does not exist!\n" if $does_id_exist == 0; #存在しないIDを指定した場合

}

## 現在時刻を文字列で取得 ##
sub now_datetime_as_string {
    #中身は自分で書き換えたのでBookmarkのとはちがう
    my $dt = DateTime->from_epoch(epoch => time);
    my $string = sprintf "%4d%02d%02d%02d%02d%02d",$dt->year,$dt->month,$dt->day,$dt->hour,$dt->minute,$dt->second;
    return $string;
}

=head #長文をかくつもりだったけどLTSVでは改行がやっかいなのでとりあえずいらなくなった
## 本文生成用 ##
## http://blog.kzfmix.com/entry/1238327032 ##
sub generate_text{
    my $text;
    my $f = File::Temp->new();
    close $f;
    my $t = file($f->filename)->stat->mtime;

    if($ENV{EDITOR}){
        system $ENV{EDITOR}, $f->filename;
    }else{
        system 'vim', $f->filename;
    }

    if ($t == file($f->filename)->stat->mtime) {
        print STDERR "No changes.";
    } else {
        $text = read_file($f->filename); #外部エディタで入力したデータを読み込む
    }

    return $text;
}

## テキスト編集用 ##
sub edit_text{
    my $text;
    my $f = File::Temp->new();
    close $f;
    File::Slurp::write_file($f->filename, {append => 1}, $text);
    my $t = file($f->filename)->stat->mtime;

    if($ENV{EDITOR}){
        system $ENV{EDITOR}, $f->filename;
    }else{
        system 'vim', $f->filename;
    }

    if ($t == file($f->filename)->stat->mtime) {
        print STDERR "No changes.";
    } else {
        $text = read_file($f->filename); #外部エディタで入力したデータを読み込む
    }

    return $text;
}
=cut

## ハッシュからltsvへ ##
sub generate_ltsv_by_hashref {
    my ($hashref) = @_;
    my $fields = [ map { join ':', $_, $hashref->{$_} } sort (keys %$hashref) ];
    my $record = join("\t", @$fields) . "\n";
    return $record;
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

sub parse_diary_ltsv_file {
    my ($filename) = @_;
    my @parsed_record;
    my @record = File::Slurp::read_file($filename); #1行ずつよみこむ

    foreach (@record){
    chomp($_);
    my $hashref  = parse_ltsv($_);
    push @parsed_record, $hashref;
}
    return @parsed_record; #ハッシュの配列を返す

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
