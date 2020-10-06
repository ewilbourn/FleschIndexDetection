#!/bin/bash
echo -e "Language   Translation   Flesch   Flesch-Kincaid   Dale-Chall"
c++ ./c++/flesch.cpp
a.out ASV
a.out BBE
a.out DARBY
a.out DRB
a.out KJ21
a.out KJV
a.out NAB
a.out NASB
a.out NIV
a.out NKJV
a.out NLT
a.out WEB
a.out YLT

javac ./java/flesch.java
java -classpath ./java/ flesch ASV
java -classpath ./java/ flesch BBE
java -classpath ./java/ flesch DARBY
java -classpath ./java/ flesch KJ21
java -classpath ./java/ flesch KJV
java -classpath ./java/ flesch NAB
java -classpath ./java/ flesch NASB
java -classpath ./java/ flesch NIV
java -classpath ./java/ flesch NKJV
java -classpath ./java/ flesch NLT
java -classpath ./java/ flesch WEB
java -classpath ./java/ flesch YLT


perl ./perl/flesch.pl ASV
perl ./perl/flesch.pl BBE
perl ./perl/flesch.pl DARBY
perl ./perl/flesch.pl KJ21
perl ./perl/flesch.pl KJV
perl ./perl/flesch.pl NAB
perl ./perl/flesch.pl NASB
perl ./perl/flesch.pl NIV
perl ./perl/flesch.pl NKJV
perl ./perl/flesch.pl NLT
perl ./perl/flesch.pl WEB
perl ./perl/flesch.pl YLT


python3 ./python/flesch.py ASV
python3 ./python/flesch.py BBE
python3 ./python/flesch.py DARBY
python3 ./python/flesch.py KJ21
python3 ./python/flesch.py NAB
python3 ./python/flesch.py NASB
python3 ./python/flesch.py NIV
python3 ./python/flesch.py NKJV
python3 ./python/flesch.py NLT
python3 ./python/flesch.py WEB
python3 ./python/flesch.py YLT

gfortran ./fortran/flesch.f95
a.out ASV.txt
a.out BBE.txt
a.out DARBY.txt
a.out DRB.txt
a.out KJ21.txt
a.out KJV.txt
a.out NAB.txt
a.out NASB.txt
a.out NIV.txt
a.out NKJV.txt
a.out NLT.txt
a.out WEB.txt
a.out YLT.txt







