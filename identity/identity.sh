#!/bin/bash

if [ "$1" = "pdf" ]; then
   cd adoc
   asciidoctor-pdf -r asciidoctor-diagram identity.adoc -D ../target
   cd ..
   exit
elif [ "$1" = "html" ]; then
   asciidoctor -r asciidoctor-diagram adoc/identity.adoc -D target
   exit
elif [ "$1" = "site" ]; then
   echo "Checking for changes to the faq"
   git status
   if ! git diff-index --quiet HEAD --; then
     echo "There are uncommitted changes"
     exit 1
   fi
   asciidoctor -r asciidoctor-diagram adoc/identity.adoc -D target
   mkdir -p target/images
   cp images/*.png target/images/
   echo "XXXXXXXXXX"
   exit
   
   git checkout gh-pages
   cp target/identity.html ../identity/index.html
   mkdir ../identity/images
   cp target/images/* ../identity/images/
   git add ../identity/index.html
   git add ../identity/images/*
   git commit -m "update identity documentation"
   git push
   exit
   git checkout master
   exit   
elif [ -z "$1" ]; then 
	echo Usage: $0 target
	echo where target is:
else
	echo Unknown target: "$1"
	echo Valid targets are:
fi

echo "  pdf        Generates documentation in pdf"
echo "  html       Generates documentation in html"

