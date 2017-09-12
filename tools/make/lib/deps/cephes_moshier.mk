
# VARIABLES #

# Define the base download URL:
DEPS_CEPHES_URL ?= http://www.moshier.net/

# Determine the basename for the download:
deps_cephes_basename := moshier_cephes

# Define the checksum(s) to verify downloaded libraries:
DEPS_CEPHES_CHECKSUM ?= $(foreach file,$(filter-out 128bit,$(DEPS_CEPHES_LIBS)),$(shell cat $(DEPS_CHECKSUMS_DIR)/$(subst .,_,$(deps_cephes_basename)_$(file).zip)/sha256)) $(foreach file,$(filter 128bit,$(DEPS_CEPHES_LIBS)),$(shell cat $(DEPS_CHECKSUMS_DIR)/$(subst .,_,$(deps_cephes_basename)_$(file).tgz)/sha256))

# Define the output directory when downloading:
DEPS_CEPHES_DOWNLOAD_OUT ?= $(DEPS_TMP_DIR)/$(deps_cephes_basename)

# Define the output path(s) when downloading:
deps_cephes_download_out := $(addsuffix .zip,$(addprefix $(DEPS_CEPHES_DOWNLOAD_OUT)/,$(filter-out 128bit,$(DEPS_CEPHES_LIBS)))) $(addsuffix .tgz,$(addprefix $(DEPS_CEPHES_DOWNLOAD_OUT)/,$(filter 128bit,$(DEPS_CEPHES_LIBS))))

# Generate an interleaved list of output download paths and checksums:
deps_cephes_checksum := $(join $(deps_cephes_download_out),$(addprefix |,$(DEPS_CEPHES_CHECKSUM)))
deps_cephes_checksum := $(foreach pair,$(deps_cephes_checksum),$(subst |, ,$(pair)))

# Define the output path(s) when building:
deps_cephes_build_out := $(addprefix $(DEPS_CEPHES_BUILD_OUT)/cephes/,$(DEPS_CEPHES_LIBS))

# Define the path to the directory containing tests:
DEPS_CEPHES_TEST_DIR ?= $(DEPS_DIR)/test/moshier_cephes

# Define the output directory path for compiled tests:
DEPS_CEPHES_TEST_OUT ?= $(DEPS_CEPHES_TEST_DIR)/build

# Define the path to a test file for checking an installation:
DEPS_CEPHES_TEST_INSTALL ?= $(DEPS_CEPHES_TEST_DIR)/test_install.c

# Define the output path for a test file:
DEPS_CEPHES_TEST_INSTALL_OUT ?= $(DEPS_CEPHES_TEST_OUT)/test_install


# TARGETS #

# Create a download directory.
#
# This target creates a download directory for Cephes libraries.

$(DEPS_CEPHES_DOWNLOAD_OUT):
	$(QUIET) echo 'Creating download directory...' >&2
	$(QUIET) $(MKDIR_RECURSIVE) $(DEPS_CEPHES_DOWNLOAD_OUT)


# Download library.
#
# This target downloads the Cephes library for 128-bit reals.

$(DEPS_CEPHES_DOWNLOAD_OUT)/128bit.tgz: | $(DEPS_TMP_DIR) $(DEPS_CEPHES_DOWNLOAD_OUT)
	$(QUIET) echo 'Downloading library...' >&2
	$(QUIET) $(DEPS_DOWNLOAD_BIN) $(DEPS_CEPHES_URL)`basename $@` $@


# Download library.
#
# This target downloads the Cephes library for double-precision arithmetic.

$(DEPS_CEPHES_DOWNLOAD_OUT)/double.zip: | $(DEPS_TMP_DIR) $(DEPS_CEPHES_DOWNLOAD_OUT)
	$(QUIET) echo 'Downloading library...' >&2
	$(QUIET) $(DEPS_DOWNLOAD_BIN) $(DEPS_CEPHES_URL)`basename $@` $@


# Download library.
#
# This target downloads the Cephes library for 80-bit long double-precision arithmetic.

$(DEPS_CEPHES_DOWNLOAD_OUT)/ldouble.zip: | $(DEPS_TMP_DIR) $(DEPS_CEPHES_DOWNLOAD_OUT)
	$(QUIET) echo 'Downloading library...' >&2
	$(QUIET) $(DEPS_DOWNLOAD_BIN) $(DEPS_CEPHES_URL)`basename $@` $@


# Download library.
#
# This target downloads the Cephes library for extended-precision software floating-point arithmetic.

$(DEPS_CEPHES_DOWNLOAD_OUT)/qlib.zip: | $(DEPS_TMP_DIR) $(DEPS_CEPHES_DOWNLOAD_OUT)
	$(QUIET) echo 'Downloading library...' >&2
	$(QUIET) $(DEPS_DOWNLOAD_BIN) $(DEPS_CEPHES_URL)`basename $@` $@


