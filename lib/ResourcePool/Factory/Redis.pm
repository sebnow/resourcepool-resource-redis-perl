#!/usr/bin/perl

package ResourcePool::Factory::Redis;
use strict;
use warnings;
use base qw(ResourcePool::Factory);
use ResourcePool::Resource::Redis;

our $VERSION = 1.0;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = $class->SUPER::new("Redis");
	my %args = @_;

	$self->{'args'} = \%args;

	bless($self, $class);
	return $self;
}

sub create_resource {
	my $self = shift;
	return ResourcePool::Resource::Redis->new(%{$self->{'args'}});
}

sub info {
	return shift->{'args'}->{'server'};
}

__END__

=head1 SYNOPSIS

ResourcePool::Factory::Redis provides a L<Redis|Redis> factory for L<ResourcePool|ResourcePool>.

=head1 METHODS

=over

=item new(%args)

Accepts the same arguments as L<Redis::new|Redis>.

=back

=head1 SEE ALSO

L<ResourcePool|ResourcePool> for detailed documentation and general information about
what a ResourcePool is.

L<Redis|Redis> for documentation on the Redis interface.

=cut

