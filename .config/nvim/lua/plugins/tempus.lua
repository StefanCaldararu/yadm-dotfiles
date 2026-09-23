return {
	{
		"protesilaos/tempus-themes-vim",
		lazy = false,
		priority = 1000,
	},
	-- LazyVim applies its own colorscheme (tokyonight by default) after plugins load
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = function()
				-- Use the terminal's 16-color palette, which is set to tempus
				-- (see ~/.config/tempus), so nvim matches the rest of the terminal
				-- and works in terminals without 24-bit color (macOS Terminal.app)
				vim.opt.termguicolors = false
				vim.cmd.colorscheme("tempus_future")
			end,
		},
	},
}