# Download library.
#
# This target downloads the Cephes library for single-precision (float) arithmetic.

$(DEPS_CEPHES_DOWNLOAD_OUT)/single.zip: | $(DEPS_TMP_DIR) $(DEPS_CEPHES_DOWNLOAD_OUT)
	$(QUIET) echo 'Downloading library...' >&2
	$(QUIET) $(DEPS_DOWNLOAD_BIN) $(DEPS_CEPHES_URL)`basename $@` $@


# Extract library.
#
# This target extracts a gzipped tar archive of the Cephes library for 128-bit reals.

$(DEPS_CEPHES_BUILD_OUT)/cephes/128bit: $(DEPS_CEPHES_DOWNLOAD_OUT)/128bit.tgz
	$(QUIET) echo 'Extracting library...' >&2
	$(QUIET) $(MKDIR_RECURSIVE) $@
	$(QUIET) $(TAR) -zxf $< -C $@


# Extract library.
#
# This target extracts a ZIP archive of the Cephes library for double-precision arithmetic.

$(DEPS_CEPHES_BUILD_OUT)/cephes/double: $(DEPS_CEPHES_DOWNLOAD_OUT)/double.zip
	$(QUIET) echo 'Extracting library...' >&2
	$(QUIET) $(MKDIR_RECURSIVE) $@
	$(QUIET) $(UNZIP) -q $< -d $@


# Extract library.
#
# This target extracts a ZIP archive of the Cephes library for 80-bit long double-precision arithmetic.

$(DEPS_CEPHES_BUILD_OUT)/cephes/ldouble: $(DEPS_CEPHES_DOWNLOAD_OUT)/ldouble.zip
	$(QUIET) echo 'Extracting library...' >&2
	$(QUIET) $(MKDIR_RECURSIVE) $@
	$(QUIET) $(UNZIP) -q $< -d $@


# Extract library.
#
# This target extracts a ZIP archive of the Cephes library for extended-precision software floating-point arithmetic.

$(DEPS_CEPHES_BUILD_OUT)/cephes/qlib: $(DEPS_CEPHES_DOWNLOAD_OUT)/qlib.zip
	$(QUIET) echo 'Extracting library...' >&2
	$(QUIET) $(MKDIR_RECURSIVE) $@
	$(QUIET) $(UNZIP) -q $< -d $@


# Extract library.
#
# This target extracts a ZIP archive of the Cephes library for single-precision (float) arithmetic.

$(DEPS_CEPHES_BUILD_OUT)/cephes/single: $(DEPS_CEPHES_DOWNLOAD_OUT)/single.zip
	$(QUIET) echo 'Extracting library...' >&2
	$(QUIET) $(MKDIR_RECURSIVE) $@
	$(QUIET) $(UNZIP) -q $< -d $@


# Create directory for tests.
#
# This target creates a directory for storing compiled tests.

$(DEPS_CEPHES_TEST_OUT):
	$(QUIET) $(MKDIR_RECURSIVE) $(DEPS_CEPHES_TEST_OUT)


# Compile install test.
#
# This target compiles a test file for testing an installation.

$(DEPS_CEPHES_TEST_INSTALL_OUT): $(deps_cephes_build_out) $(DEPS_CEPHES_TEST_OUT)
	$(QUIET) $(CC) -I $(DEPS_CEPHES_BUILD_OUT) \
		$(DEPS_CEPHES_TEST_INSTALL) \
		$(DEPS_CEPHES_BUILD_OUT)/cephes/double/sindg.c \
		$(DEPS_CEPHES_BUILD_OUT)/cephes/double/mtherr.c \
		$(DEPS_CEPHES_BUILD_OUT)/cephes/double/polevl.c \
		-o $(DEPS_CEPHES_TEST_INSTALL_OUT)


# Download Cephes.
#
# This target downloads a Cephes distribution.

deps-download-cephes: $(deps_cephes_download_out)

.PHONY: deps-download-cephes


# Verify download.
#
# This targets verifies a download.

deps-verify-cephes: deps-download-cephes
	$(QUIET) $(DEPS_CHECKSUM_BIN) $(deps_cephes_checksum) >&2

.PHONY: deps-verify-cephes


# Extract Cephes.
#
# This target extracts downloaded Cephes libraries.

deps-extract-cephes: $(deps_cephes_build_out)

.PHONY: deps-extract-cephes


# Test install.
#
# This target tests an installation.

deps-test-cephes: $(DEPS_CEPHES_TEST_INSTALL_OUT)
	$(QUIET) echo 'Running tests...' >&2
	$(QUIET) $(DEPS_CEPHES_TEST_INSTALL_OUT)
	$(QUIET) echo '' >&2
	$(QUIET) echo 'Success.' >&2

.PHONY: deps-test-cephes