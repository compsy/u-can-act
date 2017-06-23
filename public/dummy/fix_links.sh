#!/usr/bin/env sh
chmod -R 755 mentor student

cd mentor
index=`cat index.html | sed -e 's/\.\/index_files/\/dummy\/mentor\/index_files/g'`
index=`echo $index | sed -e 's/http:\/\/vsv.dev\/questionnaire\/[0-9a-z]*/\/dummy\/mentor\/questionnaire.html/g'`

questionnaire=`cat questionnaire.html | sed -e 's/\.\/questionnaire_files/\/dummy\/mentor\/questionnaire_files/g'`
questionnaire=`echo $questionnaire | sed -e 's/form action="http:\/\/vsv.dev\/"/form action="\/dummy\/mentor" method="GET"/g'`

echo $index > index.html
echo $questionnaire > questionnaire.html
cd -

cd student
index=`cat index.html | sed -e 's/\.\/index_files/\/dummy\/student\/index_files/g'`
index=`echo $index | sed -e 's/form action="http:\/\/vsv.dev\/"/form action="\/dummy\/student\/klaar.html" method="GET"/g'`

klaar=`cat klaar.html | sed -e 's/verdienen\./verdienen\.\<br\>\<a href="\/dummy\/student"\>Keer terug\<\/a\>/g'`
klaar=`echo $klaar | sed -e 's/form action="http:\/\/vsv.dev\/"/form action="\/dummy\/student\/klaar.html" method="GET"/g'`

echo $index > index.html
echo $klaar > klaar.html
#echo $questionnaire > questionnaire2.html
cd -

