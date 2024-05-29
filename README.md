# Python official API documentation itegrated with Neovim help files

This plugin is not related to pydoc. It takes the pages from https://docs.python.org/3/ and turns them into vim help files.

This plugin is 90% a copy of https://github.com/girishji/pythondoc.vim, which is based on https://github.com/sphinx-contrib/vimbuilder to compile shpinx documentations into vim help files.

In addition to pythondoc.vim, this plugin let's you choose between Python versions: 3.8, 3.9. 3.10. 3.11, 3.12.

## Install

Install via your preffered package manager.

`RazorBest/pydoc.nvim`


## Setup

Setup the plugin in your `init.lua`

```lua
-- setup with defaults
require("pydoc-nvim").setup()

-- or setup with specific python version
require("pydoc-nvim").setup({
    version = "3.9"
})
```

## Commands

`:PyDocVersion <version>` change the version of the documentation


## Updating the docs

The python documentations are stored in vim-help format, in the `python_docs`
directory. They are taken from the cpython repository and compiled from rst
using sphinx.

In order to update all the versions, run from the root of this repo:

`./build_python_docs.sh`

This script permforms the following:
- Clones the Python repo in tmp/cpython
- Extracts the available versions greater than `MIN_VERSION`
- Checks out on every version and performs the following, for each:
   * Installs the virtual environment for the `Doc` and `vimbuilder`
   * Modifies `Doc/conf.py` for `vimbuilder`
   * Creates a makefile that runs sphinx with the `vimbuilder` extension
   * Runs the makefile
   * Copies the built files in `python_docs`, in the corresponding version
   * Adds the Python version at the beginning of all the help files
   * Runs vim helptags on the files
