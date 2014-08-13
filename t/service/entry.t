package t::Intern::Diary::Service::Entry;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use Test::More;

#モジュールがrequireできるか
require_ok 'Intern::Diary::Service::Entry';

#createがうごくか
subtest 'create' => sub {
    my $title = 'はじめまして';
    my $text = 'こんにちはこんにちは';
    my $entry_1 = Intern::Diary::Service::Entry->create_entry($title, $text);
    my $time = Intern::Diary::Service::Entry->now_datetime_as_string();

    is $entry_1->{diary_id} , $time;
    is $entry_1->{diary_text}, 'こんにちはこんにちは';
    is $entry_1->{diary_title}, 'はじめまして';

};

subtest 'edit' => sub{

}

done_testing;