# ==============================================
# Targets Gowin FPGAs using the OSS CAD Suite.
# https://github.com/YosysHQ/oss-cad-suite-build
# 
# Configured for the Sipeed Tang Nano 9K.
# 
# How to target other Gowin boards:
# https://github.com/YosysHQ/apicula/wiki
# ==============================================

SHELL := /bin/sh

.SUFFIXES:
.SUFFIXES: .v .cst .json .fs

# Binaries
LOAD := openFPGAloader
PACK := gowin_pack
NEXTPNR := nextpnr-himbaechel
YOSYS := yosys

# Parameters
TOP_MODULE := top
DEVICE := GW1NR-LV9QN88PC6/I5
FAMILY := GW1N-9C
BOARD := tangnano9k
LEDS_NR := 6

# Inputs
IN_DIR := $(CURDIR)/src

IN_VERILOG_SOURCES := $(wildcard $(IN_DIR)/*.v)
IN_CST := $(IN_DIR)/$(BOARD).cst

# Outputs
OUT_DIR := $(CURDIR)/out

OUT_SYNTH := $(OUT_DIR)/synth.json
OUT_PNR := $(OUT_DIR)/pnr.json
OUT_PACK := $(OUT_DIR)/pack.fs


all: build

load: $(OUT_PACK) | $(OUT_DIR)
	$(LOAD) -b $(BOARD) $<

build: $(OUT_PACK) | $(OUT_DIR)


$(OUT_PACK): $(OUT_PNR) | $(OUT_DIR)
	$(PACK) -d $(FAMILY) -o $@ $<

$(OUT_PNR): $(OUT_SYNTH) $(IN_CST) | $(OUT_DIR)
	$(NEXTPNR) \
		--json $< \
		--write $@ \
		--device $(DEVICE) \
		--vopt cst=$(IN_CST) \
		--vopt family=$(FAMILY)

$(OUT_SYNTH): $(IN_VERILOG_SOURCES) | $(OUT_DIR)
	$(YOSYS) -D LEDS_NR=$(LEDS_NR) -p "read_verilog -sv $^; synth_gowin -json $@ -top $(TOP_MODULE)"

$(OUT_DIR):
	mkdir -p $(OUT_DIR)


clean:
	rm -rf $(OUT_DIR)


help:
	@echo "" \
		"USAGE:\n" \
		"    make [target]\n" \
		"\n" \
		"TARGETS:\n" \
		"    all       Run 'build' (default)\n" \
		"    load      Build and load pack\n" \
		"    build     Build loadable pack\n" \
		"    clean     Remove generated files\n" \
		"    help      Display this message\n"

info:
	@echo "" \
	"DETECTED SOURCES:\n" \
	"    $(notdir $(IN_VERILOG_SOURCES))\n" \
	"\n" \
	"DETECTED CONSTRAINTS:\n" \
	"    $(notdir $(IN_CST))\n" \
	"\n" \
	"BUILD DIRECTORY:\n" \
	"    $(OUT_DIR)"


.PHONY: all load build clean help info
