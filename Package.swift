// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "CSSH",
    products: [
        .library(name: "CSSH", targets: ["CSSH"])
    ],
    targets: [
        .binaryTarget(name: "CSSH",
                      url: "https://github.com/DimaRU/Libssh2Prebuild/releases/download/1.11.0-OpenSSL-1-1-1w/CSSH-1.11.0-OpenSSL-1-1-1w.xcframework.zip",
                      checksum: "f2a14236019b617019f522001c89ad5db2125e8f350cbcde5ed6e96f50842157")
    ]
)
