#!/bin/bash

green='\033[1;92m'
off='\033[0m' 
yellow='\033[1;93m'

echo -e "${green}Creating necessary directories...${off}\n"
if [ ! -d "./latex" ]; then
    mkdir ./latex
else
    rm -rf ./latex
    mkdir ./latex
fi

if [ ! -d "./book" ]; then
    mkdir ./book
else
    rm -rf ./book
    mkdir ./book
fi
echo -e "${yellow}Done..${off}\n"


echo -e "${green}Processing preface and introduction...${off}\n"
pandoc text/pre.txt --lua-filter=epigraph.lua --to markdown | \
    pandoc --top-level-division=chapter --to latex \
    > latex/1pre.tex

pandoc text/intro.txt --lua-filter=epigraph.lua --to markdown | \
    pandoc --top-level-division=chapter --to latex \
    > latex/2intro.tex
echo -e "${yellow}Done..${off}\n"


echo -e "${green}Processing chapters...${off}\n"
for chapter in text/ch*.txt; do
    basename="$(echo $chapter | sed -n 's/^\(.*\/\)*\(.*\)/\2/p' | sed "s/\..*//")" 
    echo -e "${green}Converting $chapter to $basename.tex"
    pandoc --lua-filter=extras.lua "$chapter" --to markdown | \
    pandoc --lua-filter=contribution.lua --to markdown | \
    pandoc --lua-filter=extras.lua --to markdown | \
    pandoc --lua-filter=epigraph.lua --to markdown | \
    pandoc --lua-filter=figure.lua --to markdown | \
    pandoc --filter=pandoc-fignos --to markdown | \
    pandoc --metadata-file=meta.yml \
    --top-level-division=chapter \
    --citeproc \
    --bibliography=bibliography/"$basename.bib" \
    --reference-location=section \
    --to latex > "latex/3$basename.tex"
done
echo -e "${yellow}\nDone..${off}\n"


echo -e "${green}Processing appendixes...${off}\n"
for appendix in text/apx*.txt; do
    basename="$(echo $appendix | sed -n 's/^\(.*\/\)*\(.*\)/\2/p' | sed "s/\..*//")" 
    pandoc --lua-filter=extras.lua "$appendix" --to markdown | \
    pandoc --lua-filter=contribution.lua --to markdown | \
    pandoc --lua-filter=extras.lua --to markdown | \
    pandoc --lua-filter=epigraph.lua --to markdown | \
    pandoc --lua-filter=figure.lua --to markdown | \
    pandoc --filter=pandoc-fignos --to markdown | \
    pandoc --metadata-file=meta.yml \
    --top-level-division=chapter \
    --citeproc \
    --bibliography=bibliography/"$basename.bib" \
    --reference-location=section \
    --to latex > "latex/4$basename.tex"
done
echo -e "${yellow}Done..${off}\n"


echo -e "${green}Processing web and biography...${off}\n"
pandoc text/web.txt --lua-filter=epigraph.lua --to markdown \
  | pandoc --top-level-division=chapter --to latex > latex/5web.tex

pandoc text/bio.txt --lua-filter=epigraph.lua --to markdown \
  | pandoc --top-level-division=chapter --to latex > latex/6bio.tex
echo -e "${yellow}Done..${off}\n"


echo -e "${green}Merging everything into a pdf...${off}\n"
pandoc -s -N --quiet \
    --variable "geometry=margin=1.2in" \
    --variable mainfont="Noto Sans Regular" \
    --variable sansfont="Noto Sans Regular" \
    --variable monofont="Noto Sans Mono" \
    --variable fontsize=12pt \
    --variable version=2.0 \
    latex/*.tex \
    --pdf-engine=xelatex \
    --toc -o book/book.pdf
echo -e "${yellow}Done..${off}"
