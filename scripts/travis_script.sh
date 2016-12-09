#!/usr/bin/env bash

for CONFIGURATION in Debug Release; do
  if [ "$FRAMEWORK_RUN_TEST" == "YES" ]; then
    echo xcodebuild -workspace "$TRAVIS_XCODE_WORKSPACE" -scheme "$FRAMEWORK_SCHEME" -sdk "$SDK" -destination "$DESTINATION" -configuration "$CONFIGURATION" ONLY_ACTIVE_ARCH=NO ENABLE_TESTABILITY=YES test
  else
    echo xcodebuild -workspace "$TRAVIS_XCODE_WORKSPACE" -scheme "$FRAMEWORK_SCHEME" -sdk "$SDK" -destination "$DESTINATION" -configuration "$CONFIGURATION" ONLY_ACTIVE_ARCH=NO build
  fi

  if [ ! -z ${EXAMPLE_SCHEME+x} ]; then
    echo xcodebuild -workspace "$TRAVIS_XCODE_WORKSPACE" -scheme "$EXAMPLE_SCHEME" -sdk "$SDK" -destination "$DESTINATION" -configuration "$CONFIGURATION" ONLY_ACTIVE_ARCH=NO build
  fi
done
