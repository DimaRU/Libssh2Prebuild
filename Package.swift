// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CSSH",
    products: [
        .library(name: "CSSH", targets: ["CSSH"])
    ],
    targets: [
        .binaryTarget(name: "CSSH",
                      url: "https://github.com/DimaRU/Libssh2Prebuild/releases/download/1.10.0+OpenSSL_1_1_1l/CSSH-1.10.0+OpenSSL_1_1_1l.xcframework.zip",
                      checksum: "a4aff717265efc34f494618a489fdcaec7f50cf770343449e72113cf794c0ca5")
    ]
)
