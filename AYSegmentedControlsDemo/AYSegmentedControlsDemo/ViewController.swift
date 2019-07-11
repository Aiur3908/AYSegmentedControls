//
//  ViewController.swift
//  AYSegmentedControlsDemo
//
//  Created by User on 2019/7/11.
//  Copyright © 2019 JerryYou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var segmentedControlsTitles = ["First", "Second", "Third"]
    @IBOutlet weak var segmentedControls: AYSegmentedControls!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControls.dataSource = self
        segmentedControls.delegate = self
    }
}

extension ViewController: AYSegmentedControlsDataSource {
    func numberOfSegments() -> Int {
        return segmentedControlsTitles.count
    }
    
    func titleForSegmentIndex(index: Int) -> String {
        return segmentedControlsTitles[index]
    }
}

extension ViewController: AYSegmentedControlsDelegate {
    func aySegmentedControls(_ aySegmentedControls: AYSegmentedControls,
                             didSelectItemAt index: Int) {
        print(segmentedControlsTitles[index])
    }
}



