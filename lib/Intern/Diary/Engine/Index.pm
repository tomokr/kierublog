package Intern::Diary::Engine::Index;

use strict;
use warnings;
use utf8;

use Intern::Diary::Service::DB::User;
use Intern::Diary::Service::DB::Entry;

sub default {
    my ($class, $c) = @_;
    $c->html('index.html');

   	#user=tomokrの場合
   	my $user = Intern::Diary::Service::DB::User->find_user_by_name($c->db, {name=>'tomok',});

   	#エントリ一覧を取得
   	my $entries = Intern::Diary::Service::DB::Entry->find_entries_by_user_id($c->db, $user->id);

   	$c->html('index.html',{
   		entries => $entries,
   		})


}

1;
__END__
