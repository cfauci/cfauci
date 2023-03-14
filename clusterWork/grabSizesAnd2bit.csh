#!/bin/csh -ef

foreach line (`cat /work/cf189/campLabAlignmentSupport/speciesList.txt`)
set sizes=/hpc/group/vertgenlab/RefGenomes/vertCons/$line/$line.chrom.sizes
set bit=/hpc/group/vertgenlab/RefGenomes/vertCons/$line/$line.2bit

set outSizes=/work/cf189/chainingNetting/supportFiles/$line.chrom.sizes
set outBit=/work/cf189/chainingNetting/supportFiles/$line.2bit

cat $sizes > $outSizes
cat $bit > $outBit

end
