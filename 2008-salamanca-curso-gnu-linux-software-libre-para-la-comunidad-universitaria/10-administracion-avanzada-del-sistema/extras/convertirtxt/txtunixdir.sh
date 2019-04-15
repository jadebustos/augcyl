#!/bin/bash
for fichero in *.txt; do
   if grep  $fichero &>/dev/null; then
     resp=x
     while [ $resp != "s" -a $resp != "n" ]; do
       echo "'$fichero' es un fichero texto DOS. convertir? (s/n) "
       read resp
     done
     case $resp in
       s)
         sed 's///' $fichero > /tmp/FILE_TMP
         mv /tmp/FILE_TMP $fichero
	 echo "El fichero '$fichero' convertido a texto UNIX";;
       n)
         echo "El fichero '$fichero' se deja texto DOS";;
       *)
         echo "ERROR";;
     esac
   fi
done
