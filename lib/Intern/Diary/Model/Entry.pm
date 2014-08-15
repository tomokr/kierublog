package Intern::Diary::Model::Entry;

use strict;
use warnings;
use utf8;

use Encode;

use JSON::Types qw();

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

sub TO_HASH{
	my ($class,$self) = @_;
	return {
		id => $self->id,
		user_id => $self->user_id,
		title => $self->title,
		text => $self->text,
		created => $self->created,
		date => $self->date,
	};

}

1;