#!/bin/csh -e

set lastz=/hpc/group/vertgenlab/softwareShared/lastz-master/src/lastz
set m=true
set pairwise=/work/cf189/campLabPairwise
set speciesList=/work/cf189/campLabAlignmentSupport/opossumPlatypusList.txt
set refList=/work/cf189/campLabAlignmentSupport/chickStickList.txt
set allDists=/work/cf189/campLabAlignmentSupport/campDist.txt
set out=lastZJobsMarsupials.txt
set lastZWriter=$GOBIN/lastZWriter

$lastZWriter $lastz $pairwise $speciesList $refList $allDists $out
