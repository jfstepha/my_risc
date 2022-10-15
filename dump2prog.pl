#!/usr/bin/perl
$infilename = shift @ARGV;

open INFILE, $infilename or die "Cannot open $infilename for read: $!\n";

print STDERR "Opening $infilename...\n";
while(<INFILE>) {
#    if( /^    ([0-9a-f]+):   ([0-9a-f]+) /) {
    if( /^    ([0-9a-f]+):\s+([0-9a-f]+)\s+(.*)$/ ) {
        print " $2  // $1: $3\n";
        #print "addr:$1 instr:$2 code:$3\n";
    } else {
        print "//$_";
    }
}

close INFILE
