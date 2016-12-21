#!/bin/bash

if [ "$1" = "pdf" ]; then
   cd adoc
   asciidoctor-pdf -r asciidoctor-diagram serviceregistry.adoc -D ../target -a imagesdir=../images/
   cd ..
   exit
elif [ "$1" = "html" ]; then
   asciidoctor -r asciidoctor-diagram adoc/serviceregistry.adoc -D target
   exit
elif [ "$1" = "site" ]; then
   echo "Checking for changes to the faq"
   git status
   if ! git diff-index --quiet HEAD --; then
     echo "There are uncommitted changes"
     exit 1
   fi
   rm -rf target/
   asciidoctor -r asciidoctor-diagram adoc/serviceregistry.adoc -D target
   mkdir -p target/images
   cp images/*.png target/images/
   
   git checkout gh-pages
   cp target/serviceregistry.html ../serviceregistry/index.html
   mkdir -p ../serviceregistry/images
   cp target/images/* ../serviceregistry/images/
   git add ../serviceregistry/index.html
   git add ../serviceregistry/images/*
   git commit -m "update serviceregistry documentation"
   git push
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

