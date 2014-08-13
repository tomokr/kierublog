package t::Intern::Diary::Model::Entry;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use Test::More;
use Test::Deep;
use Test::Exception;
use parent qw(Test::Class);
#use String::Random qw(random_regex);

#モジュールがrequireできるか
require_ok 'Intern::Diary::Model::Entry';

#accessorテスト
subtest '_accessor' => sub {
    my $now = '20140812201200';
    my $entry = Intern::Diary::Model::Entry->new(
        diary_id => $now,
        diary_title    => 'はじめまして',
        diary_text  => 'こんにちはこんにちは',
        user_id => 'doughnutomo',
        created => '2014-08-13 15:38:00',
        date => '2014-08-13'
    );
    is $entry->diary_id, '20140812201200';
    is $entry->diary_title, 'はじめまして';
    is $entry->diary_text, 'こんにちはこんにちは';
    is $entry->user_id, 'doughnutomo';
    is $entry->created, '2014-08-13 15:38:00';
    is $entry->date, '2014-08-13';

};


done_testing;