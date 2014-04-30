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
        $nextline = <MFILE>;
        $nextline = <MFILE>;
        $nextline =~ m/.*<tag>(..).*/;
        print "_$1 ";
        
    }
    if ($_ =~ m/<\/s/) {
        print "\n"; 
    }
}  
print "\n"; #celý soubor zpracován, odděluji prázdným řádkem  
