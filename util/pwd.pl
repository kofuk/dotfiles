#!/usr/bin/env perl
use strict;
use warnings;
use Cwd;

my $home = $ENV{"HOME"};
my $wd = Cwd::getcwd();
if ($#ARGV >= 0) {
    $wd = $ARGV[0];
}
my $is_under_home = 0;
if (index($wd, "^$home") == -1) {
    $is_under_home = 1;
    $wd =~ s/^$home/~/;
}
my $len = length($wd);
my @segs = split(/\//, $wd);
my $seglen = $#segs + 1;
my $index = 0;
while ($len > 30 && $index < $seglen - 2) {
    if (length($segs[$index]) > 1) {
	$len -= length($segs[$index]) - 1;
	$segs[$index] = substr($segs[$index], 0, 1);
    }
    $index++;
}
if (!$is_under_home) {
    print "/";
}
print join("/", @segs);
print "\n";
