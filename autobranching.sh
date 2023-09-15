#!/bin/bash
set -e
#set -x
. .env
. autobranchingLib.sh

desiredVersion="${majorVersion}.${minorVersion}.${patchVersion}"
desiredLine="${majorVersion}.${minorVersion}"

echo $desiredVersion
echo $desiredLine

desiredLineExists=$(isDesiredLinePresent $desiredLine)
isCurrentBranchDesired=$(isBranchDesired $BRANCH $desiredLine)


echo $desiredLineExists
echo $isCurrentBranchDesired

if [ $desiredLineExists == false ] && [ $isCurrentBranchDesired == false ]
then
    echo "Unsupported state. Either release new line or start from release branch."
    exit 1
fi

if [ $desiredLineExists == false ]
then
    branchOutDesiredLine $desiredLine
fi

if git rev-parse --verify "${desiredVersion}"
then
    echo "Desired version tag ${desiredVersion} alredy exists. Figure out version file correction and start over."
    exit 2
fi

# --- Desired version to be released ---
createDesiredVersion

# --- Desired version to be released ---
nextPatchVersion=$(($patchVersion + 1))
nextDesiredVersion="${majorVersion}.${minorVersion}.${nextPatchVersion}"
nextReleaseVersion="${nextDesiredVersion}-DEV"
echo "{\"version\":\"${nextReleaseVersion}\"}" > uuapp.json
git add .
git commit -m "Release version ${nextReleaseVersion}"
#TODO git push

git checkout $desiredVersion
git rev-parse HEAD > GIT_COMMIT.sha1

# TODO create

# return to initial branch
git checkout $BRANCH