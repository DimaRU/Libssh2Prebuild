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
                      checksum: "ede00ee2151b2f29b48caf38aab1534e72a83c6c148d9ee05782e79a9e313e21")
    ]
)
