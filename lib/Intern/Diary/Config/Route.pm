package Intern::Diary::Config::Route;

use strict;
use warnings;
use utf8;

use Router::Simple::Declare;

sub make_router {
    return router {
        connect '/' => {
            engine => 'Index',
            action => 'default',
        };

        connect '/entry' =>{
        	engine => 'Entry',
        	action => 'default'
        };

        connect '/entry/list' =>{
            engine => 'Entry',
            action => 'list'
        };

        connect '/entry/add' =>{
        	engine => 'Entry',
        	action => 'add_get'
        	} => { method => 'GET'};
        connect '/entry/add' =>{
            engine => 'Entry',
            action => 'add_post'
        } => { method => 'POST' };

        connect '/entry/edit' =>{
        	engine => 'Entry',
        	action => 'edit_get'
        	} => { method => 'GET'};
        connect '/entry/edit' =>{
        	engine => 'Entry',
        	action => 'edit_post'
        	} => { method => 'POST' };

        connect '/entry/delete' =>{
        	engine => 'Entry',
        	action => 'delete_get'
        	} => { method => 'GET'};
        connect '/entry/delete' =>{
        	engine => 'Entry',
        	action => 'delete_post'
        	} => { method => 'POST' };

        #API
        connect '/api/entries' =>{
            engine => 'API',
            action => 'entries'
        };

        connect '/api/add' =>{
            engine => 'API',
            action => 'add'
        };

        connect '/api/edit' =>{
            engine => 'API',
            action => 'edit'
        };


        connect '/entry_js' =>{
            engine => 'EntryJS',
            action => 'default'
        };

    };#return文おわり

}

1;
