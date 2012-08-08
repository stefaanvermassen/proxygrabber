#!/bin/bash
#Dit shell script genereert een output proxies.txt bestand in de home-dir
#Auteur: Stefaan Vermassen
#6 augustus 2012
#Haalt alle proxies van hidemyass.com/proxy-list
TEMPDIR=`mktemp -d`
trap "rm -rf $TEMPDIR" EXIT
if cat ~/proxies.txt > /dev/null 2>&1;then
#	echo "proxies.txt bestond al, maar wordt nu verwijderd"
	rm ~/proxies.txt
fi
if cat ~/.curlrc > /dev/null 2>&1;then
#       echo "proxies.txt bestond al, maar wordt nu verwijderd"
        rm ~/.curlrc
fi
for i in {1..1}
do
	curl -s http://www.hidemyass.com/proxy-list/$i > "$TEMPDIR/$i"
	sed -n '
/^\./{
	H
	d
}
/<\/style><span/{
	G
	s/\n/£/g
	s/.\(.\{4\}\){display:none}/@\1@/g
	:a
	s/<span class="\(....\)"[^<]*\(.*@\1@\)/\2/g
	ta
	s/<span style="display:none">\(\.[0-9][0-9]\)[^<]*/>\1</g
	s/<span style="display:none">[^<]*//g
	s/<div style="display:none">[^<]*//g
	s/>\.*\([0-9][0-9]*\.*[0-9]*\)\.*</\#\1\.ù/g
	s/^[^#]*//g
	s/ù[^#]*#//g
	s/£/\n/g
	s/#//g
	s/\.ù.*//g
	s/\.\././g
	N
	N
	s/\n *<td>\n\([0-9]*\).*/:\1/
	p
}
' "$TEMPDIR/$i" >> ~/proxies.txt
done