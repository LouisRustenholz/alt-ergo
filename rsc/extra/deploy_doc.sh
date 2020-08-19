#!/bin/bash -ve

# === deploy_doc ===
#
# This script automates the process of updating
# the online documentation by building the html doc,
# checking out gh-pages, and copying all the necessary
# files. Travis will automatically commit the changes
# and push it to the repo

# Legacy ODOC directory hidden in a ODOC_DIR folder
VERSION=$1
OLD_ODOC_DIR := "odoc"

# Cd to the extra dir regardless of where the script was called
git_repo=`git rev-parse --show-toplevel`
cd $git_repo

# Generate documentation, or rather check that it
# has correctly been built.
make doc

# Generate version index page
(cd rsc/extra && asciidoc index.adoc)

# Checkout gh-pages
git fetch origin +gh-pages:gh-pages
git checkout gh-pages

# Create necessary directories if they do not exists
mkdir -p $(OLD_ODOC_DIR)
mkdir -p $(OLD_ODOC_DIR)/$VERSION

# Copy doc to the right locations
cp -r _build/sphinx_docs_html ./
cp rsc/extra/index.html ./$(OLD_ODOC_DIR)/
cp -r _build/default/_doc/_html/* ./$(OLD_ODOC_DIR)/$VERSION/

# Clean build artifacts
rm -rf _build
rm Makefile.config
rm -rf rsc/extra/index.html
rm -rf src/bin/text/flags.dune
rm -rf src/lib/util/config.ml
