#!/usr/bin/env bash

# TODO: On error, continue, but fail the whole script.
set -e
set -o pipefail

for CONFIGURATION in Debug Release; do
  if [ "$FRAMEWORK_RUN_TESTS" == "YES" ]; then
    xcodebuild -workspace "$TRAVIS_XCODE_WORKSPACE" -scheme "$FRAMEWORK_SCHEME" -sdk "$SDK" -destination "$DESTINATION" -configuration "$CONFIGURATION" ONLY_ACTIVE_ARCH=NO ENABLE_TESTABILITY=YES test
  else
    xcodebuild -workspace "$TRAVIS_XCODE_WORKSPACE" -scheme "$FRAMEWORK_SCHEME" -sdk "$SDK" -destination "$DESTINATION" -configuration "$CONFIGURATION" ONLY_ACTIVE_ARCH=NO build
  fi

  if [ ! -z ${EXAMPLE_SCHEME+x} ]; then
    xcodebuild -workspace "$TRAVIS_XCODE_WORKSPACE" -scheme "$EXAMPLE_SCHEME" -sdk "$SDK" -destination "$DESTINATION" -configuration "$CONFIGURATION" ONLY_ACTIVE_ARCH=NO build
  fi
done
