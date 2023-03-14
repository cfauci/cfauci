#!/bin/csh -exf
set db = "hg38"
set threshold = 0.33
mkdir -p coverageCalls
rm -rf coverageCalls
mkdir coverageCalls


 /hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/overlapSelect -mergeOutput /work/cf189/birthData/allSpecies.bed hg38PhastCons100WayUnique.bed stdout \
| /work/cf189/birthData/punchHolesInBed.pl /dev/stdin coverageCalls/tmp.a.bed

 foreach x (`cat ../speciesNode.list`)

	set species = $x:r
        set node = $x:e
        echo $species $node

        /hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/overlapSelect -aggregate -overlapThreshold=$threshold /work/cf189/birthData/alignmentData/$db.wholeGenomes/$db.$species.bed coverageCalls/tmp.a.bed coverageCalls/tmp.out.bed

        cat coverageCalls/tmp.out.bed >> coverageCalls/node"$node".conservation.bed
        cat coverageCalls/tmp.out.bed | cut -f 4 | awk -v "NODE=$node" '{ print $1"\t"NODE }' >> coverageCalls/cneNode.tsv 

        /hpc/group/vertgenlab/softwareShared/kent/kent.Jul.30.2021/overlapSelect -nonOverlapping coverageCalls/node"$node".conservation.bed coverageCalls/tmp.a.bed coverageCalls/tmp.b.bed

        mv coverageCalls/tmp.b.bed coverageCalls/tmp.a.bed

        rm coverageCalls/tmp.out.bed
end
  
mv coverageCalls/tmp.a.bed coverageCalls/refSpecific.bed
wc -l coverageCalls/refSpecific.bed

echo DONE
