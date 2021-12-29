# juspay_flutter

A flutter plugin for juspay payment SDK.

[![CI](https://github.com/deep-rooted-co/juspay_flutter/actions/workflows/main.yml/badge.svg)](https://github.com/deep-rooted-co/juspay_flutter/actions/workflows/main.yml)

## Flutter Setup

1. Add plugin dependency in `pubspec.yaml`
```yaml
dependencies:
  juspay_flutter:
    git:
      url: https://github.com/deep-rooted-co/juspay_flutter.git
      ref: <Git Commit SHA>
```
**Note**: This method is only until we get this plugin published to pub.dev

## Android Setup

1. Add to `android/build.gradle`
```gradle
buildscript {
    ....
    repositories {
        ....
        maven {
            url "https://maven.juspay.in/jp-build-packages/hypersdk-asset-download/releases/"
        }
    }

    dependencies {
        ....
        classpath 'in.juspay:hypersdk-asset-plugin:1.0.3'
    }
}
```

2. Add to `android/app/build.gradle`
```gradle
apply plugin: 'hypersdk-asset-plugin'
```

3. Create file `android/app/MerchantConfig.txt` with the following content
```txt
clientId = <your client id>
```

## iOS Setup

1. In `ios/Podfile`
```
post_install do |installer|
  fuse_path = "./Pods/HyperSDK/Fuse.rb"
  clean_assets = true
  if File.exist?(fuse_path)
    if system("ruby", fuse_path.to_s, clean_assets.to_s)
    end
  end
end
```

2. Create file `ios/MerchantConfig.txt` with the following content
```txt
clientId = <your client id>
```
