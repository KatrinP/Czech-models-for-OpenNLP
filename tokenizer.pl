#skript z dat z PDT připraví výstup, kde je jedna věta na řádku. Pracuje se dvěma soubory, z jendoho bere tokeny a informace o mezerách a nterpunkc a ze druhého hranice vět
#jako první argument přijímá soubor .m
#jako druhý argument přijímá soubor .w

#!/usr/bin/perl
use warnings;
use strict;
my ($id, $token, $nextline, $m, $space, $konec);

open(MFILE, $ARGV[0]) or die "nenalezen MFILE!!!";
open(WFILE, $ARGV[1]) or die "nenalezen WFILE";

while ($_ = <MFILE>) {
    $konec = 0;
    if ($_ =~ m/<m id="m-(.+)">/) { #další tavr poznám podle přítomnosti id a tagu <w>
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
        else {
            print "<SPLIT>"
        }
        PRESKOCENO:
    }
    if ($_ =~ m/<\/s/) {
        print "\n"; 
    }
}  
print "\n"; #celý soubor zpracován, odděluji prázdným řádkem  
