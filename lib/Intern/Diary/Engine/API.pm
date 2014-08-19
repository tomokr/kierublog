package Intern::Diary::Engine::API;

use strict;
use warnings;
use utf8;

use JSON::Types;

use Intern::Diary::Model::Entry;
use Intern::Diary::Service::DB::User;
use Intern::Diary::Service::DB::Entry;

sub entries{
    my ($class, $c) = @_;
    my $entries;

    my $per_page = $c->req->parameters->{per_page};
    my $page = $c->req->parameters->{page};
    my $offset = ($page - 1) * $per_page;

    #user=tomokの場合
    my $user = Intern::Diary::Service::DB::User->find_user_by_name($c->db, {name=>'tomok',});
    if($per_page && $page){
        $entries = Intern::Diary::Service::DB::Entry->find_entries_by_user_id($c->db,$user->id,{limit=>$per_page, offset=>$offset});
    }else{
        $entries = Intern::Diary::Service::DB::Entry->find_entries_by_user_id($c->db,$user->id);
    }
    my @hash_entries = map {
    	Intern::Diary::Model::Entry->TO_HASH($_)
    	} @$entries;

    $c->json({
    	entries => \@hash_entries,
    	per_page => JSON::Types::number $per_page,
    	next_page => JSON::Types::number $page + 1,
    	});

}

sub add{
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

        $c->json({
            title => $title,
            text => $text,
            })

}

sub edit{
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

        $c->json({
            id => $id,
            title => $title,
            text => $text,
            })
}

sub delete{
    my ($class, $c) = @_;

    my $id = $c->req->parameters->{id};

    Intern::Diary::Service::DB::Entry->delete_entry($c->db, $id);

    $c->json({
            id => $id,
            })
}

1;