package Intern::Diary::Service::Entry;

use strict;
use warnings;
use utf8;
use Encode;
use DateTime;
use Intern::Diary::Model::Entry;
use Intern::Diary::Model::Parse;

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

	my ($class, $old_entry) = @_;
    my ($new_title, $new_text, $new_entry, $diary_id);
     $new_title = '';
     print "title:";
     $new_title = <STDIN>;
     chomp($new_title);
     printf "Old_text:%s\n",$old_entry->{diary_text};
     print "New_text:";
     $new_text = <STDIN>;
     chomp($new_text);
     $diary_id = $old_entry->{diary_id};
     $new_entry = Intern::Diary::Model::Entry->new(
        diary_id => $diary_id,
        diary_title => $new_title,
        diary_text => $new_text,
        );
     return $new_entry;
    }

sub delete_entry{
	my ($class, $d_id) = @_;
	my $diary_ltsv;
    my @parsed_record = Intern::Diary::Model::Parse->parse_diary_ltsv_file("data.ltsv");
    my $does_id_exist = 0;
    foreach (@parsed_record){
        unless($_->{diary_id} eq $d_id){#消そうとしているidでなければ$diary_ltsvにくっつけていく
            $diary_ltsv .= Intern::Diary::Model::Parse->generate_ltsv_by_hashref($_);
            }else{
                $does_id_exist = 1;
            }
    }

    return ($diary_ltsv, $does_id_exist);
}

## 現在時刻を文字列で取得 ##
sub now_datetime_as_string {
    my $dt = DateTime->from_epoch(epoch => time);
    my $string = sprintf "%4d%02d%02d%02d%02d%02d",$dt->year,$dt->month,$dt->day,$dt->hour,$dt->minute,$dt->second;
    return $string;
}

1;