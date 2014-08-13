package Intern::Diary::Model::Parse;

use strict;
use warnings;
use utf8;
use Encode;
use Data::Dumper;

## ハッシュからltsvへ ##
sub generate_ltsv_by_hashref {
    my ($class, $hashref) = @_;
    my $fields = [ map { join ':', $_, $hashref->{$_} } sort (keys %$hashref) ];
    my $record = join("\t", @$fields) . "\n";
    return $record;
}

## ltsvファイルパース ##
sub parse_ltsv {
    my ($class, $record) = @_;
    my $fields = [ split "\t", $record ]  if (defined $record) ;
    my $hashref = { map {
        my ($label, $value) = split ':', $_, 2;
        ($label => $value eq '-' ? undef : $value);
        } @$fields };
        return $hashref;
}

sub parse_diary_ltsv_file {
    my ($class, $filename) = @_;
    my @parsed_record;
    my @record = File::Slurp::read_file($filename); #1行ずつよみこむ

    foreach (@record){
        chomp($_);
        my $hashref  = $class->parse_ltsv($_); #呼び出し方
        push @parsed_record, $hashref;
    }


    return @parsed_record; #ハッシュの配列を返す

}

1;