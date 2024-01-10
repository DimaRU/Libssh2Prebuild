# Libssh2Prebuild
## Libssh2 with OpenSSL crypto backend prebuilt library for Apple platforms. Apple Silicon supported.


### Supported platforms and architectures
| Platform          |  Architectures     |
|-------------------|--------------------|
| macOS             | x86_64 arm64       |
| iOS               | arm64              |
| iOS Simulator     | x86_64 arm64       |
| tvOS              | arm64              |
| tvOS Simulator    | x86_64 arm64       |
| mac Catalyst      | x86_64 arm64       |
| xrOS*             | arm64              |
| xrOS Simulator*   | arm64              |

* Xcode 15

### Usage

Add line to you package.swift dependencies:

```
.package(name: "CSSH", url: "https://github.com/DimaRU/Libssh2Prebuild.git", from: "1.9.0")

```

Right now used with the Shout library: [https://github.com/DimaRU/Shout](https://github.com/DimaRU/Shout)  
Note: Script must be used with xczip which results in stable archive checksum (it is not changed from build to build).

### Xcode 12 bug note!

Xcode 12 now has a bug that causes static library .a files to be copied into the app bundle. Add `Run Script` to your Xcode project with this commands:

```
# Remove static libs
ls -1 ${CODESIGNING_FOLDER_PATH}/Contents/Frameworks/*.a
rm -f ${CODESIGNING_FOLDER_PATH}/Contents/Frameworks/*.a

```

### Build your own repo from source

Required at least Xcode 12.2, xczip and [github cli](https://github.com/cli/cli). Intended to use with github.

1. Install xczip: `brew install DimaRU/formulae/xczip`
2. Install gh: `brew install gh`
3. Authorize gh: `gh auth`
4. Fork and clone this repo
5. Run `./script/build-xcframework.sh libssh_tag libssl_tag date_mark commit`  
For example: `./script/build-xcframework.sh 1.11.0 OpenSSL_1_1_1u "2023-05-30 15:58:00 +0000" commit` 


### Credits:
* Andrew Madsen for building OpenSSL for ARM/Apple silicon Macs [https://blog.andrewmadsen.com/2020/06/22/building-openssl-for.html](https://blog.andrewmadsen.com/2020/06/22/building-openssl-for.html)
* Tommaso Madonia for build script sample. [https://github.com/Frugghi/iSSH2](https://github.com/Frugghi/iSSH2)
