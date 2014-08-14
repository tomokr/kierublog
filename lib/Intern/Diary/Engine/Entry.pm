package Intern::Diary::Engine::Entry;

use strict;
use warnings;
use utf8;

use Intern::Diary::Service::Entry;

use Intern::Diary::Service::DB::User;
use Intern::Diary::Service::DB::Entry;

sub default {
    my ($class, $c) = @_;

    #urlからパラメーターを取得
    my $page = $c->req->parameters->{page};

    unless($page == 0){
        #user=tomokの場合
    my $user = Intern::Diary::Service::DB::User->find_user_by_name($c->db, {name=>'tomok',});

    my $n_of_entries_a_page = 1;
    my $offset = ($page - 1) * $n_of_entries_a_page;

    my $entry = Intern::Diary::Service::DB::Entry->find_entries_by_user_id($c->db, $user->id,{
        limit => $n_of_entries_a_page,
        offset => $offset
    });

    $c->html('diary.html', {
        entries     => $entry,
    });
    }else{
        return $c->res->redirect('/');
    }

}


1;