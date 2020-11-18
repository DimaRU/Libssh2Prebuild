// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CSSH",
    products: [
        .library(name: "CSSH", targets: ["CSSH"])
    ],
    targets: [
        .binaryTarget(name: "CSSH",
                      url: "https://github.com/DimaRU/Libssh2Prebuild/releases/download/1.9.0+OpenSSL_1_1_1h/CSSH-1.9.0+OpenSSL_1_1_1h.xcframework.zip",
                      checksum: "6e169e26136a73038b627c899b0ea07efae9aa25359b559c8fae0c1689ad99cf")
    ]
)
