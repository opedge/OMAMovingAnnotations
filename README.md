OMAMovingAnnotations
====================

Moving annotations for iOS MapView.

## How To Get Started

### Installation with CocoaPods

I recommend you to take a look at [CocoaPods](http://cocoapods.org) and use it for dependency management in your iOS projects.

To add OMAMovingAnnotations to your project it is necessary that the following lines are in your Podfile:

```ruby
platform :ios, '7.0'
pod "OMAMovingAnnotations", "~> 1.0"
```

### Usage

Basic usage is implemented in MoveDemo project. You should subclass OMAMovingAnnotation and add it's instance to OMAMovingAnnotationsAnimatorInstance. After these steps you can invoke startAnimating method on animator instance.

## Requirements

  - Supported build target - iOS 7.1
  - Earliest supported deployment target - iOS 6.0

## Notes

This library has some perfomance issues. Feel free to fix it and contact me. I'm open for merge requests!

## License

OMAMovingAnnotations is available under the MIT license. See the LICENSE file for more info.
