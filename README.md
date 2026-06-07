# base42 vcpkg registry

The base42 vcpkg registry is the central package source for libraries maintained by the base42 embedded team.

It provides versioned vcpkg ports for internal projects such as `sparq`, together with any supporting libraries that are shared across base42's embedded/C++ software. The registry allows downstream applications to consume these packages through the standard vcpkg workflow while keeping dependency versions consistent across projects.

All available packages can be found in the `ports/` directory.

## Quick start

Before using this registry you must have vcpkg installed on your machine. If you do not already have it available, clone the official repository in your desired folder and bootstrap it:

```cmd
git clone https://github.com/microsoft/vcpkg
.\vcpkg\bootstrap-vcpkg.bat
```

Once bootstrapped, vcpkg is ready to consume packages from both the official Microsoft registry and any additional registries configured by your project, such as this registry.

## Using packages from this registry in your project

Projects that consume base42 libraries need a `vcpkg-configuration.json` file in their root that references this registry.

The repository includes an example configuration file which can be copied directly into your project. Before using it, replace the placeholder baseline value with a commit hash from this registry's `main` branch, which can be found by visiting https://github.com/42dotmk/base42-vcpkg-registry and clicking the commits button like in the following picture:
<img width="630" height="278" alt="image" src="https://github.com/user-attachments/assets/0be84d5f-de96-49c2-9f70-03590da78409" />

then in the newly opened page, copy the latest `main` hash by clicking the button shown in the following picture:

<img width="947" height="443" alt="image" src="https://github.com/user-attachments/assets/456174b1-65c8-4b91-8d56-ae5a025edf0e" />

at the end, just paste the copied hash into the `vcpkg-configuration.json` template:

```diff
- "baseline": "main-commit-hash"
+ "baseline": "7d1a4f8b3c9e62da50e1f73b4c8d9ea21fdb7111"
```

The selected baseline determines which package versions are visible to vcpkg. In practice, most projects can simply use the latest commit from the main branch.

After configuring the registry, create a `vcpkg.json` manifest in your application repository:

```json
{
  "name": "your-app-name",
  "version": "1.0.0",
  "dependencies": [
    "sparq"
  ]
}
```

Whenever dependencies are restored, vcpkg will resolve packages using both the official registry and the base42 registry.

## Verifying the setup

A quick way to confirm that the registry is configured correctly is to search for one of the packages provided by base42:

```cmd
vcpkg search sparq
```

If the package appears in the results, the registry has been discovered successfully.

You can also search for packages from the official registry:

```cmd
vcpkg search fmt
```

This demonstrates that both registries are active at the same time.

## Building with CMake

The recommended workflow is to integrate vcpkg directly into the project's CMake configuration, either by manually specifying the cache entry/variable `CMAKE_TOOLCHAIN_FILE`:

```cmd
cmake -DCMAKE_TOOLCHAIN_FILE=[path-to-vcpkg-root-or-env-variable]/scripts/buildsystems/vcpkg.cmake -S . -B build
cmake --build build
```

or using `CMakePresets.json` for repeatable automatic generation:
```json
{
  "version": 6,
  "configurePresets": [
    {
      "name": "my-toolchain",
      "displayName": "Build with custom toolchain",
      "binaryDir": "${sourceDir}/build",
      "cacheVariables": {
        "CMAKE_TOOLCHAIN_FILE": "[path-to-vcpkg-root-or-env-variable]/scripts/buildsystems/vcpkg.cmake"
      }
    }
  ]
}
```

When the vcpkg toolchain is supplied, CMake automatically resolves and installs missing dependencies declared in the project's manifest before the build starts.

This keeps dependency management and compilation within a single workflow and removes the need for separate installation steps.

## Registry layout

The registry follows the standard vcpkg registry structure. Contributors should become familiar with the major directories before making changes.

```text
base42-vcpkg-registry/
├── ports/
├── versions/
├── scripts/
├── vcpkg-configuration.json
└── README.md
```

The `ports/` directory contains all package definitions. Each package has its own folder containing the files required to fetch, build and package the library.

The `versions/` directory stores package version history and baseline information. These files allow vcpkg to resolve package versions consistently across projects.

The `scripts/` directory contains helper utilities used during registry maintenance. These scripts simplify common contributor workflows such as formatting manifests, validating package changes and synchronizing version metadata.

In most cases contributors will work primarily inside the `ports/` directory and use the provided scripts when preparing updates.

## Maintaining existing ports

Updating a package typically involves synchronizing the port with changes made in the library repository.

Start by creating a dedicated branch that clearly describes the work being performed.

Examples:

```text
feature/update-sparq-2.1.0
feature/update-stormwing-0.8.0
```

Most package updates require changes to two files.

The `vcpkg.json` file contains package metadata including version information, supported platforms, dependencies and optional features. When updating to a new upstream release, update the package version and reset the `port-version` field to `0`. If the package itself is being corrected without a new upstream release, increment the existing `port-version` value instead.

The `portfile.cmake` file contains the package acquisition and build logic. This file often requires updates when a package changes source revisions, introduces new build options or modifies its installation process.

