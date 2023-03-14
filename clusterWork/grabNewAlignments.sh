#! /bin/bash -ef


workingDir=/work/cf189/29Pairwise
checkDir=/work/cf189/chainingNetting/27Way
echo "Started"

	for SD in `find $workingDir -maxdepth 1 -type d`
	do
		if [[ $SD != $workingDir ]]; then 
		name=${SD##*/}
        	target=${name%.*}
        	query=${name##*.}

		if [[ $query != "byChrom" && ! -e $checkDir/$target.$query ]]; then

			for dir in `find $SD -maxdepth 1 -type d`
			do
	
				tBin=${dir##*/}
				outPath=/work/cf189/chainingNetting/27V2/$target.$query
				mkdir -p $outPath
				outFile=/work/cf189/chainingNetting/27V2/$target.$query/$target.$tBin.$query.axt
                	        touch $outFile
				rm $outFile
				touch $outFile

				for file in `find $dir -maxdepth 1 -type f`
				do	
					ext=${file##*.}

					if [[ $ext == "axt" ]]; then
						
						cat $file >> $outFile		
fi
done	
done
fi	
fi
done
echo "Done"
