// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CSSH",
    products: [
        .library(name: "CSSH", targets: ["CSSH"])
    ],
    targets: [
        .binaryTarget(name: "CSSH",
                      url: "https://github.com/DimaRU/Libssh2Prebuild/releases/download/1.11.0+OpenSSL_1_1_1u+beta/CSSH-1.11.0+OpenSSL_1_1_1u+beta.xcframework.zip",
                      checksum: "7964bb946da1424e2b25497c2cab73185a32c105716c6c69cb622e1cacaa4000")
    ]
)
