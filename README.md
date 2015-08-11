# TTScanView

[![CocoaPods Status](https://cocoapod-badges.herokuapp.com/v/TTScanView/badge.png)](https://cocoapods.org/?q=ttscanview)
![License](https://cocoapod-badges.herokuapp.com/l/TTScanView/badge.png)

A library which shows/reads QR code and barcode easily

<a target="_blank" href="https://raw.githubusercontent.com/tattn/TTScanView/assets/ttscanview.gif">
<img width="30%" height="30%" alt="TTToast" src="https://raw.githubusercontent.com/tattn/TTScanView/assets/ttscanview.gif"></a>

## Installation

### CocoaPods
Install with CocoaPods by adding the following to your Podfile:
```ruby
platform :ios, '8.0'
pod 'TTScanView'
```

### Manually
Add manually:

1. Add TTScanView.swift to your project.
2. Link QuartzCore.

## Examples

```swift
let scanView = ScanView(frame: CGRectMake(0, 0, 300, 300))!
self.view.addSubview(scanView)

// show QR code
scanView.showQRcode("Hello world")

// read QR code
scanView.showCamera(ScanView.CameraType.QRcode)

// read barcode
scanView.showCamera(ScanView.CameraType.Barcode)

// set delegate
scanView!.delegate = self // ScanDelegate

// finished reading QR code / barcode
func detectedCode(code: String) {
	print(code)
}
```

## Objective-C

If you use this library in Objective-C, you need to import the following:

```objc
#import <TTScanView/TTScanView.h>
#import <TTScanView/TTScanView-Swift.h> // auto-generated header file
```

and set [Build Settings]-[Build Options]-[Embeedded Content Contains Swift Code] to `Yes`.

### Examples for Objective-C

```objc
TTScanView* scanView = [TTScanView new];
scanView.delegate = self;

[scanView showQRcode:@"Hello world"];
[scanView showCamera: TTScanViewCameraTypeQRcode];


- (void)detectedCode:(NSString *)code {
	NSLog(@"%@\n", code);
}
```


## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

TTScanView is released under the MIT license. See LICENSE for details.
