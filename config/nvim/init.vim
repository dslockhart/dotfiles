lua require('init')
call plug#begin()

Plug 'nvim-neotest/nvim-nio'
Plug 'ryanoasis/vim-devicons'
" Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'nvim-lualine/lualine.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
call plug#end()
" call wilder#setup({'modes': [':', '/', '?']})
" call wilder#set_option('renderer', wilder#popupmenu_renderer({
"       \ 'highlighter': wilder#basic_highlighter(),
"       \ 'left': [
"       \   ' ', wilder#popupmenu_devicons(),
"       \ ],
"       \ 'right': [
"       \   ' ', wilder#popupmenu_scrollbar(),
"       \ ],
"       \ }))
"lua <<EOF
