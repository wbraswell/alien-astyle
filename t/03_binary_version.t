use strict;
use warnings;
our $VERSION = 0.001_000;

use Test::More tests => 6;
use File::Spec;
use Capture::Tiny qw( capture_merged );
use Env qw( @PATH );

use_ok('Alien::astyle');

unshift @PATH, Alien::astyle->bin_dir;

my $version = [ split /\r?\n/, capture_merged {
    system "astyle --version";
}];
#is($version_stderr, q{}, '`astyle --version` executes without displaying errors');
cmp_ok((scalar @{$version}), '==', 1, '`astyle --version` executes with 1 line of output');

my $version_0 = $version->[0];
ok(defined $version_0, '`astyle --version` 1 line of output is defined');
is((substr $version_0, 0, 22), 'Artistic Style Version', '`astyle --version` 1 line of output starts correctly');
ok($version_0 =~ m/([\d\.]+)$/xms, '`astyle --version` 1 line of output ends correctly');

my $version_split = [split /[.]/, $1];
my $version_split_0 = $version_split->[0] + 0;
cmp_ok($version_split_0, '==', 2, '`astyle --version` returns major version 2 or newer');
