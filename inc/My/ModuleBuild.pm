package My::ModuleBuild;
use strict;
use warnings;
our $VERSION = 0.001_000;

use Alien::Base::ModuleBuild;
use base qw( Alien::Base::ModuleBuild );

use File::chdir;
use Capture::Tiny qw( capture_stderr );
use Data::Dumper;

sub alien_check_installed_version {
    my $version_stdout;
    my $version_stderr = capture_stderr {
        $version_stdout = [`astyle --version`];
    };
    if (($version_stderr ne q{}) and
        ($version_stderr !~ m/an\'t\ exec/xms) and
        ($version_stderr !~ m/o\ such\ file/xms)) {
        print {*STDERR} 'WARNING WAAMBIV00: Alien::astyle experienced an unrecognized error while attempting to determine installed version...', 
            "\n", $version_stderr, "\n", 'Trying to continue...', "\n";
    }
    if ((scalar @{$version_stdout}) > 1) {
        print {*STDERR} 'WARNING WAAMBIV01: Alien::astyle received too much output while attempting to determine installed version...', 
            "\n", Dumper($version_stdout), "\n", 'Trying to continue...', "\n";
    }

#    print {*STDERR} '<<< DEBUG >>>: in ModuleBuild::alien_check_installed_version(), have $version_stdout = ', Dumper($version_stdout), "\n";
    my $version_stdout_0 = $version_stdout->[0];
    if ((defined $version_stdout_0) and
        ((substr $version_stdout_0, 0, 22) eq 'Artistic Style Version') and 
        ($version_stdout_0 =~ m/([\d\.]+)$/xms)) {
        my $version = $1;
#        print {*STDERR} '<<< DEBUG >>>: in ModuleBuild::alien_check_installed_version(), returning $version = ', $version, "\n";
        return $version;
    }
    else {
#        print {*STDERR} '<<< DEBUG >>>: in ModuleBuild::alien_check_installed_version(), returning nothing', "\n";
        return;
    }
}

sub alien_check_built_version {
    my $lower_directory = $CWD[-1];
    if ($lower_directory =~ /^astyle-(.*)$/) {
        return $1;
    }
    else {
        return 'unknown';
    }
}

1;
