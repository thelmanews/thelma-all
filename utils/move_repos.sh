#!/bin/sh

dev_dir=~/Projects/thelma_components/move
repo=$dev_dir/thelma-charts
seed_dir=$dev_dir/seed-element

GIT_USERNAME='sepans'
GIT_PASSWORD=''

echo  'github Password for user $GIT_USERNAME (to push repos to github.com):' 
read -s GIT_PASSWORD

#cd $repo
prefix='th-'

all_files=(`cd $repo && ls $prefix*`)
#printf -- '%s\n' "${all_files[@]}"
#echo '======='

count=0
for i in `find $repo -name $prefix'*.html' -type f`; do
	echo $i
	
	# if [ $count -gt 2 ] ; then
	# 	break;
	# fi

	#remove the path
	componentFilename=${i/$repo\//''}
	componentName=${componentFilename/.html/''}
	
	otherFiles=${all_files[@]/$componentFilename}

	#echo $otherFiles

	# not working
	#cd $repo
	#git filter-branch --index-filter `git rm --cached -r --ignore-unmatch  $otherFiles` --prune-empty -- --all
	
	cd $dev_dir
	pwd
	echo '# component name '$componentName
	mkdir $componentName 

	echo 'copyting seed directory'
	cp -r $seed_dir $componentName

	echo 'copyting component file'
	cp $repo/$componentFilename $componentName/$componentFilename
	
	echo 'copyting bower.json file (needs to be trimmed if needed)'
	cp $repo/bower.json $componentName/bower.json
	bower_replace=s/thelma-components/$componentName/g
	#replace thelma-components with component name in bower.json
	sed -i '' $bower_replace $componentName/bower.json

	echo 'removing see-element files'
	rm  $componentName/seed-element.*

	echo 'remname test file'
	mv  $componentName/tests/seed-element-basic.html $componentName/tests/$componentName-basic.html

	echo 'replaceing seed-element with component name'
	replace=s/seed-element/$componentName/g
	sed -i '' $replace $componentName/*.html $componentName/README.md $componentName/tests/*.html



	echo 'creating repo locally'
	cd $componentName
	git init
	git add .
	git commit . -m '.'


	
	# echo 'pushing to github'
	# github_response=$(curl --user "$GIT_USERNAME:$GIT_PASSWORD" -H "Content-Type: application/json" -d '{"name":"'"$componentName"'","private":false, "team_id": 867465}' https://api.github.com/orgs/thelmanews/repos)
	# echo $github_response
	
	#TODO: use github_response to get repo url
	
	# github_url=git@github.com:thelmanews/$componentName.git

	# echo $github_url

	# git remote add origin "$github_url"

	# git push origin master 


	echo $count
	count=$((count+1))
done