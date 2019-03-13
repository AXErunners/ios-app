# TinyCborObjc

[![CI Status](https://img.shields.io/travis/axerunners/TinyCborObjc.svg?style=flat)](https://travis-ci.org/axerunners/TinyCborObjc)
[![Version](https://img.shields.io/cocoapods/v/TinyCborObjc.svg?style=flat)](https://cocoapods.org/pods/TinyCborObjc)
[![License](https://img.shields.io/cocoapods/l/TinyCborObjc.svg?style=flat)](https://cocoapods.org/pods/TinyCborObjc)
[![Platform](https://img.shields.io/cocoapods/p/TinyCborObjc.svg?style=flat)](https://cocoapods.org/pods/TinyCborObjc)

TinyCborObjc allows encoding Foundation-objects into CBOR representation.

Supported types:
- `NSDictionary`
- `NSArray`
- `NSString`
- `NSNumber`
- `NSNull`

## Usage

``` objective-c
#import <TinyCborObjc/NSObject+DSCborEncoding.h>

NSDictionary *dictionary = ...;
NSData *cborData = [dictionary ds_cborEncodedObject];
```

## Dependencies

Build on top of [tinycbor](https://github.com/intel/tinycbor) library (integrated as pod dependency).

## Installation

TinyCborObjc is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TinyCborObjc'
```

## Author

Andrew Podkovyrin, podkovyrin@gmail.com

## License

TinyCborObjc is available under the MIT license. See the LICENSE file for more info.
