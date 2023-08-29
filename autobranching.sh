#!/bin/bash

# Variables obtained by groovy
majorVersion="1"
minorVersion="4"
patchVersion="0"
versionSuffix="DEV"
BRANCH="master"
# Variables obtained by groovy

desiredVersion="${majorVersion}.${minorVersion}.${patchVersion}"
desiredLine="${majorVersion}.${minorVersion}"


desiredLineExists=false
#TODO "origin/release/${desiredLine}"
if git rev-parse --verify "release/${desiredLine}"
then
    desiredLineExists=true
    echo "Release branch for version line ${desiredLine} exists"
else
    echo "Release branch for version line ${desiredLine} is missing"
fi

isCurrentBranchDesired=false
if [ "${BRANCH}" == "release/${desiredLine}" ]
then
    isCurrentBranchDesired=true
fi

if [ $desiredLineExists == true ] && [ $isCurrentBranchDesired == false ]
then
    echo "Unsupported state. Either release new line or start from release branch."
    exit 1
fi

if [ $desiredLineExists == false ]
then

    git config user.name "Jenkins"
    git config user.email "jenkins@jenkins.ume.entsoe.eu"

    # --- Desired release branch ---
    echo "Create release branch"
    git branch "release/${desiredLine}"
    #TODO git push branch

    # --- Future development version ---
    echo "Create future commit"
    futureMinor=$(($minorVersion + 1))
    futureVersion="${majorVersion}.${futureMinor}.0-DEV"

    echo "{\"version\":\"${futureVersion}\"}" > uuapp.json
    git add .
    git commit -m "Future development version ${futureVersion}"    
    #TODO git push

    # --- Desired version to be released ---
    git checkout "release/${desiredLine}"
    echo "{\"version\":\"${desiredVersion}\"}" > uuapp.json
    git add .
    git commit -m "Release version ${desiredVersion}"
    git tag "${desiredVersion}"
    #TODO git push

    # --- Desired version to be released ---
    nextPatchVersion=$(($patchVersion + 1))
    nextDesiredVersion="${majorVersion}.${minorVersion}.${nextPatchVersion}"
    nextReleaseVersion="${nextDesiredVersion}-DEV"
    echo "{\"version\":\"${nextReleaseVersion}\"}" > uuapp.json
    git add .
    git commit -m "Release version ${nextReleaseVersion}"
    #TODO git push
fi

git checkout $BRANCH