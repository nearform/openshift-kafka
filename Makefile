NAMESPACE ?= kafka
TW_TRACK ?= javascript

.PHONY: configure
configure:
	./bin/configure.sh

.PHONY: install
install:
	./bin/install.sh
