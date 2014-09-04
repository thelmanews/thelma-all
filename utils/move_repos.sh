#!/bin/sh

dev_dir=~/Projects/thelma_components/move
repo=$dev_dir/thelma-charts
seed_dir=$dev_dir/seed-element

GIT_USERNAME='sepans'

#cd $repo
prefix='th-'

all_files=(`cd $repo && ls $prefix*`)
#printf -- '%s\n' "${all_files[@]}"
#echo '======='

count=0
for i in `find $repo -name $prefix'*.html' -type f`; do
	echo $i
	if [ $count -gt 1 ] ; then
		break;
	fi
	#remove the path
	componentFilename=${i/$repo\//''}
	componentName=${componentFilename/.html/''}
	#ls -l "$repo/!($componentFilename)"
	#ls -l "$repo/!(utility.js)"
	
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
	cp -r $seed_dir/* $componentName

	echo 'copyting component file'
	cp $repo/$componentFilename $componentName/$componentFilename
	
	echo 'copyting bower.json file (needs to be trimmed if needed)'
	cp $repo/bower.json $componentName/bower.json

	echo 'removing see-element files'
	rm  $componentName/seed-element.*

	echo 'remname test file'
	mv  $componentName/tests/seed-element-basic.html $componentName/tests/$componentName-basic.html

	echo 'replaceing seed-element with component name'
	replace=s/seed-element/$componentName/g
	sed -i '' $replace $componentName/*.html $componentName/README.md $componentName/tests/*.html



	echo 'creating repo'
	cd $componentName
	git init
	git add .
	git commit . -m '.'


	
	github_response=$(curl -u "sepans" -H "Content-Type: application/json" -d '{"name":"'"$componentName"'","private":false, "team_id": 867465}' https://api.github.com/orgs/thelmanews/repos)
	
	# #curl -u "sepans" -H "Content-Type: application/json" -d '{"name":""$componentName"","private":false, "team_id": 867465}' https://api.github.com/orgs/thelmanews/repos

	echo $github_response
	
	github_url=https://github.com/thelmanews/$componentName.git

	echo $github_url

	git remote add origin "$github_url"

	git push origin master 


	echo $count
	count=$((count+1))
done

# /usr/bin/expect << EOF

# 	pwd

# 	spawn yo polymer:seed

# 	expect "What is your GitHub username?"
# 	send "$GIT_USERNAME\r"

# 	expect "What is your element's name:"
# 	send "\r"

# 	expect "Answer:"
# 	send "1\r"

# 	expect eof

# EOF