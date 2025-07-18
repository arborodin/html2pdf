#!/bin/sh

# A script to automatically generate pdf Neovim documentation from the html files.

main_dir="file-documentation"
html_dir="pages-html"
tex_dir="pages-tex"
pdf_dir="pages-pdf"

mkdir -p $main_dir && cd "$_"
mkdir -p $html_dir $tex_dir $pdf_dir

# Downloading the pages;
echo "Downloading the files..."
wget -r --no-parent --no-directories -A.html -P $html_dir -o log https://neovim.io/doc/user/
echo "Downloading finished."

# Converting the pages to pdf;
for f in $(ls -1 $html_dir | sed -e 's/\.html$//'); do
    echo "Converting $f.html to $f.tex to $f.pdf."
    pandoc -s $html_dir/$f.html -o $tex_dir/$f.tex
    lualatex $tex_dir/$f
    mv $f.pdf $pdf_dir
    clear
done

# Compiling the pages into the document;
echo "Stitching the files into a document..."
pdfunite $pdf_dir/* pages-compilation.pdf
echo "Stitching completed."

find . -not \( -name "*.html" -or -name "*.tex" -or -name "*.pdf" \) -type f -delete