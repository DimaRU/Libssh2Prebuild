// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CSSH",
    products: [
        .library(name: "CSSH", targets: ["CSSH"])
    ],
    targets: [
        .binaryTarget(name: "CSSH",
                      url: "https://github.com/Co2333/Libssh2Prebuild/releases/download/1.10.0+OpenSSL_1_1_1l/CSSH-1.10.0+OpenSSL_1_1_1l.xcframework.zip",
                      checksum: "85177cf5449081553789e9961ddffe9961e970d82980bd84a57676a17fa59a3a")
    ]
)
