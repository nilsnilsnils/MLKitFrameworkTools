// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "MLKitVisionPackage",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "MLKitVisionPackage",
            targets: ["MLKitVisionTarget"]
        ),
    ],
    dependencies: [
        .package(
            name: "GoogleDataTransport",
            url: "https://github.com/google/GoogleDataTransport.git",
            "8.4.0"..<"9.0.0"
        ),
        .package(
            name: "GoogleUtilities",
            url: "https://github.com/google/GoogleUtilities.git",
            "7.4.0"..<"8.0.0"
        ),
        .package(
            name: "GTMSessionFetcher",
            url: "https://github.com/google/gtm-session-fetcher.git",
            "1.5.0"..<"2.0.0"
        ),
        .package(
            name: "nanopb",
            url: "https://github.com/firebase/nanopb.git",
            "2.30908.0"..<"2.30909.0"
        ),
        .package(
            name: "Promises",
            url: "https://github.com/google/promises.git",
            "1.2.0" ..< "1.3.0"
        ),
    ],
    targets: [
        .target(
            name: "MLKitVisionTarget",
            dependencies: [
                .product(name: "FBLPromises", package: "Promises"),
                .product(name: "GoogleDataTransport", package: "GoogleDataTransport"),
                .target(name: "GoogleToolboxForMac"),
                .product(name: "GULAppDelegateSwizzler", package: "GoogleUtilities"),
                .product(name: "GULEnvironment", package: "GoogleUtilities"),
                .product(name: "GULLogger", package: "GoogleUtilities"),
                .product(name: "GULMethodSwizzler", package: "GoogleUtilities"),
                .product(name: "GULNetwork", package: "GoogleUtilities"),
                .product(name: "GULNSData", package: "GoogleUtilities"),
                .product(name: "GULReachability", package: "GoogleUtilities"),
                .product(name: "GULUserDefaults", package: "GoogleUtilities"),
                .target(name: "GoogleUtilitiesComponents"),
                .product(name: "GTMSessionFetcherFull", package: "GTMSessionFetcher"),
                // All `MLKit*` must be added to the Build Phases -> Link Binary with libraries
                // of your project and should not be content of the Package.swift.
//                .target(name: "MLKitCommon"),
//                .target(name: "MLKitFaceDetection"),
//                .target(name: "MLKitImageLabeling"),
//                .target(name: "MLKitImageLabelingCommon"),
//                .target(name: "MLKitObjectDetectionCommon"),
//                .target(name: "MLKitVision"),
//                .target(name: "MLKitVisionKit"),
                .product(name: "nanopb", package: "nanopb"),
                .target(name: "Protobuf"),
            ],
            path: "Sources/MLKitVisionTarget"
        ),

        .binaryTarget(name: "FBLPromisesFramework", path: "FBLPromises.xcframework"),
        .binaryTarget(name: "GoogleToolboxForMac", path: "GoogleToolboxForMac.xcframework"),
        .binaryTarget(name: "GoogleUtilitiesComponents", path: "GoogleUtilitiesComponents.xcframework"),
        // All `MLKit*` must be added to the Build Phases -> Link Binary with libraries
        // of your project and should not be content of the Package.swift.
//        .binaryTarget(name: "MLKitCommon", path: "MLKitCommon.xcframework"),
//        .binaryTarget(name: "MLKitFaceDetection", path: "MLKitFaceDetection.xcframework"),
//        .binaryTarget(name: "MLKitImageLabeling", path: "MLKitImageLabeling.xcframework"),
//        .binaryTarget(name: "MLKitImageLabelingCommon", path: "MLKitImageLabelingCommon.xcframework"),
//        .binaryTarget(name: "MLKitObjectDetectionCommon", path: "MLKitObjectDetectionCommon.xcframework"),
//        .binaryTarget(name: "MLKitVision", path: "MLKitVision.xcframework"),
//        .binaryTarget(name: "MLKitVisionKit", path: "MLKitVisionKit.xcframework"),
        .binaryTarget(name: "Protobuf", path: "Protobuf.xcframework"),
    ]
)
