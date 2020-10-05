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













