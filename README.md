# AYSegmentedControls

iOS Custom SegmentedControls

[![Platform](https://img.shields.io/cocoapods/p/Auk.svg?style=flat)](http://cocoadocs.org/docsets/Auk)
[![License](https://img.shields.io/cocoapods/l/Auk.svg?style=flat)](LICENSE)

![image](https://github.com/Aiur3908/AYSegmentedControls/blob/master/README/Image/Demo.gif)

## Installation

#### CocoaPods
```
pod 'AYSegmentedControls'
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



### AYSegmentedControlsDataSource


