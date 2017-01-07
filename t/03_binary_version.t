use strict;
use warnings;
our $VERSION = 0.001_000;

use Test::More tests => 7;
use File::Spec;
use Capture::Tiny qw( capture_stderr );

use_ok('Alien::astyle');

my $astyle_bin_dir = Alien::astyle->bin_dir();
my $astyle_bin = File::Spec->catfile( $astyle_bin_dir, 'astyle' );

my $version_stdout = q{};
my $version_stderr = capture_stderr {
    $version_stdout = [`$astyle_bin --version`];
};
is($version_stderr, q{}, '`astyle --version` executes without displaying errors');
cmp_ok((scalar @{$version_stdout}), '==', 1, '`astyle --version` executes with 1 line of output');

my $version_stdout_0 = $version_stdout->[0];
ok(defined $version_stdout_0, '`astyle --version` 1 line of output is defined');
is((substr $version_stdout_0, 0, 22), 'Artistic Style Version', '`astyle --version` 1 line of output starts correctly');
ok($version_stdout_0 =~ m/([\d\.]+)$/xms, '`astyle --version` 1 line of output ends correctly');

my $version_split = [split /[.]/, $1];
my $version_split_0 = $version_split->[0] + 0;
cmp_ok($version_split_0, '==', 2, '`astyle --version` returns major version 2 or newer');