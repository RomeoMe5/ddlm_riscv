# Makefile for Register File project

# Default target shows help
.DEFAULT_GOAL := help

# Help target
.PHONY: help
help:
	@echo "Available commands for Register File project:"
	@echo "  make prepare       - Prepare project for Quartus"
	@echo "  make build         - Synthesize project in Quartus (GUI mode)" 
	@echo "  make build_console - Synthesize project in Quartus (console mode)"
	@echo "  make clean         - Clean generated files"
	@echo "  make program       - Program the target board"

.PHONY: prepare
prepare:
ifeq ($(TARGET_OS),windows)
	@echo Preparing project for Quartus...
	@if not exist quartus ( mkdir quartus )
	@copy /Y *.v quartus\ > nul
	@if not exist quartus\synthesis\de10_lite ( mkdir quartus\synthesis\de10_lite )
	@copy /Y synthesis\de10_lite\*.qsf quartus\synthesis\de10_lite\ > nul
	@copy /Y synthesis\de10_lite\*.qpf quartus\synthesis\de10_lite\ > nul
else
	@echo Preparing project for Quartus...
	@mkdir -p quartus
	@cp *.v quartus/
	@cp -r synthesis quartus/
endif

.PHONY: build
build: prepare
ifeq ($(TARGET_OS),windows)
	@echo Starting Quartus in GUI mode...
	@$(QUARTUS_ROOT)\quartus\bin64\quartus.exe quartus\synthesis\de10_lite\de10_lite.qpf
else
	@echo Starting Quartus in GUI mode...
	@$(QUARTUS_ROOT)\quartus\bin64\quartus.exe quartus\synthesis\de10_lite\de10_lite.qpf
endif

.PHONY: build_console
build_console: prepare
ifeq ($(TARGET_OS),windows)
	@echo Building project in console mode...
	@$(QUARTUS_ROOT)\quartus\bin64\quartus_sh.exe --flow compile quartus\synthesis\de10_lite\de10_lite.qpf
else
	@echo Building project in console mode...
	@$(QUARTUS_ROOT)\quartus\bin64\quartus_sh.exe --flow compile quartus\synthesis\de10_lite\de10_lite.qpf
endif

.PHONY: clean
clean:
ifeq ($(TARGET_OS),windows)
	@echo Cleaning generated files...
	@if exist quartus ( rmdir /s /q quartus )
	@if exist simulation\work ( rmdir /s /q simulation\work )
	@del /f /q *.rpt *.summary *.smsg *.chg smart.log *.htm *.eqn *.pin *.sof *.pof 2>nul
else
	@echo Cleaning generated files...
	@rm -rf quartus
	@rm -rf simulation/work
	@rm -f *.rpt *.summary *.smsg *.chg smart.log *.htm *.eqn *.pin *.sof *.pof
endif

.PHONY: program
program:
ifeq ($(TARGET_OS),windows)
	@echo Programming the board...
	@quartus_pgm -c USB-Blaster -m JTAG -o "p;quartus\output_files\de10_lite.sof"
else
	@echo Programming the board...
	@quartus_pgm -c USB-Blaster -m JTAG -o "p;quartus/output_files/de10_lite.sof"
endif