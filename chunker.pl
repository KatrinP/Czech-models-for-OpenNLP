#skript z dat z PDT připraví výstup, kde je jedno slovo na řádku se slovním druhem a číse klauze. Pracuje se dvěma soubory, z jendoho bere tokeny a z druhého info o klauzi
#jako první argument přijímá soubor .m
#jako druhý argument přijímá soubor .a

#!/usr/bin/perl
use warnings;
use strict;
my ($id, $token, $nextline, $opakovani, $space, $klauze);

open(MFILE, $ARGV[0]) or die "nenalezen MFILE!!!";
open(AFILE, $ARGV[1]) or die "nenalezen AFILE";

while ($_ = <MFILE>) {
    if ($_ =~ m/<m id="m-(.+)">/) { #další tvar poznám podle přítomnosti id a tagu <m>
        $id = $1;   #id konkrétního tvaru, budu potřebovat později
        do {
            $nextline = <MFILE>;
        } until ($nextline =~ m/.*<form>(.+)<\/form>.*/);
        print $1;
        $nextline = <MFILE>;
        $nextline = <MFILE>;
        $nextline =~ m/.*<tag>(..).*/;
        print " $1";
        $opakovani = 0;
        OPAKOVAT:
        do {
            $klauze = <AFILE>;
            unless (defined($klauze)) {  #když se narazí na konec souboru, přeskoč zbytek
                close(AFILE); 
                open(AFILE, $ARGV[1]); 
                if ($opakovani == 1) {
                    goto PRESKOCENO;
                }
                else {
                    $opakovani = 1;
                    goto OPAKOVAT;
                }    
            }
        } until ($klauze =~ m/$id/);
        do {
            $klauze = <AFILE>;   
        } until ($klauze =~ m/<clause_number>(.+)<\/clause_number>/);
        print " $1\n";
        PRESKOCENO:
    }
    if ($_ =~ m/<\/s/) {
        print "\n"; 
    }
}  
print "\n"; #celý soubor zpracován, odděluji prázdným řádkem  
