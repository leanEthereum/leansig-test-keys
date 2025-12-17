# leansig-test-keys

**Do not use these keys in production.** Pre-generated [leanSig](https://github.com/leanEthereum/leanSig/) keys for quicker test preparation.

## Usage

This repository provides a Makefile with commands to generate leanSig keys for different schemes, suitable for usage in [leanSpec](https://github.com/leanEthereum/leanSpec/) testing:

```bash
make          # Alias for `make release`
make help     # Display available commands
make install  # Clone leanSpec repository
make test     # Generate keys for test scheme
make prod     # Generate keys for prod scheme
make package  # Create tar.gz archives from existing test_scheme/ and prod_scheme/ folders"
make tag      # Display leanSpec HEAD commit as leanSpec-<commit>, useful for tagging a release"
make release  # Run the entire workflow, from installing dependencies, key generation, to creating archives
make clean    # Remove cloned leanSpec repository and release folder
```

## Quick start

Run the entire workflow, i.e. install dependencies, key generation, creating .tar.gz archives:
```bash
make
```

## Examples

Generate test scheme keys:
```bash
# The generated keys will be in `test_schema/` directory.
make test
```

Generate production scheme keys:
```bash
# The generated keys will be in `prod_schema/` directory.
make prod
```

## Preparing a release

Package the generated keys into release archives:
```bash
make package
```

Use the output files (`.tar.gz` files) in [`release/`](./release/) folder to publish a new release.
