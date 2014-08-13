package Intern::Diary::Model::User;

use strict;
use warnings;
use utf8;

use Encode;

use Class::Accessor::Lite (
	rw => [qw(
		user_id
		name
	)],
	new => 1,
);

1;