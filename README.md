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
