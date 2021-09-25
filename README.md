# Libssh2Prebuild
## Libssh2 with OpenSSL crypto backend prebuilt library for Apple platforms. Apple Silicon supported.


### Supported platforms and architectures
| Platform          |  Architectures     |
|-------------------|--------------------|
| macOS             | x86_64 arm64       |
| iOS               | arm64 armv7 armv7s |
| iOS Simulator     | x86_64 arm64       |
| watchOS           | armv7k arm64_32    |
| watchOS Simulator | x86_64 arm64       |
| tvOS              | arm64              |
| tvOS Simulator    | x86_64 arm64       |
| mac Catalyst      | x86_64 arm64       |

### Usage

Add line to you package.swift dependencies:

```
.package(name: "CSSH", url: "https://github.com/DimaRU/Libssh2Prebuild.git", from: "1.9.0")

```

Right now used with the Shout library: [https://github.com/DimaRU/Shout](https://github.com/DimaRU/Shout)

### Xcode 12 bug note!

Xcode 12 now has a bug that causes static library .a files to be copied into the app bundle. Add `Run Script` to your Xcode project with this commands:

```
# Remove static libs
ls -1 ${CODESIGNING_FOLDER_PATH}/Contents/Frameworks/*.a
rm -f ${CODESIGNING_FOLDER_PATH}/Contents/Frameworks/*.a

```

### Build your own repo from source

Required Xcode 12.2, and [github cli](https://github.com/cli/cli). Intended to use with github.

1. Install gh: `brew install gh`
2. Authorize gh: `gh auth`
2. Fork and clone this repo
3. Run `./script/build-xcframework.sh commit`

### Credits:
* Andrew Madsen for building OpenSSL for ARM/Apple silicon Macs [https://blog.andrewmadsen.com/2020/06/22/building-openssl-for.html](https://blog.andrewmadsen.com/2020/06/22/building-openssl-for.html)
*  Tommaso Madonia for build script sample. [https://github.com/Frugghi/iSSH2](https://github.com/Frugghi/iSSH2)
