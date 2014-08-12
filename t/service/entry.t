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

    is $entry_1, 'diary_id:2014081220120000	diary_text:こんにちはこんにちは	diary_title:はじめまして';

};


done_testing;