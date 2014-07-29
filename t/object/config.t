package t::Hatena::Newbie::Config;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent 'Test::Class';

use Test::More;

use Test::Hatena::Newbie;

use Intern::Diary::Config;

sub _config : Test(1) {
    is(config->param('origin'), "http://localhost:3000");
}

__PACKAGE__->runtests;

1;
