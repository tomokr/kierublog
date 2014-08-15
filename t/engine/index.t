package t::Intern::Diary::Engine::Index;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent 'Test::Class';

use Test::Intern::Diary;
use Test::Intern::Diary::Mechanize;
use Test::Intern::Diary::Factory;

use Intern::Diary::Service::DB::User;

sub _get : Test(3) {
    my $mech = create_mech;
    my $db = Intern::Diary::DBI::Factory->new;
    my $user;
    unless (Intern::Diary::Service::DB::User->find_user_by_name($db,{name=>'tomok'})) {
    	$user = create_user(name => 'tomok');
    }else{
    	$user = Intern::Diary::Service::DB::User->find_user_by_name($db,{name=>'tomok'});
    }
        Intern::Diary::Service::DB::Entry->create_entry($db, {
             user_id => $user->id,
             diary_text => 'texttext',
             diary_title => 'titletitle',
        });
    $mech->get_ok('/');
    $mech->title_is('Intern::Diary');
    $mech->content_contains('Intern::Diary');
}

__PACKAGE__->runtests;

1;
