source ~/.vimrc
set rtp+=~/.local/share/nvim/lazy/lazy.nvim

lua << EOF
require("lazy").setup("plugins")
