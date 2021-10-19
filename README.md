# juspay_flutter

A flutter plugin for juspay payment SDK.

## Android Setup

1. Add to `android/app/build.gradle`
```gradle
apply plugin: 'hypersdk-asset-plugin'
```

2. Create file `android/app/MerchantConfig.txt` with the following content
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