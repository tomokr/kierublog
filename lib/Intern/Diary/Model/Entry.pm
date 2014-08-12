package Intern::Diary::Model::Entry;

use strict;
use warnings;
use utf8;

use Encode;

use Class::Accessor::Lite (
	rw => [qw(
		diary_title
		diary_id
	)],
	new => 1,
);

sub title {
	my ($self) = @_;
	decode_utf8 $self->{title} || ''; #デコードの意味？
}

sub as_flatten_hashref {
    my ($self) = @_;
    my $entry_hashref = { map {
        ("entry.$_" => $self->$_) # e.g. "entry.entry_id" => $self->entry_id
    } qw(entry_id url title created updated) };
    return $entry_hashref;
}

1;