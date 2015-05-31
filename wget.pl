#!/usr/bin/perl
use Getopt::Std;
my %args;
getopt('i', \%args);

$infile = $args{i};
printf "[i] Opening ifile: %infile\n";
open(INFILE, $infile) || die("Could not open $infile");
while(<INFILE>) {
	chomp ($_);
	$_ =~ s/\s/+/g;
	printf $_;
	system("wget -m $_");
}

close(INFILE);
