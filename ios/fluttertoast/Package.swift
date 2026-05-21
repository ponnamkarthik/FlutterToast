// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "fluttertoast",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "fluttertoast", targets: ["fluttertoast"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "fluttertoast",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ],
            publicHeadersPath: ""
        )
    ]
)
