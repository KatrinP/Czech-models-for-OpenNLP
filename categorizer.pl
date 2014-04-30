#skript z dat z PDT připraví výstup, kde je jeden soubor na řádku uvozený svým žánrem
#jako první argument přijímá soubor .m
#jako druhý argument přijímá soubor .w
#jako třetí argument přijímá soubor .t

#!/usr/bin/perl
use warnings;
use strict;
my ($id, $genre, $nextline, $space);

open(MFILE, $ARGV[0]) or die "nenalezen MFILE";
open(WFILE, $ARGV[1]) or die "nenalezen WFILE";
open(TFILE, $ARGV[2]) or die "nenalezen TFILE";

do {
    $genre = <TFILE>;   
} until ($genre =~ m/<genre>(.+)<\/genre>/);
print "$1 ";

while ($_ = <MFILE>) {
    if ($_ =~ m/<m id="m-(.+)">/) { #další tavr poznám podle přítomnosti id a tagu <m>
        $id = $1;   #id konkrétního tvaru, budu potřebovat později
        do {
            $nextline = <MFILE>;
        } until ($nextline =~ m/.*<form>(.+)<\/form>.*/);
        print $1;
        do {
            $space = <WFILE>;   #načítají se další řádky, dokud se nenarazí na správné id
            unless (defined($space)) {  #když se narazí na konec souboru, přeskoč zbytek
                print " ";
                close(WFILE); 
                open(WFILE, $ARGV[1]); 
                goto PRESKOCENO;
            }
        } until ($space =~ m/$id/);
        $space = <WFILE>;
        $space = <WFILE>;
        unless (defined($space)) {
            print " ";
            close(WFILE); 
            open(WFILE, $ARGV[1]); 
            goto PRESKOCENO
        }
        unless ($space =~ m/<no_space_after>/) {
            print " ";
        }
        PRESKOCENO:
    }
}  
print "\n"; #celý soubor zpracován, odděluji prázdným řádkem  
