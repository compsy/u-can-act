#!/bin/bash
oldfile=public/javascripts/translations_old.js
newfile=public/javascripts/translations.js
git checkout -- $newfile
cp $newfile $oldfile
bundle exec rake i18n:js:export
files_are_different=$(cmp $oldfile $newfile)
rm -f $oldfile
if [ "$files_are_different" != "" ]; then
	echo files are different!
	echo $files_are_different
	exit 1
fi
