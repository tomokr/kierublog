package Intern::Diary::Service::Entry;

use strict;
use warnings;
use utf8;
use Encode;
use DateTime;
use Intern::Diary::Model::Entry;

sub create_entry{
	my ($class, $title, $diary_text) = @_;
	my $now = now_datetime_as_string();
	my $diary_id = $now;
	my $entry = Intern::Diary::Model::Entry->new(
		diary_id => $diary_id,
		diary_title => $title,
		diary_text => $diary_text,
	);


	return $entry;
}

sub edit_entry{
	my ($class, $edit_id) = @_;
	my $diary_ltsv;
    my @parsed_record = parse_diary_ltsv_file("data.ltsv");
    my $does_id_exist = 0;
    my ($new_title, $diary_id, $entry, $new_text);
    $new_title = '';
    foreach (@parsed_record){ #空行があるとエラーがでる
        unless($_->{diary_id} eq $edit_id){#編集しようとしているidでなければ$diary_ltsvにくっつけていく
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

    return ($diary_ltsv, $does_id_exist);

}

sub delete_entry{
	my ($class, $d_id) = @_;
	my $diary_ltsv;
    my @parsed_record = parse_diary_ltsv_file("data.ltsv");
    my $does_id_exist = 0;
    foreach (@parsed_record){
        unless($_->{diary_id} eq $d_id){#消そうとしているidでなければ$diary_ltsvにくっつけていく
            $diary_ltsv .= generate_ltsv_by_hashref($_);
            }else{
                $does_id_exist = 1;
            }
    }

    return ($diary_ltsv, $does_id_exist);
}

## ハッシュからltsvへ ##
sub generate_ltsv_by_hashref {
    my ($hashref) = @_;
    my $fields = [ map { join ':', $_, $hashref->{$_} } sort (keys %$hashref) ];
    my $record = join("\t", @$fields) . "\n";
    return $record;
}

## 現在時刻を文字列で取得 ##
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

1;