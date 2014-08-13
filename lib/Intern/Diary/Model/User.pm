package Intern::Diary::Model::User;

use strict;
use warnings;
use utf8;

use Encode;

use Class::Accessor::Lite (
	rw => [qw(
		id
		name
	)],
	new => 1,
);

1;