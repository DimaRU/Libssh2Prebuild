// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CSSH",
    products: [
        .library(name: "CSSH", targets: ["CSSH"])
    ],
    targets: [
        .binaryTarget(name: "CSSH",
                      url: "https://github.com/DimaRU/Libssh2Prebuild/releases/download/1.11.0+OpenSSL_1_1_1u/CSSH-1.11.0+OpenSSL_1_1_1u.xcframework.zip",
                      checksum: "c5d8d6843149bcc1d6fd719b25f504612204fb4e91df4d842307b7fb88a953a8")
    ]
)
