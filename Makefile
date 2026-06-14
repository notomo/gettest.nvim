include spec/.shared/neovim-plugin.mk

spec/.shared/neovim-plugin.mk:
	git clone https://github.com/notomo/workflow.git --depth 1 spec/.shared

export REQUIREALL_IGNORE_MODULES:=%.test%.example,nvim%-treesitter

deps: nvim-treesitter

# The specs need nvim-treesitter parsers, but the parser install runs as an async
# job that does not complete inside ntf's headless worker processes. Pre-install
# them in a normal nvim into the on-runtimepath install dir; the specs then find
# them via has_parser and skip installing.
test: FORCE deps
	$(MAKE) requireall
	nvim --headless -i NONE -n +"luafile ${SPEC_DIR}/install_parsers.lua" +"quitall!"
	$(NTF) --shuffle ${SPEC_DIR}
