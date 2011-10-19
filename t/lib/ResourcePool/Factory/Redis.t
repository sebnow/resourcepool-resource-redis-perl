#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 5;
use Test::MockModule;
use ResourcePool;

my $redis_m = Test::MockModule->new("Redis");
$redis_m->mock("new", sub {
	my $class = shift;
	my $self = {@_};
	return bless($self, $class);
});
BEGIN {
    use_ok('ResourcePool::Factory::Redis')
        or BAIL_OUT("Unable to import ResourcePool::Factory::Redis");
};

{
	$redis_m->mock("ping", sub {
		return "PONG";
	});
    my $redis_server = "127.0.0.1:6379";
	my $factory = new_ok("ResourcePool::Factory::Redis" => ['server' => $redis_server]);
	my $pool = ResourcePool->new($factory);
    my $redis = $pool->get();
    isa_ok($redis, "Redis");
	$pool->free($redis);
	$redis_m->unmock('ping');
}

{
	$redis_m->mock("ping", sub {
		return "";
	});
	my $redis_server = "127.0.0.1:6379";
	my $factory = new_ok("ResourcePool::Factory::Redis" => ['server' => $redis_server]);
	my $pool = ResourcePool->new($factory);
	my $redis = $pool->get();
	is($redis, undef,
		"Given a Redis resource pool, " .
		"when the Redis server is unresponsive, " .
		"and a resource is retrieved from the pool, " .
		"then the precheck should fail");
	$redis_m->unmock('ping');
}

