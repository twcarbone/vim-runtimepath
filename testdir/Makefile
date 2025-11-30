TESTS = test_components test_modifiers test_find
TMP_DIR = /tmp/vimtest
TESTS_RES = test_components.res test_modifiers.res test_find.res
CLEANUP_FILES = test.log messages

.PHONY: all clean tests report

all: clean tests report

clean:
	@rm -rf $(TMP_DIR)
	@rm -f *.res $(CLEANUP_FILES)

tests: $(TESTS_RES)

# Some tests look at the absolute path of the current file. Copy the test_X.vim file to a
# known directory in /tmp to do this. Then copy the X.res file back to this directory.
%.res:
	@mkdir -p $(TMP_DIR)
	@cp $*.vim $(TMP_DIR)
	@vim --clean -S runtest.vim $(TMP_DIR)/$*.vim
	@if test -f $(TMP_DIR)/$*.res; then mv $(TMP_DIR)/$*.res .; fi

report:
	@echo 'Test results:'
	@if test -f test.log; \
		then cat test.log; echo -e "\nTEST FAILURE\n"; exit 1; \
		else echo -e "\nALL DONE\n"; \
		fi

$(TESTS):
	@rm -f $@.res $(CLEANUP_FILES)
	$(MAKE) --no-print-directory -f Makefile $@.res
	@cat messages
	@if test -f test.log; then exit 1; fi
