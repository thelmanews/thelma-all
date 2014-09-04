#!/bin/sh

repo=~/Projects/thelma_components/development/thelma-charts
dev_dir=~/Projects/thelma_components/development

GIT_USERNAME='sepans'

#cd $repo
prefix='th-'

all_files=(`cd $repo && ls $prefix*`)
#printf -- '%s\n' "${all_files[@]}"
#echo '======='

count=0
for i in `find $repo -name $prefix'*.html' -type f`; do
	echo $i
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

	# not working
	#cd $repo
	#git filter-branch --index-filter `git rm --cached -r --ignore-unmatch  $otherFiles` --prune-empty -- --all
	
	cd $dev_dir
	mkdir $componentName 
	cd $componentName

	pwd

	

	echo $count
	count=$((count+1))
done

/usr/bin/expect << EOF

	pwd

	spawn yo polymer:seed

	expect "What is your GitHub username?"
	send "$GIT_USERNAME\r"

	expect "What is your element's name:"
	send "\r"

	expect "Answer:"
	send "1\r"

	expect eof

EOF