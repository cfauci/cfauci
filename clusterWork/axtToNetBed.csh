#!/bin/csh -ef

set axtToPsl=/hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/axtToPsl
set chainToPsl=/hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/chainToPslBasic
set pslToBed=/hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/pslToBed
set netToBed=/hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/netToBed
set axtChain=/hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/axtChain
set chainSort=/hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/chainSort
set chainPreNet=/hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/chainPreNet
set chainFilter=/hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/chainFilter
set chainNet=/hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/chainNet
set netSyntenic=/hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/netSyntenic
set netFilter=/hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/netFilter
set netClass=/hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/netClass
set netToBed=/hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/netToBed
set netToAxt=/hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/netToAxt
set axtToMaf=/hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/axtToMaf
set multiz=/hpc/group/vertgenlab/softwareShared/multiz-tba.012109/multiz
set temp=/work/cf189/chainingNetting/temp/campLab


foreach ref (`cat /work/cf189/chainingNetting/supportFiles/refList.txt`)
set tSize=/work/cf189/chainingNetting/supportFiles/$ref.chrom.sizes
set tBit=/work/cf189/chainingNetting/supportFiles/$ref.2bit

foreach species (`cat /work/cf189/chainingNetting/supportFiles/speciesList.txt`)
set qSize=/work/cf189/chainingNetting/supportFiles/$species.chrom.sizes
set qBit=/work/cf189/chainingNetting/supportFiles/$species.2bit

foreach dist (`cat /work/cf189/chainingNetting/supportFiles/campDistComma.35.txt`)
set word=($dist:as/,/ /)

if ($word[1] != "(total)") then

if (`echo $ref` == `echo $species`) then
set matrix="none"

else if (`echo $species` == `echo $word[1]` && `echo $ref` == `echo $word[2]`) then
set outDir=/work/cf189/chainingNetting/campLab/$ref.$species

if (`echo "$word[3] >= 0.7" | bc` == 1 ) then
set matrix=/work/cf189/chainingNetting/supportFiles/hoxD55.mat
else if (`echo "$word[3] <= 0.2" | bc` == 1) then
set matrix=/work/cf189/chainingNetting/supportFiles/human_chimp_v2.mat
else
set matrix=/work/cf189/chainingNetting/supportFiles/default.mat
endif

else if (`echo $species` == `echo $word[2]` && `echo $ref` == `echo $word[1]`) then
set outDir=/work/cf189/chainingNetting/campLab/$ref.$species

if (`echo "$word[3] >= 0.7" | bc` == 1) then
set matrix=/work/cf189/chainingNetting/supportFiles/hoxD55.mat
else if (`echo "$word[3] <= 0.2" | bc` == 1) then
set matrix=/work/cf189/chainingNetting/supportFiles/human_chimp_v2.mat
else
set matrix=/work/cf189/chainingNetting/supportFiles/default.mat

endif
endif
endif
end

if ($matrix:t == hoxD55.mat) then
set linearGap="loose"
set minSynScore=50000
set minChainScore=20000
#I'm guessing at some decent values, I'm going to leave minSynSize at default value for all

foreach file (`find /work/cf189/chainingNetting/campLab/$ref.$species -name "*.axt"`)
set name=$file:t:r
set tName=$file:t:r:r
set outChain=$temp/$name.filteredScore.chain
set syntenic=$temp/$name.unfilteredSyntenic.net
set outSynTarget=$outDir/$name.filteredSyn.net
set outPsl=$temp/$name.filteredNet.psl
set bed=$outDir/$name.syntenic.bed
set outAxt=$temp/$name.filteredNet.axt

$axtChain -linearGap=$linearGap -scoreScheme=$matrix $file $tBit $qBit stdout \
| $chainSort stdin stdout \
| $chainPreNet stdin $tSize $qSize stdout \
| $chainFilter -minScore=$minChainScore stdin > $outChain
$chainNet $outChain $tSize $qSize stdout /dev/null \
| $netSyntenic stdin stdout > $syntenic
$netFilter -syn -minSynScore=$minSynScore $syntenic > $outSynTarget
$netToBed -maxGap=0 $outSynTarget $bed
$netToAxt $outSynTarget $outChain $tBit $qBit $outAxt
$axtToPsl $outAxt $tSize $qSize $outPsl

end

else if ($matrix:t == human_chimp_v2.mat) then
set linearGap="medium"
set minChainScore=1000000

foreach file (`find /work/cf189/chainingNetting/campLab/$ref.$species -name "*.axt"`)
set name=$file:t:r
set tName=$file:t:r:r
set outChain=$temp/$name.filteredScore.chain
set syntenic=$temp/$name.unfilteredSyntenic.net
set outSynTarget=$outDir/$name.filteredSyn.net
set outPsl=$temp/$name.filteredNet.psl
set bed=$outDir/$name.syntenic.bed
set outAxt=$temp/$name.filteredNet.axt

$axtChain -linearGap=$linearGap -scoreScheme=$matrix $file $tBit $qBit stdout \
| $chainSort stdin stdout \
| $chainPreNet stdin $tSize $qSize stdout \
| $chainFilter -minScore=$minChainScore stdin > $outChain
$chainNet $outChain $tSize $qSize stdout /dev/null \
| $netSyntenic stdin stdout > $syntenic
$netFilter -chimpSyn $syntenic > $outSynTarget
$netToBed -maxGap=0 $outSynTarget $bed
$netToAxt $outSynTarget $outChain $tBit $qBit $outAxt
$axtToPsl $outAxt $tSize $qSize $outPsl

end

else if ($matrix:t == default.mat) then
set linearGap="medium"
set minChainScore=100000
foreach file (`find /work/cf189/chainingNetting/campLab/$ref.$species -name "*.axt"`)
set name=$file:t:r
set tName=$file:t:r:r
set outChain=$temp/$name.filteredScore.chain
set syntenic=$temp/$name.unfilteredSyntenic.net
set outSynTarget=$outDir/$name.filteredSyn.net
set outPsl=$temp/$name.filteredNet.psl
set bed=$outDir/$name.syntenic.bed
set outAxt=$temp/$name.filteredNet.axt

$axtChain -linearGap=$linearGap -scoreScheme=$matrix $file $tBit $qBit stdout \
| $chainSort stdin stdout \
| $chainPreNet stdin $tSize $qSize stdout \
| $chainFilter -minScore=$minChainScore stdin > $outChain
$chainNet $outChain $tSize $qSize stdout /dev/null \
| $netSyntenic stdin stdout > $syntenic
$netFilter -syn $syntenic > $outSynTarget
$netToBed -maxGap=0 $outSynTarget $bed
$netToAxt $outSynTarget $outChain $tBit $qBit $outAxt
$axtToPsl $outAxt $tSize $qSize $outPsl

end

else
continue

endif
end
end
echo "DONE"

