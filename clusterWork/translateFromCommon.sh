#! /bin/bash -ef

allDist=campDist.txt
specFile=speciesTranslate.txt
while read word1 word2 word3 
do
        while read name1 name2
        do
                if [[ "$word1" == "$name2" ]]; then
                        sed -i "s/$word1/$name1/g" $allDist
                         fi
                if [[ "$word2" == "$name2" ]]; then
                        sed -i "s/$word2/$name1/g" $allDist
                fi

        done < $specFile

done < $allDist
