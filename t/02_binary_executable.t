use strict;
use warnings;
our $VERSION = 0.001_000;

use Test::More tests => 10;
use File::Spec;

use_ok('Alien::astyle');

my $astyle_bin_dir = Alien::astyle->bin_dir();
ok(defined $astyle_bin_dir, 'Alien::astyle->bin_dir() is defined');
isnt($astyle_bin_dir, q{}, 'Alien::astyle->bin_dir() is not empty');
ok(-e $astyle_bin_dir, 'Alien::astyle->bin_dir() exists');
ok(-r $astyle_bin_dir, 'Alien::astyle->bin_dir() is readable');
ok(-d $astyle_bin_dir, 'Alien::astyle->bin_dir() is a directory');

my $astyle_bin = File::Spec->catfile( $astyle_bin_dir, 'astyle' );
ok(-e $astyle_bin, 'astyle exists');
ok(-r $astyle_bin, 'astyle is readable');
ok(-f $astyle_bin, 'astyle is a file');
ok(-x $astyle_bin, 'astyle is executable');