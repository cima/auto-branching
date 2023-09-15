#!/bin/bash

function isDesiredLinePresent() {
    desiredLine=$1

    #TODO "origin/release/${desiredLine}"
    if git rev-parse --verify "release/${desiredLine}"
    then
        echo "Release branch for version line ${desiredLine} exists"
        return true
    else
        echo "Release branch for version line ${desiredLine} is missing"
        return false
    fi
}

function isBranchDesired() {
    currentBranch=$1
    desiredLine=$2

    #TODO "origin/release/${desiredLine}"
    if [ "${BRANCH}" == "release/${desiredLine}" ]
    then
        return true
    else
        return false
    fi
}

function branchOutDesiredLine() {
    desiredLine=$1
    git config user.name "Jenkins"
    git config user.email "jenkins@jenkins.ume.entsoe.eu"

    # --- Desired release branch ---
    echo "Create release branch"
    git branch "release/${desiredLine}"
    # TODO git push branch

    # --- Future development version ---
    echo "Create future commit"
    futureMinor=$(($minorVersion + 1))
    futureVersion="${majorVersion}.${futureMinor}.0-DEV"

    # TODO modify all files that contain versions
    echo "{\"version\":\"${futureVersion}\"}" > uuapp.json


    git add .
    git commit -m "Future development version ${futureVersion}"    
    # TODO git push
}

function createDesiredVersion() {
    # --- Desired version to be released ---
    git checkout "release/${desiredLine}"
    echo "{\"version\":\"${desiredVersion}\"}" > uuapp.json
    git add .
    git commit -m "Release version ${desiredVersion}"
    git tag "${desiredVersion}"
    #TODO git push
}