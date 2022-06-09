// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CSSH",
    products: [
        .library(name: "CSSH", targets: ["CSSH"])
    ],
    targets: [
        .binaryTarget(name: "CSSH",
                      url: "https://github.com/DimaRU/Libssh2Prebuild/releases/download/1.10.0+OpenSSL_1_1_1o/CSSH-1.10.0+OpenSSL_1_1_1o.xcframework.zip",
                      checksum: "25404c6ba48f24cb7d1fae7f8d019f805dd00ce23d6c3da146eeb48e3981dbcb")
    ]
)
