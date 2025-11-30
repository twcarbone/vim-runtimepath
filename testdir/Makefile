SHELL = /usr/bin/bash
TESTS = test_in_txt
TESTS_RES = test_in_txt.res
CLEANUP_FILES = errors messages

.PHONY: all clean tests report

all: clean tests report

clean:
	@rm -f *.res $(CLEANUP_FILES)

tests: $(TESTS_RES)

%.res:
	@vim -S runtest.vim $*.vim

report:
	@echo 'Test results:'
	@if test -f errors; \
		then cat errors; echo -e "\nTEST FAILURE\n"; exit 1; \
		else echo -e "\nALL DONE\n"; \
		fi

$(TESTS):
	@rm -f $@.res $(CLEANUP_FILES)
	$(MAKE) --no-print-directory -f Makefile $@.res
	@cat messages
