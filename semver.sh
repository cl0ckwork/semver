#!/usr/bin/env bash

PATCH_TYPE=${1};

if [[ ${PATCH_TYPE} == *"patch"* ]] || [[ ${PATCH_TYPE} == *"minor"* ]] || [[ ${PATCH_TYPE} == *"major"* ]]; then
    echo -e "\n - Starting release process for ${PATCH_TYPE}";
    git checkout develop

    VERSION=$(npm version ${PATCH_TYPE});
#    cd ..

    echo -e "\n - Current git tag w/ commit: $(git describe --tags)";
    RELEASE_BRANCH="release/${VERSION}";

    echo -e "\n - Updating(${PATCH_TYPE}) version to ${VERSION} ";
    git checkout -b ${RELEASE_BRANCH};

    echo -e "\n - Cutting ${RELEASE_BRANCH} branch";
    git commit -a -m "Bump version to ${VERSION}" && git push -u origin ${RELEASE_BRANCH};

    echo -e "\n - Tagging commits and requesting PR to master";
    git tag -a ${VERSION} -m "Bump version to ${VERSION}" --force;
    git push origin ${VERSION};
    git request-pull origin/master ${RELEASE_BRANCH};

    echo -e "\n - Merging ${RELEASE_BRANCH} into develop";
    git checkout develop;
    git merge master
    git push origin develop;

    echo -e "\n - Done";
else
    echo "ERROR: You must provide an npm patch type (patch, minor, major)";
fi;
