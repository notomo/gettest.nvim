PLUGIN_NAME:=$(basename $(notdir $(abspath .)))
SPEC_DIR:=./spec/lua/${PLUGIN_NAME}
NVIM_TREESITTER:=./spec/lua/nvim-treesitter

test: $(NVIM_TREESITTER)
	vusted --shuffle ${SPEC_DIR}
.PHONY: test

$(NVIM_TREESITTER):
	git clone https://github.com/nvim-treesitter/nvim-treesitter.git $@

doc:
	rm -f ./doc/${PLUGIN_NAME}.nvim.txt ./README.md
	PLUGIN_NAME=${PLUGIN_NAME} nvim --headless -i NONE -n +"lua dofile('${SPEC_DIR}/doc.lua')" +"quitall!"
	cat ./doc/${PLUGIN_NAME}.nvim.txt ./README.md
.PHONY: doc
