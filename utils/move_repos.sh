#!/bin/sh

repo='../../../move/thelma-charts'

#cd $repo
prefix='th-'

all_files=(`cd $repo && ls $prefix*`)
#printf -- '%s\n' "${all_files[@]}"
#echo '======='

count=0
for i in `find $repo -name $prefix'*.html' -type f`; do
	#echo $i
	if [ $count -gt 0 ] ; then
		break;
	fi
	componentFilename=${i/..\/..\/thelma-charts\//''}
	componentName=${componentFilename/.html/''}
	echo $componentFilename
	echo 'rest ---'
	#ls -l "$repo/!($componentFilename)"
	#ls -l "$repo/!(utility.js)"
	
	otherFiles=${all_files[@]/$componentFilename}

	echo $otherFiles

	cd $repo
	git filter-branch --index-filter `git rm --cached -r --ignore-unmatch  $otherFiles` --prune-empty -- --all


	echo $count
	count=$((count+1))
done


