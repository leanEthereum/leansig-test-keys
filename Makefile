LEAN_SPEC_REPO_URL := https://github.com/leanEthereum/leanSpec
LEAN_SPEC_REPO_DIR := leanSpec

.PHONY: install test prod package tag release clean help

help:
	@echo "Usage:"
	@echo "  make install - Clone leanSpec repository"
	@echo "  make test    - Generate keys for test scheme"
	@echo "  make prod    - Generate keys for prod scheme"
	@echo "  make package - Create tar.gz archives from existing test_scheme/ and prod_scheme/ folders"
	@echo "  make tag     - Display leanSpec HEAD commit as leanSpec-<commit>, useful for tagging a release"
	@echo "  make release - Generate keys (test & prod) and create tar.gz archives"
	@echo "  make clean   - Remove cloned leanSpec repository and release folder"

install:
	@if [ -d "$(LEAN_SPEC_REPO_DIR)" ]; then \
		echo "==> $(LEAN_SPEC_REPO_DIR) already exists, skipping..."; \
	else \
		echo "==> Cloning repository..."; \
		git clone $(LEAN_SPEC_REPO_URL); \
	fi

test: install
	@echo "==> Generating keys for test scheme"
	cd $(LEAN_SPEC_REPO_DIR) && uv run python -m consensus_testing.keys --scheme test
	@echo "==> Moving generated files to test_scheme/"
	mkdir -p test_scheme
	cp -r $(LEAN_SPEC_REPO_DIR)/test_scheme/* test_scheme/
	@echo "==> Done! Keys generated in test_scheme/ folder"

prod: install
	@echo "==> Generating keys for prod scheme"
	cd $(LEAN_SPEC_REPO_DIR) && uv run python -m consensus_testing.keys --scheme prod
	@echo "==> Moving generated files to prod_scheme/"
	mkdir -p prod_scheme
	cp -r $(LEAN_SPEC_REPO_DIR)/prod_scheme/* prod_scheme/
	@echo "==> Done! Keys generated in prod_scheme/ folder"

package:
	# Create release folder
	@echo "==> Creating release folder..."
	mkdir -p release

	# Compress the key files (excluding hidden files like .DS_Store and ._* files)
	@echo "==> Compressing test scheme keys..."
	tar -czf release/test_scheme.tar.gz --exclude='*/.*' test_scheme/*.json
	@echo "==> Compressing prod scheme keys..."
	tar -czf release/prod_scheme.tar.gz --exclude='*/.*' prod_scheme/*.json

	# Success message
	@echo "==> Done! Archives created in release/ folder:"
	@echo "    - test_scheme.tar.gz"
	@echo "    - prod_scheme.tar.gz"

tag:
	@if [ ! -d "$(LEAN_SPEC_REPO_DIR)" ]; then \
		echo "Error: $(LEAN_SPEC_REPO_DIR) directory not found. Run 'make install' first."; \
		exit 1; \
	fi
	@cd $(LEAN_SPEC_REPO_DIR) && echo "leanSpec-$$(git rev-parse --short HEAD)"

release: test prod package tag

clean:
	@echo "==> Removing $(LEAN_SPEC_REPO_DIR)..."
	rm -rf $(LEAN_SPEC_REPO_DIR)
	@echo "==> Removing release folder..."
	rm -rf release
