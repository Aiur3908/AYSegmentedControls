# AYSegmentedControls

Custom SegmentedControls

[![Swift 4.2](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/AYSegmentedControls.svg?style=flat)](https://cocoapods.org/pods/AYSegmentedControls)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.com/Aiur3908/AYSegmentedControls.svg?branch=master)](https://travis-ci.com/Aiur3908/AYSegmentedControls)
[![Platform](https://img.shields.io/cocoapods/p/RxFlow.svg?style=flat)](https://cocoapods.org/pods/AYSegmentedControls)
[![License](https://img.shields.io/cocoapods/l/RxFlow.svg?style=flat)](https://cocoapods.org/pods/AYSegmentedControls)
![image](https://github.com/Aiur3908/AYSegmentedControls/blob/master/README/Image/Demo.gif)

## Installation

#### CocoaPods
```
pod 'AYSegmentedControls'
```
#### Carthage
```
github "Aiur3908/AYSegmentedControls"
```
#### Manually
Add the `AYSegmentedControls.swift` file to your project.

## Usage

### Initialization

### init(coder:) (storyboard or xib)

1. Add UIView

![image](https://github.com/Aiur3908/AYSegmentedControls/blob/master/README/Image/Storyboard001.png)

2. Set AYSegmentedControls as Custom Class.

![image](https://github.com/Aiur3908/AYSegmentedControls/blob/master/README/Image/Storyboard002.png)

3. Connect IBOutlet

![image](https://github.com/Aiur3908/AYSegmentedControls/blob/master/README/Image/Storyboard003.png)

### init(frame: )

```Swift
let segmentedControls = AYSegmentedControls(frame: CGRect(x: 100,
                                                          y: 100,
                                                          width: 300,
                                                          height: 50))
view.addSubview(segmentedControls)
```


### DataSource & Delegate

```Swift
segmentedControls.dataSource = self
segmentedControls.delegate = self
```

### DataSource

```Swift

///The number of item that the segmentedControls should display.
func numberOfItem(in segmentedControls: AYSegmentedControls) -> Int 

///The string to use as the title of the item.
func segmentedControls(_ segmentedControls: AYSegmentedControls,
                       titleForItemAt index: Int) -> String
```

### Delegate 
```Swift

///Called by the segmentedControls when the user selects an item.
func segmentedControls(_ segmentedControls: AYSegmentedControls,
                       didSelectItemAt index: Int)
                       
```

## Custom Properties

```Swift
///HintView background
var hintColor: UIColor 
///SegmentedControls border width
var borderWidth: CGFloat
///SegmentedControls border color
var bordrColor: CGFloat
///Content padding
var padding: CGFloat 
///Normal status title color
var normalTitleColor: UIColor 
///Selected status title color
var selectedTitleColor: UIColor 
///Title Font
var titleFont: UIFont
```

------

### SelectedIndex 

```Swift
segmentedControls.selectedIndex = 1
```

or

```Swift
segmentedControls.selectIndex(at: 2, animated: true)
```

------

### Author

Jerry You
Email: Aiur3908@gmail.com

### LICENSE
MIT



