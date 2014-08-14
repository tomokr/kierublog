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

        connect '/entry/add' =>{
        	engine => 'Entry',
        	action => 'add_get'
        	} => { method => 'GET'};
        connect '/entry/add' =>{
            engine => 'Entry',
            action => 'add_post'
        } => { method => 'POST' };
    };
}

1;
