# This script replaces strings like `{pathspec}` in the input lines to "[HIDDEN]" or "".
#
# `pathspec` supports the following syntax.
#   `path`: path exists.
#   `<path`: path exists in the current directory or its parents.
#   `!pathspec`: invertion of the pathspec.

use strict;
use warnings;

use Cwd 'getcwd';
use File::Basename 'dirname';
use File::Spec::Functions 'catfile';

sub exists_in_parents {
    my $path = $_[0];
    my $cur = getcwd;
    my $prev;
    while (1) {
        if (-e catfile($cur, $path)) {
            return 1;
        }

        $prev = $cur;
        $cur = dirname($cur);
        if ($cur eq $prev) {
            last;
        }
    }

    return 0;
}

sub should_be_hidden {
    $_ = $_[0];
    if (/^<(.+)/) {
        return !exists_in_parents($1);
    } elsif (/^!(.+)/) {
        return !should_be_hidden($1);
    }

    return ! -e;
}

s/\{([^}]+)\}/if (should_be_hidden($1)) {"[HIDDEN]"}/e
