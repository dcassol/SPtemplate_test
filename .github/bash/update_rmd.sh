#!/bin/bash
set -e
# git_link is the http git link of a repo
git_link=${1}
# update_dir is what is the folder path in website you want to copy to
update_dir=${2}
down_folder="/tmp/${update_dir}"
folder_base=$(basename ${update_dir})

# print info
echo ${update_dir}
echo ${git_link}

# clean temp
echo "Clean dwonload folder ${down_folder}"
rm -rf ${down_folder}
# clone repo
echo "Downloading ${update_dir} to \"${down_folder}\""
git clone ${git_link} ${down_folder}

# update
echo "Clean update folder ${update_dir}"
rm -rf ${update_dir}
mkdir -p ${update_dir}
# copy
echo "Update files"
cp -r ${down_folder}/vignettes/systemPipeRIBOseq.Rmd ${update_dir}
cp -r ${down_folder}/vignettes/bibtex.bib ${update_dir}
cp -r ${down_folder}/vignettes/results/* ${update_dir}/results/
echo "done"

# copy to inst
echo "Update inst files"
cp -r ${down_folder}/vignettes/systemPipeRIBOseq.Rmd inst/extdata/workflows/riboseq/
cp -r ${down_folder}/vignettes/bibtex.bib inst/extdata/workflows/riboseq/
cp -r ${down_folder}/vignettes/results/* inst/extdata/workflows/riboseq/results/
cd inst/extdata/workflows/riboseq/
Rscript -e "rmarkdown::render('systemPipeRIBOseq.Rmd', c('BiocStyle::html_document'), clean=T); knitr::knit('systemPipeRIBOseq.Rmd', tangle=TRUE)"
rm -rf *cache/
echo "done"

