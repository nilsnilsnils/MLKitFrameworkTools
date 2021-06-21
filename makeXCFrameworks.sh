#!/bin/zsh
# Manual:
#             1. Create new folder
#             2. Create Pod file inside the new folder with the following content
#                     platform :ios, '10.0'
#                     use_frameworks!
#
#                     plugin 'cocoapods-binary'
#
#                     pod 'GoogleMLKit/FaceDetection', '0.64.0', :binary => true
#                     pod 'GoogleMLKit/ImageLabeling', '0.64.0', :binary => true
#             3. Open terminal and change to the created folder and run pod install
#             4. Copy makeXCFrameworks.sh into Pods folder
#             5. Change to Pods folder in terminal
#             6. Call ./makeXCFrameworks.sh (current dir should be Pods)
#            
#             After that all XCFrameworks should be in a the Folder _Prebuild/GeneratedFrameworks/_XCFrameworks -> ML* , Google*, nanopb, etc.

makeXCFramework () 
{
    if [ $# -eq 0 ]; then
        echo "Error: Missing arguments for makeXCFramework, (1) frameworkdir (2) libname (3) output folder"
        exit 1
    fi

    BASEDIR=$1
    LIBNAME=$2
    
    # Enable for debugging
    # echo "Script location: ${BASEDIR}\n"
    # echo "lib is: $LIBNAME"
    # echo "$(pwd)"
    
    # Copy framework into the platform specific directories
    
    # remove old
    rm -rf iphoneos
    rm -rf iphonesimulator

    # create dirs       
    mkdir -p iphoneos
    mkdir -p iphonesimulator

    cp -R $LIBNAME.framework/ iphoneos/$LIBNAME.framework
    cp -R $LIBNAME.framework/ iphonesimulator/$LIBNAME.framework

    xcrun lipo -remove x86_64 ./iphoneos/$LIBNAME.framework/$LIBNAME -o ./iphoneos/$LIBNAME.framework/$LIBNAME
    xcrun lipo -remove arm64 ./iphonesimulator/$LIBNAME.framework/$LIBNAME -o ./iphonesimulator/$LIBNAME.framework/$LIBNAME
    xcodebuild  -create-xcframework -framework iphoneos/$LIBNAME.framework/ -framework iphonesimulator/$LIBNAME.framework/ -output "$3/$LIBNAME.xcframework"
}

# Enter  _Prebuild/GeneratedFrameworks
PreBuildFrameworkdFolder="_Prebuild/GeneratedFrameworks" 

if [[ ! -d $PreBuildFrameworkdFolder ]]; then
    echo "Missing _Prebuild folder"
    exit 1
fi

cd $PreBuildFrameworkdFolder
echo "Enter $PreBuildFrameworkdFolder \n"

# Create output folder for XCFrameworks
XCFrameworksOutputFolder="$(pwd)/_XCFrameworks"

# echo "$XCFrameworksOutputFolder"
rm -rf "$XCFrameworksOutputFolder"
mkdir $XCFrameworksOutputFolder


WorkingDir=$(pwd)


for FrameworkBaseFolder in */
do
    # cut of "/"
    FrameworkBaseFolder="${FrameworkBaseFolder%*/}"
    #echo ${FrameworkBaseFolder##*/}

    # Skip _XCFrameworks
    if [[ $FrameworkBaseFolder == "_XCFrameworks" ]] then

        continue
    fi

    # Only combined header - handled later
    if [[ $FrameworkBaseFolder == "GoogleMLKit" ]] then
        echo "\nSkip GoogleMLKit"
        continue
    fi

    FrameworkFolder=""
    FrameworkPath="$FrameworkBaseFolder"

    # All MLKit folder have a subfolder which contains the framework
    # E.g. MLKitCommon/Frameworks/MLKitCommon.framework
    #
    # All other framworks are in the root framwork folder
    # E.g. GoogleUtilities/GoogleUtilities.framework
    if [[ $FrameworkBaseFolder == MLKit* ]] then
        FrameworkPath="$FrameworkBaseFolder/Frameworks"
    fi

    # echo $(pwd)
    cd "./$FrameworkPath"
    FrameworkName=$(find . -name "*.framework" -maxdepth 1)
    FrameworkName=$(basename $FrameworkName)
    TMP=$(basename $FrameworkName)
    FrameworkName="${TMP%.*}"

    FrameworkPath="$WorkingDir/$FrameworkPath/$FrameworkName"
    echo "\nMake XCFramework of $FrameworkPath"

    makeXCFramework $FrameworkPath $FrameworkName $XCFrameworksOutputFolder

    cd $WorkingDir
done

echo "\n ==== XCFrameworks can be found in: $XCFrameworksOutputFolder "