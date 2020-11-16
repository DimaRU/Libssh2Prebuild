# Libssh2Prebuild
## Libssh2 prebuilt binaries for Apple platforms.


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
| Maccatalyst       | x86_64 arm64       |

### Usage

Mainly used in the Shout project: [https://github.com/DimaRU/Shout](https://github.com/DimaRU/Shout)

### Build your own repo from source

Required Xcode 12.2, [github cli](https://github.com/cli/cli)

1. Install gh: `brew install gh`
2. Authorize gh: ``
2. Clone repo, change remotes to your own
3. Run `./script/build-xcframework.sh commit`

### Credits:
Andrew Madsen for building OpenSSL for ARM/Apple silicon Macs
[https://blog.andrewmadsen.com/2020/06/22/building-openssl-for.html](https://blog.andrewmadsen.com/2020/06/22/building-openssl-for.html)
