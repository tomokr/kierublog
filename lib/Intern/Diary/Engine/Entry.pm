package Intern::Diary::Engine::Entry;

use strict;
use warnings;
use utf8;

use Intern::Diary::Service::Entry;

use Intern::Diary::Service::DB::User;
use Intern::Diary::Service::DB::Entry;

sub default {
    my ($class, $c) = @_;

    ## 個別記事  ##
    my $id = $c->req->parameters->{id};

    my $entry = Intern::Diary::Service::DB::Entry->find_entry_by_id($c->db, $id);

    if($entry){

    $c->html('every_entry.html', {
        entry     => $entry,
    });
    }else{
        return $c->error('404','404 Not Found. No entry.');
    }

}

sub list{
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

sub add_get{
    my ($class, $c) = @_;
    $c->html('entry/add.html',);
}

sub add_post{
    my ($class, $c) = @_;
    #user=tomokの場合
    my $user = Intern::Diary::Service::DB::User->find_user_by_name($c->db, {name=>'tomok',});

        my $title = $c->req->string_param('title');
        my $text = $c->req->string_param('text');

        Intern::Diary::Service::DB::Entry->create_entry($c->db,
        {
            user_id => $user->id,
            diary_title => $title,
            diary_text => $text,
        }
            );
    $c->res->redirect('/');
}

sub edit_get{
    my ($class, $c) = @_;

    my $id = $c->req->parameters->{id};

    my $entry = Intern::Diary::Service::DB::Entry->find_entry_by_id($c->db, $id);
    if($entry){
        $c->html('entry/edit.html', {
            entry    => $entry,
            });
    }else{
        #そのエントリは存在しません
        $c->res->redirect('/');
    }
}

sub edit_post{
        my ($class, $c) = @_;

        my $id = $c->req->parameters->{id};
        my $title = $c->req->string_param('title');
        my $text = $c->req->string_param('text');

        Intern::Diary::Service::DB::Entry->update_entry($c->db,
        {
            id => $id,
            title => $title,
            text => $text,
        }
            );
    $c->res->redirect('/');
}

sub delete_get{
    my ($class, $c) = @_;

    my $id = $c->req->parameters->{id};

    my $entry = Intern::Diary::Service::DB::Entry->find_entry_by_id($c->db, $id);
    if($entry){
        $c->html('entry/delete.html', {
            entry    => $entry,
            });
    }else{
        #そのエントリは存在しません
        $c->res->redirect('/');
    }
}

sub delete_post{
    my ($class, $c) = @_;

    my $id = $c->req->parameters->{id};

    Intern::Diary::Service::DB::Entry->delete_entry($c->db, $id);

    $c->res->redirect('/');

}

1;