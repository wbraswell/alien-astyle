package My::ModuleBuild;
use strict;
use warnings;
our $VERSION = 0.001_000;

use Alien::Base::ModuleBuild;
use base qw( Alien::Base::ModuleBuild );

use File::chdir;
use Capture::Tiny qw( capture_stderr );

sub alien_check_installed_version {
    my $version_stdout;
    my $version_stderr = capture_stderr {
        $version_stdout = [`astyle --version`];
    };
    if ($version_stderr ne q{}) {
        print {*STDERR} 'WARNING WAAMBIV00: Alien::astyle experienced an error while attempting to determine installed version...', 
            "\n", $version_stderr, "\n", 'Trying to continue...', "\n";
    }
    if ((scalar @{$version_stdout}) != 1) {
        print {*STDERR} 'WARNING WAAMBIV01: Alien::astyle received too much output while attempting to determine installed version...', 
            "\n", $version_stdout, "\n", 'Trying to continue...', "\n";
    }

    print {*STDERR} '<<< DEBUG >>>: in ModuleBuild::alien_check_installed_version(), have $version_stdout = ', $version_stdout, "\n";
    if ((defined $version_stdout) and
        ($version_stdout =~ /^Artistic Style Version/) and 
        ($version_stdout =~ /([0-9\.]+)$/)) {
        my $version = $1;
        print {*STDERR} '<<< DEBUG >>>: in ModuleBuild::alien_check_installed_version(), returning $version = ', $version, "\n";
        return $version;
    }
    else {
        print {*STDERR} '<<< DEBUG >>>: in ModuleBuild::alien_check_installed_version(), returning nothing', "\n";
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
