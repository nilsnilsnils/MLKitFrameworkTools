# GoogleMLKit as Package

The package was created manually because its not available as Package.
Issue is already open @ Google
`https://issuetracker.google.com/issues/174418229`


MLKit Repo: `https://github.com/googlesamples/mlkit`


## Create Package manually

1. `makeXCFrameworks.sh` creates all XCFrameworks
    Further details in script or @ `https://gist.github.com/MapaX/5dc58ccb16ad1f772907154ae4991dca`
    
2. Create / adjust the `Package.swift` manually. Don't add any  `MLKit*.xcframework` to package file. See -> `8.`

3. Add all XCFrameworks (look for same dependencies in Firebase). Some can be used via other Packages 
    and some must be used directly which was created via  `makeXCFrameworks.sh` 

4. Add Dummy.swift in Package (is needed)

5. The MLKit Frameworks doesn't have a Info.plist which will result in an error when the app should be installed on the device.
    E.g. `MLKitCommon.framework`
    
    Therefore:
    1. Add `MLKitFramework_Template_arm64_Info.plist` 
        to `../MLKitCommon.xcframework/ios-arm64/MLKitCommon.framework/` and rename it to Info.plist
        
        Edit Info.plist and edit the fields with content prefix  `#e.g.`
        
    2. Add `MLKitFramework_Template_sim_x86_64_Info.plist` 
        to `../MLKitCommon.xcframework/ios-x86_64-simulator/MLKitCommon.framework/` and rename it to Info.plist
        
        Edit Info.plist and edit the fields with content prefix  `#e.g.`
        
        Do this for all `MLKit*.xcframework`

6. Copy  resources of the MLKit Frameworks to your project which uses this Package
    1. Open `../Pods/Pods.xcodeproj`
    
    The next steps must be done for every bundle that is visible as a target e.g. `MLKitObjectDetectionCommon-MLKitObjectDetectionCommonResources`
    
    2. Create a new scheme for the target. Use a REALSE Build config otherwise you get errors when upload the app to apple like:
        `[Transporter Error Output]: ERROR ITMS-90542: Invalid CFBundleSupportedPlatforms value. The key 'CFBundleSupportedPlatforms' in the Info.plist file in bundle 'Payload/cewefotowelt.app/GoogleMVFaceDetectorResources.bundle' contains an invalid value '[iPhoneSimulator]'. Consider removing the CFBundleSupportedPlatforms key from the Info.plist. If this bundle is part of a third-party framework, consider contacting the developer of the framework for an update to address this issue.`
    3. Run scheme
    4. Add the created bundle from the build folder `../Pods/build/<target>` to your project
    
7. Use Package in Project

8. All  `MLKit*.xcframework` must be added to the Build Phases -> Link Binary with libraries of your project and should not be content of the Package.swift. 
    Otherwise there there will be error on upload to apple:
    `ERROR ITMS-90210: Missing load commands. The executable at 'cewefotowelt.app/Frameworks/MLKitVisionKit.framework' does not have the necessary load commands. Try rebuilding the app with the latest Xcode version. If you are using third party development tools, contact the provider.`
    
    The  `MLKit*.xcframework` can be placed in the folder for better overview what is used.


## Further Infos:
- See documentation in `makeXCFrameworks.sh`.
- `https://gist.github.com/MapaX/5dc58ccb16ad1f772907154ae4991dca`
- `https://issuetracker.google.com/issues/174418229`


### Firebase Packages:
- `https://github.com/firebase/firebase-ios-sdk`
- `https://github.com/firebase/nanopb/blob/master/Package.swift`

### Google Packages:
- `https://github.com/google/GoogleUtilities/blob/main/Package.swift`
- `https://github.com/google/GoogleDataTransport/blob/main/Package.swift`
- `https://github.com/google/gtm-session-fetcher/blob/main/Package.swift`
- `https://github.com/google/GoogleUtilities/blob/main/Package.swift`
- `https://github.com/google/GoogleDataTransport/blob/main/Package.swift`
- `https://github.com/google/promises.git`
