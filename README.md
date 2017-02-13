[![Build Status](https://travis-ci.org/artyom-stv/TextInputKit.svg?branch=develop)](https://travis-ci.org/artyom-stv/TextInputKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# TextInputKit

A Swift framework for formatting text input on iOS, macOS and tvOS.

## Overview

While developing an application, you may encounter a task to format text input of bank card information, phone numbers, etc. TextInputKit strives to help you solve this task efficiently.

TextInputKit is a framework with:
- [consistent Swift API](Documentation/API.md) on iOS, macOS and tvOS;
- built-in formats:
  * [Bank Card Number](Documentation/BuiltinFormats.md#bank-card-number);
  * [Bank Card Expiry Date](Documentation/BuiltinFormats.md#bank-card-expiry-date);
  * [Bank Card Holder Name](Documentation/BuiltinFormats.md#bank-card-holder-name);
  * [Phone Number](Documentation/BuiltinFormats.md#phone-number);
- capability to [add custom formats](Documentation/CustomFormats.md);
- total code coverage.

## Installation

<!--
### CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate TextInputKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'TextInputKit'
end
```

Then, run the following command:

```bash
$ pod install
```
-->

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate TextInputKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "artyom-stv/TextInputKit"
```

Run `carthage update` to build the framework and drag the built `TextInputKit.framework` into your Xcode project.

<!--
### Manually

*TODO: Write the instructions.*
-->

## Usage

### Bind a Format to a Text Field

First, a `TextInputFormat` is created (see how to create [a built-in format](BuiltinFormats.md) or [a custom format](CustomFormats.md)).

```swift
let format = TextInputFormats.bankCardNumber() // -> `TextInputFormat<BankCardNumber>`
```

To drive text input formatting, a `TextInputBinding` is created.

```swift
let textInputBinding = format.bind(to: textField) // -> `TextInputBinding<BankCardNumber>`
```

If you don't need to reuse a format, the code can be shortened to the following:

```swift
let textInputBinding = TextInputFormats.bankCardNumber().bind(to: textField) // -> `TextInputBinding<BankCardNumber>`
```

`textInputBinding` performs the following functions:
* formats text input in `textField` according to `format` (in this case, according to the bank card number format);
* updates `textInputBinding.value` when text in `textField` changes;
* notifies of the events.

The functions mentioned above are performed only while `textInputBinding` is bound to `textField`:
* `textField` is alive;
* `textInputBinding` is alive;
* `textInputBinding.unbind()` isn't called.

### Subscribe to Text Input Events

```swift
textInputBinding.eventHandler = { [unowned self] event in
    switch event {
    case let .editingChanged(state, changes):
        if changes.contains(.value) {
            // Use `state.value`
        }
    default:
        break
    }
}
```

## Requirements

- iOS 8.0+ / macOS 10.10+ / tvOS 9.0+
- Xcode 8.0+
- Swift 3.0+

## Framework Evolution

There are plans to extend the set of built-in formats.

Please, create an issue or comment an existing issue, if you need support of a new format.

Examples of feasible formats:
- Pattern-based Format;
- Decimal Number;
- E-mail.

## License

TextInputKit is released under the MIT license. See LICENSE for details.
