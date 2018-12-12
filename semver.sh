#!/usr/bin/env bash

PATCH_TYPE=${1};

if [[ ${PATCH_TYPE} == *"patch"* ]] || [[ ${PATCH_TYPE} == *"minor"* ]] || [[ ${PATCH_TYPE} == *"major"* ]]; then
    echo -e "\n - Starting release process for ${PATCH_TYPE}";
    git checkout develop;
    git pull origin develop;

    NEW_NPM_VERSION=$(npm version ${PATCH_TYPE} -m "Bump version to %s");
    NEW_VERSION=${NEW_NPM_VERSION/v/};

    echo -e "\n - Current git tag version: $(git describe --tags)";
    RELEASE_BRANCH="release/${NEW_VERSION/v/}";

    echo -e "\n - Updating(${PATCH_TYPE}) version to ${NEW_VERSION} ";
    git checkout -b ${RELEASE_BRANCH};
#
    echo -e "\n - Cutting ${RELEASE_BRANCH} branch";
    git commit -m "Bump version to ${NEW_VERSION}";
    git push -u origin ${RELEASE_BRANCH};

    echo -e "\n - Pushing tag to remove";
    git pull origin ${RELEASE_BRANCH};
    git push origin ${NEW_NPM_VERSION}; # need the v in front here, so we use the npm version

    echo -e "\n - Merging ${RELEASE_BRANCH} into develop";
    git checkout develop;
    git merge master;
    git push origin develop;

    echo -e "\n - Done";
else
    echo "ERROR: You must provide an npm patch type (patch, minor, major)";
fi;
