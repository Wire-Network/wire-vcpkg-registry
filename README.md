# Wire Network `vcpkg-repository`

This repository contains several `ports` (library configurations) 
with either specific modifications required by `WIRE` OR 
libraries that are not generally available.

## Ports

- `softfloat`
- `libsodium`
- `cli11`
- `boost`
- `boringssl-custom`
- `secp256k1-internal`
- `bn256`
- `bls12-381`

## Usage

In order to use this repository, it must be
explicitly configured in the root of the consuming
package/repo/program in a file named `vcpkg-configuration.json`,
an example is available here [github.com/Wire-Network/wire-sysio/blob/feature/vcpkg-initial-integration/vcpkg-configuration.json](https://github.com/Wire-Network/wire-sysio/blob/feature/vcpkg-initial-integration/vcpkg-configuration.json).

## Contributing

Here are a few tricks & aids for contributing.

### Before commit

#### UPDATE THE BASELINE (REQUIRED)

Before committing, **YOU MUST UPDATE THE PORT & VERSION INFO**.
Go to the root of `wire-vcpkg-repository` & run the following command.

```sh
vcpkg \
  --x-builtin-ports-root=./ports \
  --x-builtin-registry-versions-dir=./versions \
  x-add-version \
  --all \
  --verbose
```

#### IF YOU GET FORMATTING ERRORS

Fix the formatting of all `port` manifests.

> NOTE: This script is written for fish shell only

```sh
# NOTE: This script is written for fish shell only
for f in /data/shared/code/wire/wire-vcpkg-registry/ports/*/vcpkg.json
    echo "vcpkg: $f"
    vcpkg format-manifest $f
end
```

