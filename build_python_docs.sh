set -e

MIN_VERSION=v3.8
VIMCMD=vim

verlte() {
    [  "$1" = "`echo -e "$1\n$2" | sort -V | head -1`" ]
}

init_repo() {
    mkdir tmp
    git clone --depth 1 https://github.com/python/cpython.git tmp/cpython
    cd tmp/cpython
    git fetch --depth 1 origin 'refs/tags/*:refs/tags/*'
    cd ../../
}

remove_repo() {
    rm -rf tmp
}

cleanup_python_repo() {
    git restore .
    git clean -f
    cd Doc
    rm -r venv
    rm -r build
    cd ..
}

compile_doc() {
    # Remove the prefix "v" from the version
    version=${1#"v"}
    major=${version%.*}
    echo Compiling $version

    # Switch to the desired version
    git checkout v$version
    cd Doc

    # Setup the python environment
    echo -e "\nvimbuilder" >> requirements.txt
    make venv
    source ./venv/bin/activate

    # Add vimbuilder to conf.py
    echo -e '\nextensions.append("vimbuilder")\nvimhelp_filename_extension = "pyx"' >> conf.py

    # Create a new Makefile that builds the vim help files
    TAB="$(printf '\t')"
    cat >Makefile.vimhelp <<EOL
include Makefile

.PHONY: build
build:
${TAB}-mkdir -p build
${TAB}\$(SPHINXBUILD) \$(ALLSPHINXOPTS)
${TAB}@echo

vimhelp: BUILDER = vimhelp
vimhelp: build
${TAB}@echo "Build finished. The vimhelp pages are in build/vimhelp."
EOL
    
    # Prefix the files in the howto folder with "howto-"
    # Also, rename all the references we know about
    sed -i 's/howto\/index.rst/howto\/howto-index.rst/g' contents.rst
    cd howto
    for file in $(ls *.rst); do mv $file howto-$file; done
    sed -i 's/\([^[:space:]]*.rst\)/howto-\1/g' howto-index.rst
    cd ..

    # Build the help files
    make -f Makefile.vimhelp vimhelp

    echo "Built help files"
    
    echo "Written tags"
    
    # Copy the built files
    mkdir -p ../../../python_docs/doc_py$major/
    rm -rf ../../../python_docs/doc_py$major/* 
    mkdir -p ../../../python_docs/doc_py$major/doc
    cp -r build/vimhelp/library/* ../../../python_docs/doc_py$major/doc
    cp -r build/vimhelp/howto/* ../../../python_docs/doc_py$major/doc
    cp -r build/vimhelp/tutorial/* ../../../python_docs/doc_py$major/doc

    for file in $(ls ../../../python_docs/doc_py$major/doc/*.pyx); do
        sed -i "1s/^/Python ${version}\n/" "$file"
    done

    "$VIMCMD" "+silent! :helptags ../../../python_docs/doc_py$major/doc | q"
    
    cd ..
    cleanup_python_repo
}

init_repo

cd tmp/cpython
# Get all major versions
ALL_VERSIONS=$(for tag in $(git tag -l | grep "^v"); do echo ${tag%.*}; done | sort -V | uniq)
VERSIONS=$(
    for tag in $ALL_VERSIONS; do
        if verlte $MIN_VERSION $tag; then
            echo $tag
        fi
    done
)

echo $VERSIONS

for major in $VERSIONS; do
    version=$(git tag -l | grep "^${major}\.[0-9]*$" | sort -rV | head -1)
    if [ -z $version ]; then
        continue
    fi
    compile_doc $version
done

remove_repo
