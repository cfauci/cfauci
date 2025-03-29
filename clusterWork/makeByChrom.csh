#!/bin/csh -efv

#set faSplit = /hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/faSplit
set faFilter = $GOBIN/faFilter
set faBin = $GOBIN/faBin
foreach line (`cat /work/cf189/campLabAlignmentSupport/elephant.txt`)
set genome=/hpc/group/vertgenlab/RefGenomes/vertCons/$line/$line.fa

set dir = /hpc/group/vertgenlab/vertebrateConservation/pairwise
set mbDir = /work/cf189/pairwise/mbByChroms
set testDir = /work/cf189/testBinning
set dir29 = /work/cf189/29Pairwise
set campDir=/work/cf189/campLabPairwise
mkdir -p $campDir/$line.byChrom

#faSize -detailed $genome > $prefix.chrom.sizes
#faToTwoBit $genome $prefix.2bit
zcat $genome.gz | $faFilter -minSize=20000 stdin stdout | $faBin -minSize=100000000 -assembly=$line stdin $campDir/$line.byChrom/
#zcat $genome.gz | $faSplit sequence stdin 10 $testDir/$line.10Bin/
echo $genome
end
echo DONE
#echo "inputs: " $prefix
