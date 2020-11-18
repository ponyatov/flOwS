# \ <section:vars>
MODULE       = $(notdir $(CURDIR))
OS          ?= $(shell uname)
# / <section:vars>
# \ <section:dirs>
GZ           = $(HOME)/gz
CWD          = $(CURDIR)
BIN          = $(CWD)/bin
LIB          = $(CWD)/lib
SRC          = $(CWD)/src
TMP          = $(CWD)/tmp
DOC          = $(CWD)/doc
RBIN         = $(HOME)/.cargo/bin
# / <section:dirs>
# \ <section:tools>
WGET         = wget -c
RUSTUP       = $(RBIN)/rustup
RUSTC        = $(RBIN)/rustc
CARGO        = $(RBIN)/cargo
# / <section:tools>
# \ <section:obj>
S += $(SRC)/main.rs
# / <section:obj>
# \ <section:all>
.PHONY: all
all: $(CARGO) $(S)
	$< run
# / <section:all>
# \ <section:test>
.PHONY: test
test:
# / <section:test>
# \ <section:doc>
.PHONY: doc
doc:
# / <section:doc>
# \ <section:install>
.PHONY: install
install:
	$(MAKE) $(OS)_install
	$(MAKE) doc
	$(MAKE) rust_install
.PHONY: rust_install
rust_install: $(RUSTUP)
	ls -la $^
$(RUSTUP):
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	

# / <section:install>
# \ <section:update>
.PHONY: update
update:
	$(MAKE) $(OS)_update
	$(RUSTUP) update
# / <section:update>
# \ <section:install/os>
.PHONY: Linux_install Linux_update
Linux_install Linux_update:
	sudo apt update
	sudo apt install -u `cat apt.txt`
# / <section:install/os>
# \ <section:merge>
MERGE  = README.md Makefile .gitignore apt.txt .vscode
MERGE += bin lib src tmp
# / <section:merge>

master:
	git checkout $@
	git pull -v
	git checkout shadow -- $(MERGE)

shadow:
	git checkout $@
	git pull -v

release:
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
	$(MAKE) shadow

zip:
	git archive --format zip 	--output ~/tmp/$(MODULE)_src_$(NOW)_$(REL).zip 	HEAD

