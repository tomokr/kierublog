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
    warn "entries";

    my $per_page = $c->req->parameters->{per_page};
    my $page = $c->req->parameters->{page};
    my $offset = ($page - 1) * $per_page;

    #user=tomokの場合
    my $user = Intern::Diary::Service::DB::User->find_user_by_name($c->db, {name=>'tomok',});

    my $entries = Intern::Diary::Service::DB::Entry->find_entries_by_user_id($c->db,$user->id,{limit=>$per_page, offset=>$offset});
    my @hash_entries = map {
    	Intern::Diary::Model::Entry->TO_HASH($_)
    	} @$entries;

    $c->json({
    	entries => \@hash_entries,
    	per_page => JSON::Types::number $per_page,
    	next_page => JSON::Types::number $page + 1,
    	});

}

1;