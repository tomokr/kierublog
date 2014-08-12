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
    my $now = '2014081220120000';
    my $entry = Intern::Diary::Model::Entry->new(
        diary_id => $now,
        diary_title    => 'はじめまして',
        diary_text  => 'こんにちはこんにちは',
    );
    is $entry->diary_id, '2014081220120000';
    is $entry->diary_title, 'はじめまして';
    is $entry->diary_text, 'こんにちはこんにちは';

};


done_testing;