# Android Test App

An Android Test App for running CBL-C's catch tests as an Android Instrumented Test.

## How to run

1. Copy pre-built CBL-C to test/platforms/Android/app/libs/libcblite

```
cp -r build_android_out test/platforms/Android/app/libs/libcblite
```

3. Run Android Instrumented Tests

* Start Android emulator

  ```
  ${ANDROID_SDK_ROOT}/tools/emulator -list-avds
  ${ANDROID_SDK_ROOT}/tools/emulator avd <emulator-name>
  ```

* Build and Run Tests

  ```
  cd test/platforms/Android

  # Logcat:
  adb logcat -s "CBLC-Verify" & LOGCAT_PID=$!

  # Build and Run Tests
  # Command: gradlew cAT [-PabiFilters=<x86,armeabi-v7a,x86_64,arm64-v8a>]

  ./gradlew cAT 

  # Stop logcat:
  kill $LOGCAT_PID
  ```
  