After making changes, validate the package locally before creating a pull request.

Before creating a commit, format and validate the affected port using the provided helper scripts.

On Windows:

```cmd
scripts\format-port.bat sparq
scripts\validate-port.bat sparq
```

On Unix:

```sh
scripts/format-port.sh sparq
scripts/validate-port.sh sparq
```

The validation step performs a lightweight verification of the package metadata and versioning workflow before registry metadata is updated.

Once the package behaves as expected, commit the changes(don't push yet!) and update the registry version metadata using the registry maintenance script.

On Windows:

```cmd
scripts\sync-port-version.bat sparq
```

On Unix:

```sh
scripts/sync-port-version.sh sparq
```

The script updates version tracking files and ensures the registry metadata remains synchronized with the modified port.

When everything looks correct, amend the generated version files into the same commit:

```sh
git add versions/[first-letter-of-affected-port]-/[port-name].json versions/baseline.json
git commit --amend --no-edit
```

and finally push the branch for review.

## Creating new ports

Adding a package begins by creating a new directory under `ports/`.

```text
ports/
└── my-library/
    ├── portfile.cmake
    └── vcpkg.json
```

A minimal package manifest may look similar to the following:

```json
{
  "name": "new-library",
  "version": "1.0.0",
  "description": "Description of the library",
  "dependencies": [
    {
      "name": "sparq"
    },
    {
      "name": "other-vcpkg-package",
      "host": true
    }
  ]
}
```

The manifest defines package metadata while the portfile describes how the library is downloaded, configured and installed.

Before publishing a new package, verify that it builds correctly and that all required dependencies are declared.

Before generating version metadata, format and validate the new port.

On Windows:

```cmd
scripts\format-port.bat new-library
scripts\validate-port.bat new-library
```

On Unix:

```sh
scripts/format-port.sh new-library
scripts/validate-port.sh new-library
```

Once validation succeeds, generate version metadata using the registry maintenance script.

On Windows:

```cmd
scripts\sync-port-version.bat new-library
```

On Unix:

```sh
scripts/sync-port-version.sh new-library
```

The script updates version tracking files and ensures the registry metadata remains synchronized with the modified port.

When everything looks correct, amend the generated version files into the same commit:

```sh
git add versions/[first-letter-of-affected-port]-/[port-name].json versions/baseline.json
git commit --amend --no-edit
```

and finally push the branch for review.

Don't forget to append the newly created port in the example `vcpkg-configuration.json`, to make it easier for your downstream users

## Registry maintenance scripts

The registry includes several helper scripts that wrap common vcpkg commands and provide a consistent workflow across contributors.

### Formatting a port

Formats a specific port manifest.

Windows:

```cmd
scripts\format-port.bat sparq
```

Unix:

```sh
scripts/format-port.sh sparq
```

### Validating a port

Runs a lightweight validation pass before version metadata is updated.

Windows:

```cmd
scripts\validate-port.bat sparq
```

Unix:

```sh
scripts/validate-port.sh sparq
```

### Syncing version metadata

Updates the port's version file and the registry baseline using `vcpkg x-add-version`.

Windows:

```cmd
scripts\sync-port-version.bat sparq
```

Unix:

```sh
scripts/sync-port-version.sh sparq
```

Additional arguments supported by `vcpkg x-add-version` may be passed directly to the script.

Example:

```cmd
scripts\sync-port-version.bat sparq --overwrite-version
```

## Working with local changes

There are situations where a project needs to consume registry changes before they are merged into the `main` branch. This can be achieved in several ways.

A project can reference a feature branch by specifying both a baseline commit and a branch reference inside `vcpkg-configuration.json`.

```diff
- {
-   "baseline": "main-commit-hash"
- }
+ {
+   "baseline": "7d1a4f8b3c9e62da50e1f73b4c8d9ea21fdb7111"
+   "reference": "feature/update-sparq-2.1.0"
+ }
```

This allows downstream applications to test registry changes without affecting other users.

Another useful approach is to use overlay ports. This allows a package under development to override the version provided by the registry.

```sh
vcpkg install sparq --overlay-ports=ports/sparq
```

Overlay ports are particularly useful when validating packaging changes before updating registry metadata.

## Pull request workflow

All changes to the registry should be submitted through pull requests.

Before opening a pull request, ensure that package formatting has been verified, local builds succeed and version metadata has been updated.

Pull requests should include a concise description of the change together with any relevant context that may help reviewers understand the motivation behind the update.

Examples of good commit messages include:

```text
[sparq] update to version 2.1.0
[stormwing] fix linux packaging issue
[sparq] add FreeRTOS feature support
```

Every pull request is validated through the registry's continuous integration workflow. Contributors should wait for all checks to complete successfully before requesting a merge.

Changes **must** be merged using squash commits. This keeps the registry history compact and makes it easier to track package evolution over time.

The goal of the review process is not only to validate that a package builds successfully but also to ensure that dependency definitions, platform support and version tracking remain consistent throughout the registry.
