include spec/.shared/neovim-plugin.mk

spec/.shared/neovim-plugin.mk:
	git clone https://github.com/notomo/workflow.git --depth 1 spec/.shared

export REQUIREALL_IGNORE_MODULES:=%.test%.example

deps: nvim-treesitter
