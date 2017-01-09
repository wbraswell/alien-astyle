package My::ModuleBuild;
use strict;
use warnings;
our $VERSION = 0.002_000;

use Alien::Base::ModuleBuild;
use base qw( Alien::Base::ModuleBuild );

use File::chdir;
use Capture::Tiny qw( capture_stderr );
use Data::Dumper;
use IPC::Cmd qw(can_run);

sub alien_check_installed_version {
    # check if `astyle` can be run, if so get path to binary executable
    my $astyle_path = can_run('astyle');
    if (not defined $astyle_path) {
#        print {*STDERR} '<<< DEBUG >>>: in ModuleBuild::alien_check_installed_version(), no `astyle` binary found, returning nothing', "\n";
        return;
    }

    # run `astyle --version`, check for valid output
    my $version_stderr = [split /\r?\n/, capture_stderr {
        system "$astyle_path --version";
    }];
    if($? != 0) {
        print {*STDERR} 'WARNING WAAMBIV00: Alien::astyle experienced an unrecognized error while attempting to determine installed version...', 
            "\n", $version_stderr, "\n", 'Trying to continue...', "\n";
    }
    if ((scalar @{$version_stderr}) > 1) {
        print {*STDERR} 'WARNING WAAMBIV01: Alien::astyle received too much output while attempting to determine installed version...', 
            "\n", Dumper($version_stderr), "\n", 'Trying to continue...', "\n";
    }

#    print {*STDERR} '<<< DEBUG >>>: in ModuleBuild::alien_check_installed_version(), have $version_stderr = ', Dumper($version_stderr), "\n";
    my $version_stderr_0 = $version_stderr->[0];
    if ((defined $version_stderr_0) and
        ((substr $version_stderr_0, 0, 22) eq 'Artistic Style Version') and 
        ($version_stderr_0 =~ m/([\d\.]+)$/xms)) {
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
