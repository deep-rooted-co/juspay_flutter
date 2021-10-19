# juspay_flutter

A flutter plugin for juspay payment SDK.

## Android Setup

1. Add to `android/app/build.gradle`
```gradle
apply plugin: 'hypersdk-asset-plugin'
```

2. Create file `android/app/Merchant.txt` with the following content
```txt
clientId = <your client id>
```

## iOS Setup