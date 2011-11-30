# XXX this is kind of awful, but hey, it keeps the version info in the right place.
VERSION = $(shell node -e 'console.log(require("./index.js").version)')

SRC_DIR = ./src
TNETS_SRC = $(SRC_DIR)/tnetstrings.coffee

LIB_DIR ?= ./lib
TNETS_LIB = $(LIB_DIR)/tnetstrings.js

CLEAN += $(TNETS_LIB)

UGLIFY_OPTS += --lift-vars --unsafe
TNETS_MIN = $(LIB_DIR)/tnetstrings.min.js

CLEAN += $(TNETS_MIN)

PACKAGE = tnetstrings-$(VERSION).tgz
CLEAN += $(PACKAGE)

.PHONY: test
test: $(TNETS_LIB)
	expresso test/*.test.coffee

$(TNETS_LIB): $(TNETS_SRC)
	coffee --bare -o $(LIB_DIR) $(TNETS_SRC)

$(TNETS_MIN): $(TNETS_LIB)
	uglifyjs $(UGLIFY_OPTS) -o $(TNETS_MIN) $(TNETS_LIB)

$(PACKAGE): test
	npm pack .

.PHONY: package
package: $(PACKAGE)

.PHONY: minify
minify: $(TNETS_MIN)

.PHONY: publish
publish: $(PACKAGE)
	npm publish $(PACKAGE)

.PHONY: clean
clean:
	rm $(CLEAN)
