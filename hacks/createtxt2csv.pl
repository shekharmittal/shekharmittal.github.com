#!/usr/local/bin/perl
use strict;
use warnings;

my $TxtFile = "senate70.csv"; #@ARGV[0];
my $CsvFile = "senate70_final.txt"; #@ARGV[1];

open (FILE, 'more_data/house106.csv');

#Now start matching the constituencies to the hash and writing it into a text fil
open (ERRORFILE, '>more_data/errorlog_106h.txt');
open (CSVFILE, '>more_data/house106_final.txt');

my $count = 0; 
while (<FILE>){
    chomp();
    $count = $count+1;
    if ($count < 1){
        next;
    }
    my $time=1;
#    if($_=~/^(\d+),(\d+),(\d+),(\d+),([\w\"\s]*),(\d*),(\d*),(\d*),([\w"\/\'\s\(\)\.-]+),(.*)/){
    if($_=~/^(\d+),(\d+),(\d+),(\d+),([\w"\s]*),(\d+),([\w"\'\s\.-]+),(.*)/){
        while ($time<=1209){
            my $vote=substr $8, 2*($time-1),1;
#            my $vote=substr $10, 2*($time-1),1;
#            print CSVFILE "$1,$2,$3,$4,$5,$6,$7,$8,$9,$time,$vote\n";
            print CSVFILE "$1,$2,$3,$4,$5,$6,$7,$time,$vote\n";
            $time = $time + 1;
        }
    }else{
            print ERRORFILE "$_ \n";
    }
	
}

close (ERRORFILE); 
close (CSVFILE); 
close (FILE);
#\d+{$time-1},
#    if ($_ =~/^\D/){
#	print ERRORFILE "$_\n";
#	next;
 #   }
#  elsif ($_ =~/^\d+\..*\d/){
#           print ERRORFILE "$_\n";
#    }elsif($_ =~/^\d+\./){
  

