package Test::Intern::Bookmark::Mechanize;

use strict;
use warnings;
use utf8;

use parent qw(Test::WWW::Mechanize::PSGI);

use Test::More ();

use Exporter::Lite;
our @EXPORT = qw(create_mech);

use Intern::Bookmark;

sub create_mech (;%) {
    return __PACKAGE__->new(@_);
}

sub new {
    my ($class, %opts) = @_;

    my $self = $class->SUPER::new(
        app     => Intern::Bookmark->as_psgi,
        %opts,
    );

    return $self;
}

1;
