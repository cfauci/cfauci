#!/bin/csh -ef

foreach species (`cat /work/cf189/chainingNetting/supportFiles/speciesList.txt`)

touch calJac4.$species.bed
rm calJac4.$species.bed
touch calJac4.$species.bed
echo $species

if ($species != "calJac4") then

foreach b (../calJac4.*.$species.syntenic.bed) 
	
	cat $b >> calJac4.$species.bed

end
endif
end 
echo DONE
