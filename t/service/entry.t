package t::Intern::Diary::Service::Entry;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use Test::More;
use IO::ScalarArray; #標準入力テスト用

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

#editがうごくか
subtest 'edit' => sub{
	my $old_entry = {
		diary_id => '20140812201200',
		diary_text => '編集まだです',
		diary_title => '未編集',
	};

	my @inputs = ("編集\n", "編集されました\n");
	my $stdin = IO::ScalarArray->new(\@inputs);
	local *STDIN = *$stdin;

	my $new_entry = Intern::Diary::Service::Entry->edit_entry($old_entry);

	is $new_entry->{diary_id}, '20140812201200';
	is $new_entry->{diary_title}, '編集';
	is $new_entry->{diary_text}, '編集されました';

};

#deleteがうごくか
#subtest 'delete' => sub{

#};

done_testing;