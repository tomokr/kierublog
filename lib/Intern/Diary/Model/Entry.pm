package Intern::Diary::Model::Entry;

use strict;
use warnings;
use utf8;

use Encode;

use Class::Accessor::Lite (
	rw => [qw(
		diary_title
		diary_id
		diary_text
		user_id
		created
		date
	)],
	new => 1,
);

=head
#いらない?N
sub title {
	my ($self) = @_;
	decode_utf8 $self->{title} || ''; #デコードの意味？
}
=cut

1;