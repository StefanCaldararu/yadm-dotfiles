return {
		"protesilaos/tempus-themes-vim",
		lazy = false,
		priority = 1000,
		config = function()
				vim.opt.termguicolors = true
				vim.cmd.colorscheme("tempus_future")
		end,
}

