package Intern::Diary::Model::Entry;

use strict;
use warnings;
use utf8;

use Encode;

use Class::Accessor::Lite (
	rw => [qw(
		id
		user_id
		created
		date
	)],
	new => 1,
);

sub title {
	my ($self) = @_;
	decode_utf8 $self->{title} || '';
}

sub text {
	my ($self) = @_;
	decode_utf8 $self->{text} || '';
}

1;