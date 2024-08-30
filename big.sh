#!/bin/bash



set -e

mkdir -p TCLB
cd TCLB
if ! test -d ".git"
then
	git init
fi

for i in $@
do
	echo "$i..."
	if ! git remote | grep $i >/dev/null
	then
		git remote add $i git@github.com:$i/TCLB.git
	fi
	git fetch $i
done

#../git-big-picture/git-big-picture -g | tred >../big.dot
../git-big-picture/git-big-picture -g >../big.dot

cd ..

colors=(brown1 coral cadetblue2 aquamarine bisque gold1 darkseagreen1)

j=3
for i in $@
do
	cat big.dot | gvpr -c "N[label=='$i*']{$.color='/pastel19/$j';}" >big_.dot
	mv big_.dot big.dot
	j=$[j+1]
done

cat big.dot | dot -T pdf -o big.pdf
